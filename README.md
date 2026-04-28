# 📱 Multi-Screen Flutter App

A sophisticated frontend-driven Flutter application featuring a seamless navigation flow, dynamic user data handling, and robust form validation. This project demonstrates clean UI architecture and local data persistence.

---

## 🚀 Key Features

* **Dynamic User Flow:** Integration with **Shared Preferences** to persist user data across sessions.
* **Smart Authentication:** * Complete registration logic with real-time **Form Validation**.
    * Dynamic Login screen that automatically reflects the registered user's email.
* **Personalized Experience:** Dashboard and Profile screens dynamically display the user's name and academic details.
* **Modern UI Components:**
    * Custom Dropdown selections.
    * Multi-layered navigation (Dashboard -> Inner Screens).
    * Clean, dark-themed aesthetic for reduced eye strain.

---

## 📸 Application Gallery

<div align="center">
  <table style="width: 100%; text-align: center;">
    <tr>
      <td width="33%"><strong>Registration</strong></td>
      <td width="33%"><strong>Login Flow</strong></td>
      <td width="33%"><strong>Validation Logic</strong></td>
    </tr>
    <tr>
      <td><img src="screenshots/registration_screen.png" width="250"></td>
      <td><img src="screenshots/login.png" width="250"></td>
      <td><img src="screenshots/validation.png" width="250"></td>
    </tr>
    <tr>
      <td><strong>Home Screen</strong></td>
      <td><strong>Dashboard</strong></td>
      <td><strong>User Profile</strong></td>
    </tr>
    <tr>
      <td><img src="screenshots/home.png" width="250"></td>
      <td><img src="screenshots/dashboard.png" width="250"></td>
      <td><img src="screenshots/profilescreen.png" width="250"></td>
    </tr>
    <tr>
      <td><strong>Dropdown Feature</strong></td>
      <td><strong>Inner Screen</strong></td>
      <td></td>
    </tr>
    <tr>
      <td><img src="screenshots/dropdown.png" width="250"></td>
      <td><img src="screenshots/innerscreen1.png" width="250"></td>
      <td></td>
    </tr>
  </table>
</div>

---

## 🛠️ Technical Stack

* **Framework:** Flutter
* **Language:** Dart
* **Data Persistence:** `shared_preferences`
* **State Management:** (Mention yours here, e.g., Provider/GetX/setState)

## 📂 Project Structure
```text
lib/
├── screens/         # All UI Screens (Login, Home, Profile, etc.)
├── models/          # Data models for User profile
├── widgets/         # Reusable custom UI components
└── main.dart        # Entry point and routing logic
