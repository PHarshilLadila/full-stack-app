# 🚀 Full Stack Mobile App
### Flutter + Dart Frog + MongoDB

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart_Frog-000000?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white"/>
</p>

<p align="center">
  <b>A complete full-stack mobile application with authentication, API integration, and modern architecture.</b>
</p>

---

## 📂 Project Structure

full-stack-app/

├── app_backend/     # Dart Frog backend (APIs + MongoDB)

├── app_frontend/    # Flutter mobile application

---

## 🧠 Overview

This project is built using:

- Flutter (Frontend)
- Dart Frog (Backend)
- MongoDB (Database)
- Render (Deployment)

---

## 🔥 Backend (app_backend)

Backend is built using Dart Frog with MongoDB.

### 🌐 Live API
https://full-stack-app-4vxu.onrender.com

### 📡 APIs

- GET `/`
- POST `/auth/register`
- POST `/auth/login`
- POST `/auth/logout`
- GET `/user/me`
- PUT `/user/update`

### 🔐 Authentication
- JWT-based authentication
- Secure password handling
- Token stored and verified

---

## 📱 Frontend (app_frontend)

Flutter mobile application with:

- BLoC state management
- API integration using HTTP
- Clean UI
- Authentication flow

---

## 📸 Screens

<table>
  <tr>
    <td align="center">
      <b>Splash Screen</b><br>
      <img src="app_frontend/assets/images/preview/splash_screen.jpg" width="180"/>
    </td>
    <td align="center">
      <b>Sign In Screen</b><br>
      <img src="app_frontend/assets/images/preview/signin_screen.jpg" width="180"/>
    </td>
    <td align="center">
      <b>Sign Up Screen</b><br>
      <img src="app_frontend/assets/images/preview/signup_screen.jpg" width="180"/>
    </td>
  </tr>

  <tr>
    <td align="center">
      <b>Home Screen</b><br>
      <img src="app_frontend/assets/images/preview/home_screen.jpg" width="180"/>
    </td>
    <td align="center">
      <b>Profile Screen</b><br>
      <img src="app_frontend/assets/images/preview/update_profile_details_screen.jpg" width="180"/>
    </td>
    <td></td>
  </tr>
</table>

---

## 🛠️ Tech Stack

Frontend:
- Flutter
- BLoC
- HTTP

Backend:
- Dart
- Dart Frog

Database:
- MongoDB

Deployment:
- Render

---

## 🚀 Run Project

### Clone Repo
git clone https://github.com/PHarshilLadila/full-stack-app.git
cd full-stack-app

### Run Backend
cd app_backend
dart pub get
dart run build/bin/server.dart

### Run Frontend
cd app_frontend
flutter pub get
flutter run

---

## 👨‍💻 Author

Harshil Gajipara
