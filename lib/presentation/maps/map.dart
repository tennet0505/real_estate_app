import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart'
    as cluster;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:real_estate_app/business_logic/house_bloc/house_bloc.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/data/models/place.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';
import 'package:real_estate_app/presentation/maps/widgets/poi_detail_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  late final cluster.ClusterManager _clusterManager;
  List<Place> _locations = [];
  BitmapDescriptor? _customIcon;

  @override
  void initState() {
    super.initState();
    context.read<HouseBloc>().add(const GetHouses());
    _setCustomIcon();
    _clusterManager = cluster.ClusterManager<Place>(_locations, _updateMarkers,
        markerBuilder: _markerBuilder,
        stopClusteringZoom: 1.0);


  }

  // Custom marker builder
  Future<Marker> Function(cluster.Cluster) get _markerBuilder =>
      (cluster) async {
        // Ensure each marker has a unique id based on cluster location
        return Marker(
          markerId: MarkerId(
              "${cluster.getId()}_${cluster.location.latitude}_${cluster.location.longitude}"),
          position: cluster.location,
          onTap: () {
            final Place place = cluster.items.first as Place;
            _showPoiBottomSheet(context, place);
          },
          icon: await getClusterBitmap(
            cluster.isMultiple ? 50 : 35,
            text: cluster.isMultiple ? cluster.count.toString() : '',
          ),
        );
      };

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      _markers
        ..clear()
        ..addAll(markers);
    });
  }

  House mapPlaceToHouse(Place place) {
    return House(
      null, // Set distanceFromUser as null for now
      id: place.name.hashCode, // Use a unique value or generate an ID
      image: place.imageUrl,
      price: place.price,
      bedrooms: place.bedrooms,
      bathrooms: place.bathrooms,
      size: place.size,
      description: place.description,
      zip: place.zip,
      city: place.city,
      latitude: place.latitude,
      longitude: place.longitude,
      createdDate: place.createdDate,
    );
  }

  void _showPoiBottomSheet(BuildContext context, Place poi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent, // Make background transparent
      builder: (BuildContext context) {
        final House house = mapPlaceToHouse(poi);
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).pushNamed(
              '/detail_screen',
              arguments: house,
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                16, 0, 16, 100), // Padding for left, right, and bottom
            child: PoiDetailWidget(house: house, poi: poi),
          ),
        );
      },
    );
  }
  
  Future<void> _setCustomIcon() async {
    BitmapDescriptor.asset(
      ImageConfiguration(size: ui.Size(32, 32)),
      AppImages.logo, // Update with your asset path
    ).then((icon) {
      setState(() {
        _customIcon = icon;
      });
    });
  }

  static Future<BitmapDescriptor> getClusterBitmap(int size,
      {required String text}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.red;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  // Method to initialize GoogleMapController
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _clusterManager.setMapId(mapController.mapId);
    setState(() {});
  }

  void _onCameraMove(CameraPosition position) {
    // _clusterManager.updateMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Maps with Clustering')),
      body: BlocBuilder<HouseBloc, HouseState>(
        builder: (context, state) {
          if (state is HouseState) {
            _locations = state.houses
                .map((house) => Place(
                    latLng: LatLng(house.latitude, house.longitude),
                    name: house.zip,
                    imageUrl: house.image,
                    price: house.price,
                    bedrooms: house.bedrooms,
                    bathrooms: house.bathrooms,
                    size: house.size,
                    description: house.description,
                    zip: house.zip,
                    city: house.city,
                    latitude: house.latitude,
                    longitude: house.longitude,
                    createdDate: house.createdDate))
                .toList();

            // Update the cluster manager with the new locations
            _clusterManager.setItems(_locations);

            // Trigger the update of markers
            _clusterManager.updateMap();

            return GoogleMap(
              onMapCreated: _onMapCreated,
              onCameraMove: _onCameraMove,
              initialCameraPosition: const CameraPosition(
                target: LatLng(52.3676, 4.9041),
                zoom: 15.0,
              ),
              markers: _markers,
            );
          } else {
            return Container(); // Return your empty state widget if the state isn't HouseState
          }
        },
      ),
    );
  }
}




