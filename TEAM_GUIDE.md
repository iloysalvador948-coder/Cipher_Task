# CipherTask - Team Coordination Guide

## 👥 Team Roles & Responsibilities

### **M1 - Team Lead**
**Role**: Project Coordinator & Architecture Lead

**Responsibilities:**
- Initialize project repository on GitHub (✅ Done)
- Ensure MVVM architecture is properly maintained
- Coordinate between team members
- Manage GitHub repository and documentation
- Prepare final submission (one-page infographic + APK)

**Tasks Completed:**
- ✅ Project structure initialization
- ✅ Dependency management setup
- ✅ Dependency injection configuration
- ✅ Route management in main.dart

**Remaining Tasks:**
- Create GitHub repository
- Update README with team information
- Prepare one-page infographic
- Compile APK file
- Final code review

---

### **M2 - Backend & Security Lead**
**Role**: Security Implementation & Database Management

**Responsibilities:**
- Implement encryption services
- Manage secure key storage
- Database encryption setup
- Security validation

**Tasks Completed:**
- ✅ AES-256 encryption service (`encryption_service.dart`)
- ✅ FlutterSecureStorage wrapper (`key_storage_service.dart`)
- ✅ Encrypted database service (`database_service.dart`)
- ✅ Session management service (`session_service.dart`)

**Testing Tasks:**
- [ ] Verify encryption/decryption works
- [ ] Test database persistence
- [ ] Validate key storage on device
- [ ] Verify auto-logout after 2 minutes
- [ ] Test with different data types

---

### **M3 - Frontend & UI Lead**
**Role**: User Interface & Experience Design

**Responsibilities:**
- Create all UI screens and layouts
- Implement reusable widgets
- Handle user interactions
- Error message display

**Tasks Completed:**
- ✅ Secure input widgets (`secure_widgets.dart`)
- ✅ Login view (`login_view.dart`)
- ✅ Registration view (`register_view.dart`)
- ✅ Todo list view (`todo_list_view.dart`)
- ✅ Splash screen

**Testing Tasks:**
- [ ] Test UI responsiveness
- [ ] Verify input validation
- [ ] Test error message display
- [ ] Check navigation flow
- [ ] Validate theme consistency

---

### **M4 - Architecture & State Management**
**Role**: MVVM Pattern & View Models

**Responsibilities:**
- Implement ViewModels with proper state management
- Handle business logic separation
- Manage application state with Provider
- Ensure MVVM pattern adherence

**Tasks Completed:**
- ✅ Auth ViewModel (`auth_viewmodel.dart`)
- ✅ Todo ViewModel (`todo_viewmodel.dart`)
- ✅ Models with Hive adapters (`todo_model.dart`, `user_model.dart`)
- ✅ Constants and configurations (`constants.dart`)

**Testing Tasks:**
- [ ] Test state updates
- [ ] Verify ViewModel logic
- [ ] Check data flow
- [ ] Validate model serialization
- [ ] Test with real data

---

## 📋 Project Checklist

### Phase 1: Setup & Configuration
- [x] Create project structure
- [x] Add all dependencies
- [x] Setup dependency injection
- [x] Configure routes
- [x] Initialize encryption keys

### Phase 2: Implementation
- [x] Models (with Hive adapters)
- [x] Services (Encryption, Database, Key Storage, Session)
- [x] ViewModels (Auth, Todo)
- [x] Views (Login, Register, TodoList)
- [x] Widgets (Reusable secure components)
- [x] Splash screen

### Phase 3: Testing & Integration
- [ ] Run `flutter pub get`
- [ ] Generate Hive adapters with `build_runner`
- [ ] Test on emulator/device
- [ ] Manual security testing
- [ ] Build APK for distribution

### Phase 4: Documentation & Submission
- [ ] Create GitHub repository
- [ ] Update README with team info
- [ ] Create one-page infographic (PDF)
- [ ] Collect APK file
- [ ] Final submission

---

## 🛠️ Quick Reference Commands

```bash
# Get dependencies
flutter pub get

# Generate Hive adapters (REQUIRED FIRST TIME)
flutter pub run build_runner build

# Run application
flutter run

# Run with specific device
flutter run -d <device-id>

# Build APK (debug)
flutter build apk --debug

# Build APK (release)
flutter build apk --release

# Clean and rebuild
flutter clean && flutter pub get

# Analyze code
flutter analyze

# Format code
flutter format lib/
```

---

## 📁 File Organization

### Data Layer (Models)
```
lib/models/
├── todo_model.dart      ← For Todo items
└── user_model.dart      ← For User authentication
```

### Business Logic Layer (Services + ViewModels)
```
lib/services/
├── encryption_service.dart       ← AES-256 encryption
├── database_service.dart         ← Hive encrypted storage
├── key_storage_service.dart      ← Secure key management
└── session_service.dart          ← Auto-logout logic

lib/viewmodels/
├── auth_viewmodel.dart           ← Authentication logic
└── todo_viewmodel.dart           ← Todo CRUD logic
```

