# Weather-App
iOS WeatherApp - take home iOS coding assignment

This iOS weather app fetches and displays real-time weather data using the [OpenWeatherMap API](https://openweathermap.org/api). The app is built using the **MVVM-C** architecture, with a combination of **UIKit** and **SwiftUI**. The application supports location-based weather fetching, user-specified city searches, image caching for weather icons, and localization for multiple languages.

## Features
- Fetches weather data by city, state, country, or user's current location.
- Displays current temperature, weather description, humidity, wind speed, and wind direction.
- Shows a weather icon, which is cached to optimize network performance.
- Supports portrait and landscape orientations.
- Localizable for multiple languages (e.g., French, Spanish, German, Hindi).
- Error handling for network issues, invalid inputs, and permission denials.
- Accessible for VoiceOver users and other accessibility features.
- Remembers the last city searched and auto-loads its weather on app launch.

## Project Structure
The project follows **MVVM-C (Model-View-ViewModel-Coordinator)** architecture:

- **Model**: Handles the weather data and business logic.
- **View**: The user interface using a mix of **UIKit** and **SwiftUI**.
- **ViewModel**: Manages the data and logic for the views.
- **Coordinator**: Responsible for the flow of the app and navigation between different screens.

## Dependencies
The app relies solely on **native Swift and Apple frameworks**, with no third-party libraries, to ensure maximum compatibility and performance.

### Frameworks Used
- **UIKit**: For building user interfaces and managing the app lifecycle.
- **SwiftUI**: For modern declarative UI components.
- **CoreLocation**: For obtaining the user's location.
- **URLSession**: For making network requests to the OpenWeatherMap API.
- **UserDefaults**: For storing the last searched city.
- **NSCache**: For caching weather icons.
- **Accessibility APIs**: To support VoiceOver and dynamic type features.
- **Localization APIs**: To support multiple languages.

## Setup Instructions
### Prerequisites
- Xcode 15+
- An active internet connection to fetch weather data.
- An API key from [OpenWeatherMap](https://home.openweathermap.org/users/sign_up).

### Steps to Run
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/weather-app.git
   cd weather-app
   ```

2. Open the Xcode project:
   ```bash
   open WeatherApp.xcodeproj
   ```

3. Set your OpenWeatherMap API key in the `WeatherService.swift` file:
   ```swift
   let apiKey = "YOUR_API_KEY"
   ```

4. Build and run the app on the iOS Simulator or a physical device.

## Usage
1. **Search Weather by City**: Enter a city, state, and country to fetch the current weather data.
2. **Current Location**: If location access is granted, the app will automatically fetch and display the weather for your current location on launch.
3. **Last City Searched**: If no location access is provided, the app will load the last city you searched.
4. **Change Language**: Change the language of the app from the device's **Settings > General > Language & Region**.

## Code Overview

### WeatherService.swift
Handles all network requests to the OpenWeatherMap API and returns parsed weather data.

### WeatherViewModel.swift
Acts as the intermediary between the `WeatherService` and the views, ensuring the proper data format is passed to the UI.

### WeatherViewController.swift
Displays the weather data using **UIKit** components and manages user interactions such as city searches and fetching location-based weather.

### Coordinator.swift
Manages navigation between screens, handling the initial setup of the main view controller and additional views as necessary.

### Localization
The app supports multiple languages using `Localizable.strings`. To add support for a new language:
1. Add a new `Localizable.strings` file for the desired language.
2. Provide translations for all necessary strings.

## Optimizations
1. **Image Caching**: Weather icons are cached using `NSCache` to prevent repeated downloads and improve performance.
2. **Error Handling**: The app gracefully handles network failures, incorrect user inputs, and denied location permissions.
3. **Memory Management**: `weak` references are used where necessary to prevent memory leaks, and background tasks are managed efficiently.

## Accessibility
- Full support for **VoiceOver**.
- Dynamic Type support, ensuring the app adapts to the user's preferred text size.
- All interactive elements are accessible with descriptive labels.

## Future Improvements
- **Unit Tests**: While basic unit tests have been included, additional tests can be written to further ensure code reliability.
- **Performance Enhancements**: Given more time, additional optimizations could be made, such as refining API calls, improving memory management, and further caching strategies.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

```

### Key Sections:
- **Project Overview**: Explains the project and its architecture.
- **Features**: Describes what the app can do.
- **Setup Instructions**: Guides how to run the project locally.
- **Code Overview**: Summarizes key parts of the code structure.
- **Optimizations**: Highlights the performance improvements.
- **Accessibility**: Covers the accessibility features of the app.
- **Future Improvements**: Outlines potential future work if given more time.

This README provides a comprehensive overview of the app, guiding users through installation and explaining the technical aspects of the project.
