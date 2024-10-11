# AnimeMangaToon Webtoon Explorer App

### Demo
Please wait while it's loading. (It's of 60+mb gif)

<img src="https://github.com/harshsingh-io/anime_mangatoon/blob/main/demo.gif" height="740" alt="Demo GIF">

## Overview
This Flutter application is developed as part of a Flutter Development Internship Assignment for AnimeMangaToon.com. It showcases webtoon content through a user-friendly mobile app interface, focusing on state management, navigation, and persistent storage.

## Features
- **Home Screen**: Lists popular webtoon categories, each with a thumbnail and title.
- **Detail Screen**: Displays detailed information about a webtoon, including an image, description, and a "Add to Favorites" button.
- **Favorites Screen**: Allows users to manage their saved favorite webtoons, with functionality to add or remove favorites.
- **Rating Feature**: Users can rate webtoons on a 1-5 stars scale, with the average rating dynamically displayed on the detail screen.

## Installation

To set up this project on your local machine, follow these steps:

1. **Clone the repository**
   ```bash
   git clone https://github.com/harshsingh-io/anime_mangatoon.git
   cd anime_mangatoon
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## Technologies Used
- **Flutter**: The primary framework used to build the app.
- **Dart**: The programming language used.
- **SharedPreferences** or **Hive**: Used for implementing persistent storage to manage favorites.

## Project Structure
- `lib/`: Contains all Dart files for the application.
- `lib/models/`: Defines data models used in the app.
- `lib/screens/`: Contains all the UI screens.
- `lib/services/`: Includes services for data handling.
- `assets/`: Stores images and other assets used in the app.

## Acknowledgments
- Flutter documentation
- SharedPreferences package
- Hive package
