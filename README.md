# GreenEats

GreenEats is a Flutter food-ordering app with:

- Firebase Authentication and Firebase Messaging (`lib/main.dart`, `lib/widgetTree.dart`)
- MongoDB-backed menu data (`lib/MongoDB/mongodb.dart`)
- Cart state management using Redux (`lib/Cart`, `lib/Components/orderStatus.dart`)
- Local notifications for order updates (`lib/Notification/Notifications.dart`)

## Prerequisites

- Flutter SDK (Dart SDK range is `>=3.1.0 <4.0.0` in `pubspec.yaml`)
- Android Studio or Xcode for mobile builds
- A Firebase project configured for this app
- A reachable MongoDB cluster

## Project setup

1. Install dependencies:

   ```bash
   flutter pub get
   ```

2. Configure MongoDB connection:
   - Update `MONGO_CONN_URL` in `/lib/MongoDB/constant.dart`.
   - Keep collection names aligned with your database documents.

3. Configure Firebase:
   - This repo already includes FlutterFire-generated options in `/lib/Firebase/firebase_options.dart`.
   - Platform config files are present in:
     - `/android/app/google-services.json`
     - `/ios/firebase_app_id_file.json`
     - `/macos/firebase_app_id_file.json`
   - If you change Firebase projects, regenerate `firebase_options.dart` and replace platform config files.

4. Run the app:

   ```bash
   flutter run
   ```

## Developer commands

- Static analysis:

  ```bash
  flutter analyze
  ```

- Tests:

  ```bash
  flutter test
  ```

## Repository layout

- `/lib/main.dart` – app bootstrap, Firebase initialization, MongoDB connect
- `/lib/Screens` – UI screens (login/register, menu flow, ordering)
- `/lib/MongoDB` – MongoDB connection and constants
- `/lib/Firebase` – authentication wrapper and FlutterFire options
- `/lib/Cart` – cart state and persistence utilities
