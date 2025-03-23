# 🌦️ Flutter Weather App

This is a Flutter application that fetches weather data using an API from weatherapi.com

## 🚀 Features

- Fetches weather data from an API.
- Works on both **Android, iOS, and Web**.

---

## 📌 Prerequisites

Before running this project, ensure you have the following:

- Flutter installed (`flutter doctor` to check).
- Firebase set up for your Flutter project ([Firebase Setup Guide](https://firebase.flutter.dev/docs/overview/)).
- A valid **Firebase Remote Config** key for the API.

---

## 🛠️ Installation & Setup

### 1️⃣ Clone the repository

```sh
git clone https://github.com/yourusername/flutter-weather-app.git
cd flutter-weather-app
```



### 2️⃣ Install dependencies

```sh
flutter pub get
```

### 3️⃣ Set up Firebase

- Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
- Download and place `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) into your app.
- Enable **Firebase Remote Config** in the Firebase Console.

### 4️⃣ Add API Key to Firebase Remote Config

1. Go to **Firebase Console → Remote Config**.
2. Create a new parameter:
   - **Key**: `weather_api_key`
   - **Value**: `"your-api-key"`
3. Save and **Publish Changes**.

---

## 🚀 Running the App Locally

To run the app on an emulator or device:

```sh
flutter run
```

For Flutter Web:

```sh
flutter run -d chrome
```

---

## 🌍 Demo Link

🔗 [Demo Web](https://drive.google.com/file/d/10TwgN3Z1HZq5mQMH5nRD97CHhaPQYJFj/view?usp=sharing)

🔗 [Demo Mobile](https://drive.google.com/file/d/1eSViCr3Qg9W76TdaP9dwGQK46lT12AC1/view?usp=sharing)

---

## 📜 License

This project is licensed under the **MIT License**. Feel free to modify and use it in your own projects.

---