### Presentation Layer (Views)
```
lib/views/
├── login_view.dart               ← Login screen
├── register_view.dart            ← Registration screen
├── todo_list_view.dart           ← Main todo screen
└── widgets/
    └── secure_widgets.dart       ← Reusable components
```

### Utilities
```
lib/utils/
└── constants.dart                ← App-wide constants
```

---

## 🔐 Security Checklist

- [x] AES-256 encryption implemented
- [x] Biometric authentication setup
- [x] Hardware-backed key storage
- [x] Auto-logout mechanism (2 minutes)
- [x] Screenshot prevention
- [x] Database encryption
- [x] Field-level encryption for sensitive data
- [x] Secure password hashing (basic - can improve with bcrypt)

---

## 🧪 Testing Scenarios

### **Scenario 1: Registration & Login**
```
1. Launch app → See splash screen
2. Tap "Don't have account" → Register
3. Enter: email, password, name
4. Optionally enable biometric
5. Create account
6. Should auto-login and see todo list
```

### **Scenario 2: Biometric Authentication**
```
1. Ensure biometric enrolled on device
2. Register account with biometric enabled
3. Logout
4. Login screen appears
5. Tap "Unlock with Fingerprint"
6. Use fingerprint
7. Should login and see todo list
```

### **Scenario 3: Auto-Logout**
```
1. Login to app
2. Do NOT interact with app for 2 minutes
3. Should auto-logout to login screen
4. Error message: "Session expired due to inactivity"
```

### **Scenario 4: Task Encryption**
```
1. Login to app
2. Add new task with description
3. Description should be encrypted in database
4. View task → should show decrypted description
5. Delete app data → cannot read data from device
```

### **Scenario 5: Screenshot Prevention**
```
1. Open app
2. Try to take screenshot
3. Screenshot should be blocked/prevented (device notification)
```

---

## 📝 Documentation Requirements

### README.md (GitHub)
- [x] Project overview
- [x] Security features
- [x] Project structure
- [x] Installation instructions
- [x] Team member information (TO ADD)
- [x] Feature checklist
- [x] Usage examples

### IMPLEMENTATION_GUIDE.md
- [x] Setup steps
- [x] Platform configuration
- [x] Testing checklist
- [x] Common issues & solutions
- [x] Final deliverables

### One-Page Infographic (PDF)
**To Create**: Should include:
- Team member names and roles
- Key features implemented
- GitHub repository link
- APK download link
- CipherTask logo/branding
- Security features highlighted

---

## 🎯 Success Criteria

✅ **Must Have:**
1. App compiles and runs without errors
2. User can register and login
3. Tasks can be added/edited/deleted
4. Biometric authentication works
5. Auto-logout after 2 minutes
6. Database is encrypted
7. Descriptions are encrypted
8. MVVM pattern properly implemented
9. Code is well-organized and commented
10. GitHub repo is public and accessible

✅ **Nice to Have:**
1. Polished UI/UX
2. Comprehensive error handling
3. Good documentation
4. Performance optimization
5. Additional features (OTP, etc.)

---

## 📞 Communication Protocol

### Weekly Sync
- **Day**: Friday
- **Time**: 3:00 PM
- **Duration**: 30 minutes
- **Format**: Team meeting discussing progress

### Daily Updates
- Post progress on team channel
- Alert if blocked or need help
- Share test results

### Issue Resolution
- Document any bugs found
- Create GitHub issues for tracking
- Assign to responsible member
- Keep updated status in issue

---

## 🚀 Pre-Submission Checklist

- [ ] All code committed to GitHub
- [ ] README updated with team information
- [ ] APK file built and tested
- [ ] One-page infographic created (PDF)
- [ ] GitHub repository is public
- [ ] All features working as expected
- [ ] No critical bugs or warnings
- [ ] Code is properly commented
- [ ] Submission package prepared

---

## 📊 Progress Dashboard Template

```
Week 1: Setup & Architecture
├── ✅ Dependency setup
├── ✅ Project structure
├── ✅ DI configuration
└── ✅ Route setup

Week 2: Core Services
├── ✅ Encryption service
├── ✅ Database service
├── ✅ Key storage service
└── ✅ Session service

Week 3: UI & ViewModels
├── ✅ Auth ViewModel
├── ✅ Todo ViewModel
├── ✅ UI views
└── ✅ Widgets

Week 4: Testing & Submission
├── ⏳ Integration testing
├── ⏳ Security testing
├── ⏳ APK build
└── ⏳ Final submission
```

---

## 💡 Tips for Success

1. **Test Early & Often**: Don't wait until the end
2. **Communicate**: Keep team updated on progress
3. **Code Review**: Review each other's code
4. **Document**: Comment complex logic
5. **Version Control**: Commit frequently with clear messages
6. **Follow MVVM**: Keep presentation, logic, and data separate
7. **Error Handling**: Provide user-friendly error messages
8. **Security First**: Always follow security best practices

---

**Last Updated**: March 3, 2026  
**Project Status**: ✅ Ready for Testing Phase
