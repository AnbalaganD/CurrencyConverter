# Currency Converter

A robust iOS application designed to provide real-time currency conversion with offline support.

## Features

- **Real-time Conversion**: Convert between multiple currencies using up-to-date exchange rates.
- **Offline Support**: Access previously fetched rates even without an internet connection, powered by Core Data.
- **Smart Caching**: Exchange rates are cached for 30 minutes to minimize network usage and ensure performance.
- **User Preferences**: Remembers your last selected currency for a personalized experience.
- **Search & Filter**: Easily find currencies by symbol.

## Tech Stack

- **Language**: Swift
- **UI Framework**: SwiftUI
- **Reactive Programming**: Combine
- **Local Storage**: Core Data
- **Architecture**: MVVM (Model-View-ViewModel)
- **Networking**: URLSession with custom `RemoteService`
- **Testing**: Swift Testing Framework (Unit Tests)

## Setup Instructions

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/AnbalaganD/CurrencyConverter.git
    ```
2.  **Open in Xcode**:
    Open `CurrencyConverter.xcodeproj` in Xcode.
3.  **Run**:
    Select a simulator or connected device and press `Cmd + R` to run the app.

    > **Note**: Ensure you have a valid internet connection for the initial fetch.

## Requirements

- iOS 15.0+
- Xcode 14.0+
