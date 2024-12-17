// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:real_estate_app/business_logic/house_bloc.dart';
import 'package:real_estate_app/data/clients/repository.dart';
import 'package:real_estate_app/data/models/house.dart';
import 'package:real_estate_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mocking the HouseRepository
class MockHouseRepository extends Mock implements HouseRepository {
  Future<List<House>> getFavoriteHouses() {
    return super.noSuchMethod(
      Invocation.method(#getFavoriteHouses, []),
      returnValue: Future.value([]), // Default return value
      returnValueForMissingStub: Future.value([]),
    );
  }
}

// Mocking SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences sharedPreferences;
  late HouseBloc houseBloc;
  late MockHouseRepository mockHouseRepository;

  setUp(() async {
    // Mock SharedPreferences
    sharedPreferences = MockSharedPreferences();
    
    // Mock HouseRepository
    mockHouseRepository = MockHouseRepository();
    
    // Initialize the HouseBloc with mocked objects
    houseBloc = HouseBloc(mockHouseRepository, sharedPreferences);
  });

  testWidgets('Test HouseBloc with loading state', (WidgetTester tester) async {
    // Stub the repository to return some data
    when(mockHouseRepository.getFavoriteHouses()).thenAnswer(
      (_) async => <House>[], // Empty list for example
    );

    // Build the widget with the HouseBloc
    await tester.pumpWidget(
      BlocProvider.value(
        value: houseBloc,
        child: MyApp(houseBloc: houseBloc),
      ),
    );

    // Check if loading indicator is shown initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Test HouseBloc with error state', (WidgetTester tester) async {
    // Stub the repository to throw an error
    when(mockHouseRepository.getFavoriteHouses())
        .thenThrow(Exception('Failed to load houses'));

    // Build the widget with the HouseBloc
    await tester.pumpWidget(
      BlocProvider.value(
        value: houseBloc,
        child: MyApp(houseBloc: houseBloc),
      ),
    );

    // Check if the error message is displayed
    expect(find.text('Failed to load houses'), findsOneWidget);
  });

  testWidgets('Test HouseBloc with loaded state', (WidgetTester tester) async {
    // Stub the repository to return a list of houses
    when(mockHouseRepository.getFavoriteHouses()).thenAnswer(
      (_) async => [
        House(
          1,
          id: 1,
          price: 1,
          image: 'House 1',
          bedrooms: 1,
          bathrooms: 2,
          size: 1,
          description: 'description 1',
          zip: '1234EE',
          city: 'Den Haag 1',
          latitude: 1,
          longitude: 1,
          createdDate: 'createdDate 1',
        ),
        House(
          2,
          id: 2,
          price: 1,
          image: 'House 2',
          bedrooms: 1,
          bathrooms: 2,
          size: 1,
          description: 'description 2',
          zip: '1234EE',
          city: 'AMS 1',
          latitude: 1,
          longitude: 1,
          createdDate: 'createdDate 2',
        ),
      ],
    );

    // Build the widget with the HouseBloc
    await tester.pumpWidget(
      BlocProvider.value(
        value: houseBloc,
        child: MyApp(houseBloc: houseBloc),
      ),
    );

    // Wait for the data to load
    await tester.pumpAndSettle();

    // Verify the houses are displayed
    expect(find.text('House 1'), findsOneWidget);
    expect(find.text('House 2'), findsOneWidget);
  });
}
