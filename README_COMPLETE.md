# CipherTask - Secure Encrypted To-Do System

A Flutter-based mobile application implementing enterprise-grade security for task management, featuring AES-256 encryption, biometric authentication, and automatic session timeouts.

## 🔒 Security Features

### Core Security Components
- **AES-256 Encryption**: Field-level encryption for sensitive task descriptions
- **SQLCipher/Hive Encryption**: Database-at-rest encryption with hardware-backed keys
- **Biometric Authentication**: Fingerprint unlock (requires prior password login)
- **Hardware-Backed Key Storage**: Encryption keys stored in device secure enclave via Flutter Secure Storage
- **Auto-Logout**: Automatic session timeout after 2 minutes of inactivity
- **Screenshot Prevention**: Prevents unauthorized screenshot capturing (Android/iOS)

## 📋 Features Implemented

✅ **Mandatory Requirements**
- [x] AES-256 Encryption for data at rest
- [x] SQLCipher/Hive encrypted database
- [x] Biometric Authentication with fingerprint
- [x] Hardware-backed key storage (Android Keystore/iOS Keychain)
- [x] Auto-logout after 2 minutes of inactivity
- [x] Strict MVVM Architectural Pattern

✅ **Bonus Features**
- [x] Screenshot prevention
- [ ] OTP (6-digit) during registration (Optional)

## 📁 Project Structure

```
lib/
├── main.dart                           # Entry point (Dependency Injection & Routes)
├── models/                             # Data Layer (POJOs)
│   ├── todo_model.dart                # Task data structure with Hive support
│   └── user_model.dart                # User profile with Hive support
├── views/                              # UI Layer (Screens & Widgets ONLY)
│   ├── login_view.dart                # Biometric & Password Login
│   ├── register_view.dart             # Registration with Biometric option
│   ├── todo_list_view.dart            # Main Secure Task List
│   └── widgets/
│       └── secure_widgets.dart        # Reusable secure input fields
├── viewmodels/                         # Logic Layer (State Management)
│   ├── auth_viewmodel.dart            # Authentication, Biometric, Session logic
│   └── todo_viewmodel.dart            # CRUD operations with encryption
├── services/                           # Data & Security Services
│   ├── encryption_service.dart        # AES-256 Encryption/Decryption
│   ├── database_service.dart          # Encrypted Hive Box management
│   ├── key_storage_service.dart       # FlutterSecureStorage wrapper
│   └── session_service.dart           # Inactivity Timer logic
└── utils/
    └── constants.dart                  # App configurations & constants
```

## 🔧 Technical Stack

### Dependencies
- **Provider**: State management and MVVM architecture
- **GetIt**: Service locator for dependency injection
- **Hive**: Lightweight encrypted NoSQL database
- **Encrypt**: AES-256 encryption library
- **FlutterSecureStorage**: Hardware-backed secure key storage
- **LocalAuth**: Biometric authentication (fingerprint, face recognition)
- **FlutterWindowManager**: Screenshot prevention

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10.8 or higher
- Android Studio / Xcode with emulator or physical device
- Git

### Installation

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd cypher_task_app
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive Adapters** (Code generation)
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

## 📱 Building APK

### Android APK Build

```bash
# Debug APK
flutter build apk --debug

# Release APK (Recommended for production)
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS Build (if applicable)

```bash
flutter build ios --release
```

## 🔐 Authentication Flow

### Registration
1. User enters email, password, and full name
2. Optional: Enable biometric authentication
3. Password is hashed and stored securely
4. User automatically logged in post-registration

### Login
1. **Password Login**: Email and password authentication
2. **Biometric Login**: Fingerprint unlock (only if enabled during registration)
3. Session initialized with 2-minute inactivity timeout

### Session Management
- Activity timer resets on every user interaction (touch, scroll, input)
- Automatic logout after 2 minutes of inactivity
- Session data securely stored in encrypted Hive box

## 🛡️ Encryption Details

### Database Encryption
- Algorithm: AES
- Key Size: 256-bit
- Storage: Hardware-backed secure storage on first app launch
- Fresh key generated and stored in FlutterSecureStorage

### Field-Level Encryption
- Sensitive fields (task descriptions) are encrypted before storing
- IV (Initialization Vector) generated per encryption operation
- Decryption happens on-demand when viewing task details

## 👥 Team Members and Roles

| Member | Role | Responsibilities |
|--------|------|------------------|
| Team Lead (M1) | Project Lead | Project initialization, architecture setup, GitHub repo management |
| Member 2 (M2) | Backend/Security | Encryption service, database service, security implementation |
| Member 3 (M3) | Frontend | UI views, widgets, user experience design |
| Member 4 (M4) | Architecture | MVVM pattern implementation, dependency injection, state management |

## 📝 Usage Examples

### Adding a Task
1. Tap the "+" button on the Todo List screen
2. Enter task title (required)
3. Optionally add description (will be encrypted)
4. Set due date and priority level
5. Task is automatically encrypted and saved to secure database

### Enabling Biometric
1. During registration, check "Enable Biometric Authentication"
2. On next login, use fingerprint instead of password
3. Must have set up biometric on device first

### Session Timeout
- App auto-locks after 2 minutes of inactivity
- User is redirected to login screen
- Previous state is cleared for security

## 🧪 Testing Credentials

### Demo Account
```
Email: demo@example.com
Password: Demo@123456
```

## 📦 Dependencies Overview

| Package | Version | Purpose |
|---------|---------|---------|
| provider | ^6.0.0 | State management |
| get_it | ^7.5.0 | Service locator |
| hive | ^2.2.0 | Database |
| hive_flutter | ^1.1.0 | Flutter database adapter |
| encrypt | ^4.0.0 | AES encryption |
| flutter_secure_storage | ^9.0.0 | Secure key storage |
| local_auth | ^2.1.0 | Biometric auth |
| flutter_windowmanager | ^0.4.0 | Screenshot prevention |

## 🔗 GitHub Repository

- **Repository**: [Public GitHub Link]
- **License**: MIT (or as per requirements)
- **Status**: ✅ Complete with all mandatory features

## 📱 APK Distribution

- **File**: `cypher_task_app-release.apk`
- **Size**: ~50-80 MB (varies with build)
- **Compatible**: Android 8.0 (API 26) and above
- **Architecture**: ARM64, ARMv7

## ⚙️ Configuration

### Timeout Settings (in `lib/utils/constants.dart`)
```dart
static const int sessionTimeoutMinutes = 2;  // Auto-logout after 2 minutes
```

### Encryption Settings
```dart
static const int aesKeyLength = 32;          // 256-bit AES key
static const int aesIvLength = 16;           // 128-bit IV
```

## 🐛 Troubleshooting

### Issue: Hive box already open
**Solution**: Run `flutter clean && flutter pub get`

### Issue: Biometric not detected
**Solution**: Ensure device has biometric enrolled and app has permission

### Issue: Encryption key not found
**Solution**: Clear app data and reinstall (fresh key will be generated)

## 🚦 Known Limitations

1. Only one user per device (simplified model)
2. Biometric only works post-first password login
3. OTP feature (bonus) not implemented in this version

## 📚 References

- [Flutter Security Best Practices](https://flutter.dev/docs/development/best-practices/security)
- [SQLCipher Documentation](https://www.zetetic.net/sqlcipher/)
- [NIST Cryptography Standards](https://csrc.nist.gov/)

## 📄 License

This project is provided for educational purposes as part of laboratory exercise on secure application development.

---

**Last Updated**: March 2026  
**Version**: 1.0.0  
**Status**: ✅ Production Ready
