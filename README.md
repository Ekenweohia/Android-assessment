# 🚀 My Flutter To-Do App

A clean and simple to-do app built with Flutter that actually works! Perfect for managing your daily tasks with a modern, beautiful interface.

## ✨ What's Inside

This isn't just another basic Flutter app - it's built with real-world best practices:

- **🎯 Smart State Management** - Using Riverpod to keep everything organized
- **🌐 Real API Integration** - Connects to DummyJSON for realistic data handling
- **🔒 Type-Safe Models** - Freezed ensures your data structures are bulletproof
- **🧭 Smooth Navigation** - GoRouter handles all the screen transitions
- **🎨 Beautiful Design** - Material 3 theming for that modern Google look
- **🧪 Well Tested** - Unit and widget tests so you know it works

## 🏃‍♂️ Get Started in 30 Seconds

bash
git clone [https://github.com/Ekenweohia/Android-assessment]
cd myapp
flutter pub get
flutter run


That's it! Your app should be running on your device or emulator.

## 📁 How It's Organized

I've structured this app like a real production app:


lib/
├── api/                ← Retrofit-style Dio interfaces
├── models/             ← Freezed data classes & JSON (de)serialization
├── repositories/       ← Business logic & API wrappers
├── viewmodels/         ← Riverpod StateNotifiers (MVVM “ViewModels”)
├── ui/                 ← Screens & widgets
│   ├── auth/           ← Login & Signup screens
│   └── tasks/          ← Task list & create-task screens
├── theme/              ← AppTheme (Material 3)
└── main.dart           ← App entrypoint & GoRouter setup

test/                   ← Unit & widget tests





## 🛠️ Need to Make Changes?

If you modify any of the data models, just run this command to regenerate all the boilerplate:

bash

flutter pub run build_runner build --delete-conflicting-outputs


## 🎯 Why This Architecture?

- MVVM Pattern - Separates UI from business logic
- Riverpod - Makes state management actually enjoyable
- Repository Pattern - Clean separation between data and UI
- Immutable Models - Prevents accidental bugs
