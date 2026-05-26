# TODO App — Firebase Setup Guide

## Step 1: Create Firebase Project
1. Go to https://console.firebase.google.com
2. Click "Add project" → name it (e.g. "todo-app") → Create

## Step 2: Enable Authentication
1. In Firebase Console → Authentication → Get started
2. Sign-in method tab → Enable "Email/Password"
3. Optionally enable "Google" (requires SHA-1 for Android)

## Step 3: Enable Firestore
1. Firestore Database → Create database
2. Start in test mode (for development)
3. Choose a region → Done

## Step 4: Add Firebase to Flutter

### Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### Configure Firebase
```bash
flutterfire configure
```
This generates `lib/firebase_options.dart` automatically.

## Step 5: Update main.dart
Add the options import after generating:
```dart
import 'firebase_options.dart';

// In main():
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## Step 6: Firestore Security Rules
In Firestore → Rules, paste:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/todos/{todoId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Step 7: Run the app
```bash
flutter pub get
flutter run
```

## Project Structure
```
lib/
├── main.dart                          ← Firebase init + auth routing
├── models/
│   └── todo_model.dart                ← Todo data model
├── services/
│   ├── auth_service.dart              ← Email + Google auth
│   └── todo_service.dart              ← Firestore CRUD
├── screens/
│   ├── login_screen.dart              ← Login UI
│   ├── signup_screen.dart             ← Register UI
│   └── home_screen.dart              ← Todo list UI
└── widgets/
    ├── todo_card.dart                 ← Swipeable todo card
    └── add_edit_todo_sheet.dart       ← Bottom sheet form
```
