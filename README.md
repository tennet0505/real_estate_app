# DTT REAL ESTATE

## Overview

The DTT REAL ESTATE App is a feature-rich application for discovering houses based on user preferences. It provides functionalities like searching houses, toggling favorite houses, and managing a wishlist, with seamless offline support.

This project leverages the BLoC (Business Logic Component) architecture for state management, ensuring clean separation of concerns and testability.


## Features
- **Splash Screen**: Displays the DTT branding as the first screen of the app.
- **House Listing**: Fetches house data from an online repository or local database.
- **Search Functionality**: Filters houses by ZIP code or city name.
- **Favorite Management**: Allows users to mark and unmark houses as favorites.
- **Wishlist Management**: Displays the user's favorite houses.
- **Distance Calculation**: Shows distances of houses from the user’s current location and provides a route from the user’s current location to the house.

## Extra Features
- **Offline Support**: Caches house data for offline access.
- **Localization Support**: Supports Dutch and English languages.
- **Dark Mode**: Supports dark mode for improved user experience.
- **Animations**: Fluid animations and custom page transitions to enhance the app's interface.
- **Error Handling**: Handles scenarios like no internet connection and stores responses for offline use.
- **BLoC Provider**: Uses BLoC provider for managing state and business logic.


## Technologies Used

- **Dart**
- **Flutter** for the front-end
- **BLoC** for state management
- **SharedPreferences** for local storage
- **GeoClient** for location-based calculations
- **Connectivity** for internet connectivity checks
- **Easy localization** for localizing app
- **Hive** as storage

## Architecture

The app uses the BLoC pattern for managing state. Key components include:

### `HouseBloc`

- Manages state and events for the house management feature.

### `HouseEvent`

- Defines events like fetching houses, searching, toggling favorites, etc.

### `HouseState`

- Represents the various states of the house management feature.

### `HouseRepository`

- Handles data fetching from online or offline sources.

## How It Works

1. **Fetching Houses:**

   - The app fetches house data from an API or local database, based on connectivity.
   - Houses are cached for offline access.

2. **Search Functionality:**

   - Filters houses by ZIP code or city name in real time.

3. **Favorite Management:**

   - Stores favorite house IDs in `SharedPreferences` for persistence.

4. **Distance Calculation:**

   - Uses `GeoClient` to calculate distances between the user’s current location and each house.

5. **Hive as Storage:**

   - Data is stored locally using Hive, ensuring high-performance, lightweight storage for the app.

## Key Files

- `HouseBloc`: Main BLoC managing house data and events.
- `HouseRepository`: Data layer for fetching house information.
- `GeoClient`: Utility for location-based operations.

## Setup Instructions

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/tennet0505/real_estate_app
   cd real_estate_app
   ```

2. **Install Dependencies:**

   ```bash
   flutter pub get
   ```

3. **Run the App:**

   ```bash
   flutter run
   ```

4. **Test the App:**

   ```bash
   flutter test
   ```

## Handling Connectivity

The app checks for connectivity before fetching house data. If no connection is available, it retrieves cached data from the local database.

## Localization

Error messages and other text strings are localized using the **Easy localization**  utility. Ensure the necessary translations are added for all supported locales.

## Future Improvements

- Add more filters for searching (e.g., by price range, number of bedrooms).
- Improve UI/UX for better user engagement.
- Implement pagination for large datasets.

## Contributing

Contributions are welcome! Please follow the steps below:

1. Fork the repository.
2. Create a new branch.
3. Make changes and commit them.
4. Push your changes and create a pull request.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Contact

For any inquiries, reach out to the project maintainer at [[tennet0505@gmail.com](mailto\:tennet0505@gmail.com)].

