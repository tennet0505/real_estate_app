import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/presentation/helpers/app_images.dart';
import 'package:real_estate_app/presentation/maps/widgets/poi_detail_widget.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapScreen extends StatefulWidget {
  final List<House> houses;

  const MapScreen({super.key, required this.houses});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin {
  late GoogleMapController mapController;
  final LatLng _initialPosition = const LatLng(52.3676, 4.9041); // Amsterdam
  Set<Marker> _markers = {};
  BitmapDescriptor? _customIcon;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
    _loadCustomMarker();
  }

  @override
  void didUpdateWidget(MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.houses != oldWidget.houses) {
      _updateMarkers(); // Reload markers when house list updates
    }
  }

  Future<void> _loadCustomMarker() async {
    final customIcon = await _getBytesFromAsset(AppImages.logo, 24);
    setState(() {
      _customIcon = BitmapDescriptor.bytes(customIcon);
    });
    _updateMarkers(); // Update markers after loading icon
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? byteData =
        await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void _updateMarkers() {
    if (_customIcon == null) {
      return; // Prevent updating before the icon is ready
    }
    setState(() {
      _markers = widget.houses
          .map((house) => Marker(
                markerId: MarkerId(house.id.toString()),
                position: LatLng(house.latitude, house.longitude),
                icon: _customIcon!, // Apply the custom marker icon
                onTap: () {
                  _showPoiBottomSheet(context, house);
                },
                infoWindow: InfoWindow(
                  title: house.zip,
                  snippet: '€${house.price.toString()}',
                ),
              ))
          .toSet();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _updateMarkers();
  }

  @override
  bool get wantKeepAlive => true;

  void _loadMarkers() {
    setState(() {
      _markers = widget.houses
          .map((house) => Marker(
                markerId: MarkerId(house.id.toString()),
                position: LatLng(house.latitude, house.longitude),
                onTap: () {
                  _showPoiBottomSheet(context, house);
                },
                infoWindow: InfoWindow(
                  title: house.zip,
                  snippet: '€${house.price.toString()}',
                ),
              ))
          .toSet();
    });
  }

  void _showPoiBottomSheet(BuildContext context, House housePoi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              '/detail_screen',
              arguments: housePoi,
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            child: PoiDetailWidget(house: housePoi),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 8.0,
        ),
        markers: _markers,
      ),
    );
  }
}
