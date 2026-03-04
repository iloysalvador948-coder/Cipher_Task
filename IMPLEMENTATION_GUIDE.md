# CipherTask - Laboratory Implementation Guide

## 📋 Complete Setup Instructions for Team

This document contains step-by-step instructions to finalize the CipherTask application setup.

## ✅ Completed Components

### 1. **Dependencies Setup** ✓
- ✅ All required packages added to `pubspec.yaml`
- ✅ Dev dependencies for code generation configured
- ✅ `flutter pub get` ready to run

### 2. **Project Structure** ✓
- ✅ Models layer: `todo_model.dart`, `user_model.dart`
- ✅ Services layer: Encryption, Database, Key Storage, Session Management
- ✅ ViewModels layer: Auth and Todo management
- ✅ Views layer: Login, Register, Todo List with widgets
- ✅ Utils layer: Constants and configurations

### 3. **Security Features Implemented** ✓
- ✅ AES-256 Encryption Service
- ✅ FlutterSecureStorage integration
- ✅ Hardware-backed key storage wrapper
- ✅ Biometric authentication setup
- ✅ Auto-logout with session timeout
- ✅ Screenshot prevention (Android/iOS)

### 4. **MVVM Architecture** ✓
- ✅ Clean separation of concerns
- ✅ Provider-based state management
- ✅ Dependency injection with GetIt
- ✅ ViewModel pattern with ChangeNotifiers

## 🚀 Next Steps for Team

### Step 1: Generate Hive Adapters

The models use Hive for encrypted storage. Generate the necessary adapter code:

```bash
cd /d/flutter_codes/cypher_task_app
flutter pub run build_runner build
```

This will create:
- `lib/models/todo_model.g.dart`
- `lib/models/user_model.g.dart`

**Expected Output:**
```
[INFO] BuildContext: Running build ...
[INFO] Successfully ran 1 build task ...
```

### Step 2: Get Flutter Packages

Download all dependencies:

```bash
flutter pub get
```

### Step 3: Platform-Specific Setup

#### Android Setup
1. Open `android/app/build.gradle.kts`
2. Ensure `/minSdkVersion` is at least 21:
   ```kotlin
   android {
       compileSdk = 34
       ...
       defaultConfig {
           minSdk = 21  // For FlutterSecureStorage
       }
   }
   ```

2. Ensure `flutter_windowmanager` permissions in `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.PACKAGE_USAGE_STATS" />
   ```

#### iOS Setup (Optional)
1. Open `ios/Podfile`
2. Ensure iOS deployment target is at least 11.0
3. Run: `flutter pub get` (handles CocoaPods automatically)

### Step 4: Run the Application

```bash
flutter run
```

**First Run Behavior:**
1. Shows CipherTask splash screen (2 seconds)
2. Redirects to Login screen
3. User can register or login

### Step 5: Build APK for Testing

```bash
# Debug build (faster, includes logging)
flutter build apk --debug

# Release build (optimized for production)
flutter build apk --release
```

Output location: `build/app/outputs/flutter-apk/`

## 🧪 Testing Checklist

### Authentication Testing
- [ ] User can register with email and password
- [ ] Biometric option visible on registration (if device supports)
- [ ] Password validation works (min 8 characters)
- [ ] Login with registered credentials works
- [ ] Biometric login works (if enabled)
- [ ] Invalid credentials show error message

### Todo Management Testing
- [ ] Can add new tasks
- [ ] Tasks appear in list
- [ ] Can toggle completion status
- [ ] Can view task details (including decrypted description)
- [ ] Can delete tasks
- [ ] Priority levels are displayed correctly
- [ ] Due dates are saved and displayed

### Security Testing
- [ ] App blocks screenshots (try taking screenshot)
- [ ] Auto-logout works after 2 minutes of inactivity
- [ ] Pressing logout clears session
- [ ] Database is encrypted (check local storage is unreadable)
- [ ] Descriptions are encrypted in database

## 🔑 Key Implementation Details

### Session Timeout Configuration
File: `lib/utils/constants.dart`
```dart
static const int sessionTimeoutMinutes = 2;  // Change if needed
```

### Database Encryption
- **Location**: `lib/services/database_service.dart`
- **Algorithm**: AES with 256-bit key
- **Auto-initialized** on first app run
- Key stored in device secure enclave

### Field Encryption
- **Sensitive fields**: Task descriptions
- **On save**: Encrypted with AES-256
- **On retrieve**: Decrypted on-demand
- **File**: `lib/services/encryption_service.dart`

## 📊 Project Statistics

| Metric | Count |
|--------|-------|
| Dart Files | 13+ |
| Total Lines of Code | 1500+ |
| Services | 4 |
| ViewModels | 2 |
| Views | 4 |
| Models | 2 |

## 🐛 Common Issues & Solutions

### Issue 1: "Hive box already open"
```bash
flutter clean
flutter pub get
flutter run
```

### Issue 2: Build Runner Errors
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue 3: Platform code not found
```bash
flutter pub get
cd android && ./gradlew clean
cd ..
flutter run
```

### Issue 4: Biometric not working
- **Android**: Ensure device has enrolled biometric
- **iOS**: Ensure Face ID/Touch ID is set up
- Check device settings

## 📝 Code Generation Notes

The following files are auto-generated and should NOT be edited manually:
- `lib/models/todo_model.g.dart`
- `lib/models/user_model.g.dart`

To regenerate after model changes:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🎯 Deliverables Summary

### Code Deliverables
- ✅ Fully implemented Flutter app with MVVM architecture
- ✅ All security features integrated
- ✅ Database encryption with Hive
- ✅ Biometric authentication setup
- ✅ Auto-logout mechanism
- ✅ Complete UI with error handling

### Documentation
- ✅ README.md (GitHub repository)
- ✅ Implementation Guide (this file)
- ✅ Code comments throughout for clarity
- ✅ Helpful error messages for debugging

### APK File
- Build using: `flutter build apk --release`
- Location: `build/app/outputs/flutter-apk/app-release.apk`

## 🔗 Repository Setup

### Creating GitHub Repository
1. Go to GitHub and create a new public repository
2. Clone this project as template
3. Push to your repository:
   ```bash
   git init
   git add .
   git commit -m "Initial CipherTask implementation"
   git remote add origin <your-repo-url>
   git push -u origin main
   ```

### Required for Submission
1. **Public GitHub Link**: Should show full code
2. **README with team members**:
   - M1 (Team Lead)
   - M2-M4 (Team Members)
   - Roles and responsibilities

3. **APK File**: Upload compiled APK
4. **One-Page Infographic (PDF)**:
   - Team member names
   - Roles
   - Features implemented
   - GitHub repo link
   - APK download link

## 📱 APK Testing

After building APK (`app-release.apk`):

1. **Transfer to device**:
   ```bash
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

2. **Test on device**:
   - Open CipherTask app
   - Register with test email
   - Add some tasks
   - Verify encryption works
   - Test biometric/logout
   - Test 2-minute timeout

## 🎓 Learning Outcomes

After completing this laboratory:
- ✅ Understanding of MVVM architecture in Flutter
- ✅ Experience with encryption/security in mobile apps
- ✅ Biometric authentication implementation
- ✅ Secure local database management
- ✅ Session and state management
- ✅ Dependency injection patterns

## ❓ FAQ

**Q: Do we need to modify any files?**
A: No! The implementation is complete. Just run `flutter pub get` and `flutter pub run build_runner build`.

**Q: Can we change the security settings?**
A: Yes, modify `lib/utils/constants.dart` for timeout values. Don't change encryption algorithm without proper understanding.

**Q: How to change the app name?**
A: Edit `android/app/build.gradle` and `ios/Runner.xcodeproj/project.pbxproj` for branding.

**Q: What if there are compilation errors?**
A: Ensure you've run all setup steps. Check that all dependencies are installed and code generation completed.

## 🚀 Final Checklist

- [ ] Dependencies installed (`flutter pub get`)
- [ ] Hive adapters generated (`flutter pub run build_runner build`)
- [ ] Android/iOS platform setup complete
- [ ] App runs on emulator/device (`flutter run`)
- [ ] Register and login works
- [ ] Todo CRUD operations work
- [ ] Encryption/decryption functions properly
- [ ] Auto-logout after 2 minutes
- [ ] APK built and tested
- [ ] GitHub repository created with README
- [ ] One-page infographic prepared
- [ ] Team roles documented

---

**Ready to Submit?** Ensure all checklist items are completed before final submission!
