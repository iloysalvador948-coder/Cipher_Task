# CipherTask - Features Overview

Complete breakdown of every feature implemented in the application.

---

## 🔐 Security Features

### 1. AES-256 Encryption

**What**: Advanced Encryption Standard with 256-bit keys  
**Where**: `lib/services/encryption_service.dart`  
**How it works**:
```
Plain Text → AES-256 Encryption → Cipher Text (stored in DB)
Cipher Text → AES-256 Decryption → Plain Text (when viewing)
```

**What it protects**:
- Task descriptions
- User sensitive notes
- Any field marked as sensitive

**Key Generation**: Auto-generated on first app run, stored securely

**Files affected**:
- `todo_model.dart` - Stores encrypted descriptions
- `encryption_service.dart` - Handles encryption/decryption

---

### 2. Database Encryption (Hive)

**What**: Entire local database encrypted at rest  
**Where**: `lib/services/database_service.dart`  
**How it works**:
```
When app opens:
1. Retrieve encryption key from secure storage
2. Use key to open Hive boxes
3. All data in boxes is encrypted
4. Encryption transparent to code
```

**What it protects**:
- All todos
- User profile data
- Session information
- Metadata

**Files affected**:
- `todo_model.dart` - Data model for todos
- `user_model.dart` - User data model
- `database_service.dart` - Database management

---

### 3. Biometric Authentication

**What**: Fingerprint/Face recognition unlock  
**Where**: `lib/viewmodels/auth_viewmodel.dart` + `lib/views/login_view.dart`  
**How it works**:
```
User Registration:
1. User can optionally enable biometric during registration
2. Biometric status stored in secure storage
3. Password must be set first (biometric is supplementary)

User Login:
1. User can choose "Unlock with Fingerprint"
2. Device prompts for biometric
3. If authenticated, checks user record
4. Logs in without entering password
```

**Requirements**:
- Device must have biometric enrolled
- User must have registered with password first
- iOS: Face ID or Touch ID
- Android: Fingerprint, Face recognition, or Iris

**Files affected**:
- `auth_viewmodel.dart` - Biometric logic
- `login_view.dart` - UI for biometric
- `local_auth.dart` - Flutter biometric package

---

### 4. Hardware-Backed Key Storage

**What**: Encryption keys stored in device's secure enclave  
**Where**: `lib/services/key_storage_service.dart`  
**How it works**:
```
Android:
1. Uses Android Keystore System
2. Keys never extracted from hardware
3. Hardware-backed encryption

iOS:
1. Uses iOS Keychain
2. Protected by Secure Enclave
3. Hardware-backed protection
```

**What it protects**:
- AES encryption keys
- Biometric status
- Master encryption key
- Database encryption key

**Why it matters**:
- Even if device is compromised
- Keys can't be extracted
- Cannot decrypt without device
- Maximum security level

**Files affected**:
- `key_storage_service.dart` - Key management
- `Flutter Secure Storage` package - Storage provider

---

### 5. Auto-Logout (Session Timeout)

**What**: Automatic logout after 2 minutes of inactivity  
**Where**: `lib/services/session_service.dart`  
**How it works**:
```
App Open:
1. Session timer starts (2 minutes)
2. User interacts (tap, scroll, type) → Timer resets
3. If no interaction for 2 minutes → Auto-logout
4. User redirected to login screen
```

**Inactivity Detection**:
- Any touch on screen resets timer
- Keyboard input resets timer
- Scrolling resets timer
- Navigation does NOT count

**Files affected**:
- `session_service.dart` - Timer management
- `auth_viewmodel.dart` - Logout logic
- `todo_list_view.dart` - User interaction detection

---

### 6. Screenshot Prevention

**What**: Blocks unauthorized screenshot captures  
**Where**: `lib/main.dart`  
**How it works**:
```
On app startup:
1. Sets FLAG_SECURE on window
2. Prevents screenshot/recording
3. Android: Shows "Content blocked"
4. iOS: Prevents screenshot
```

**What it prevents**:
- Screenshots of app screens
- Screen recording
- Casting the screen

**Files affected**:
- `main.dart` - Initialization
- `FlutterWindowManager` package - Implementation

---

### 7. Secure Password Management

**What**: Password hashing and validation  
**Where**: `lib/services/encryption_service.dart`  
**How it works**:
```
During Registration:
1. User enters password
2. Password hashed using base64 encoding
3. Hash stored in database (not plain password)
4. Plain password never stored

During Login:
1. User enters password
2. System hashes the input
3. Compares hash with stored hash
4. If match → User authenticated
```

**Note**: Production apps should use bcrypt or Argon2  
**Current**: Uses base64 (suitable for lab exercise)

**Files affected**:
- `encryption_service.dart` - Hashing
- `auth_viewmodel.dart` - Password validation

---

## 🎯 Functional Features

### 1. User Authentication

**Features**:
- ✅ Email-based registration
- ✅ Password validation (min 8 characters)
- ✅ Password confirmation
- ✅ Email format validation
- ✅ Password login
- ✅ Biometric login (if enabled)
- ✅ User profile storage

**File**: `lib/viewmodels/auth_viewmodel.dart`  
**Views**: `lib/views/login_view.dart`, `lib/views/register_view.dart`

### 2. Task Management (CRUD)

**Features**:
- ✅ **Create**: Add new tasks with title, description, due date, priority
- ✅ **Read**: View all tasks in list with priorities
- ✅ **Update**: Edit task details
- ✅ **Delete**: Remove tasks

**Task Properties**:
- Title (required)
- Description (optional, encrypted)
- Due date (optional)
- Priority (1-5, 5=critical)
- Completion status
- Creation timestamp

**File**: `lib/viewmodels/todo_viewmodel.dart`  
**View**: `lib/views/todo_list_view.dart`

### 3. Task Priority System

**Levels**:
```
5 = CRITICAL (Red)
4 = HIGH (Orange)
3 = MEDIUM (Yellow)
2 = LOW (Blue)
1 = MINIMAL (Green)
```

**Visual Indication**: Color-coded chips on task cards  
**Sorting**: Can sort by priority (descending)

**File**: `lib/views/widgets/secure_widgets.dart` (TodoItemWidget)

### 4. Session Management

**Features**:
- ✅ Auto-logout after 2 minutes
- ✅ Activity timer reset on interaction
- ✅ Session state persistence
- ✅ Secure session data storage
- ✅ Graceful logout with cleanup

**File**: `lib/services/session_service.dart`

### 5. Error Handling

**Features**:
- ✅ User-friendly error messages
- ✅ Validation on all inputs
- ✅ Network error handling
- ✅ Database error handling
- ✅ Encryption error handling

**Error Types Handled**:
- Invalid email format
- Short passwords
- Missing required fields
- Biometric failures
- Database access errors
- Encryption failures

**File**: `lib/views/widgets/secure_widgets.dart` (SecureErrorWidget)

---

## 🏗️ Architecture Features

### 1. MVVM Pattern

**Structure**:
```
View (UI Layer)
  ↓ (uses)
ViewModel (Logic Layer)
  ↓ (uses)
Model (Data Layer)
  ↓ (uses)
Services (Security & DB)
```

**Files**:
- Views: `lib/views/*.dart`
- ViewModels: `lib/viewmodels/*.dart`
- Models: `lib/models/*.dart`
- Services: `lib/services/*.dart`

### 2. Dependency Injection

**Pattern**: Service Locator (GetIt)  
**Setup Location**: `lib/main.dart`  
**Benefits**:
- Easy testing
- Loose coupling
- Singleton instances
- Clean initialization

**Services Registered**:
- KeyStorageService
- EncryptionService
- DatabaseService
- SessionService
- AuthViewModel
- TodoViewModel

### 3. State Management

**Pattern**: Provider (ChangeNotifier)  
**Listeners**:
- AuthViewModel - tracks authentication state
- TodoViewModel - tracks todo list state

**Benefits**:
- Reactive UI updates
- Clean state flow
- Easy to debug
- Efficient rebuilds

### 4. Routing

**Pattern**: Named routes  
**Routes**:
- `/login` → LoginView
- `/register` → RegisterView
- `/todo-list` → TodoListView

**Auto-routing**: SplashScreen checks auth status and navigates automatically

---

## 🎨 UI/UX Features

### 1. Splash Screen

**Features**:
- Security-focused branding
- Gradient background
- Loading indicator
- Auto-navigation after 2 seconds
- Checks user authentication status

**File**: `lib/main.dart`

### 2. Login Screen

**Features**:
- Email field with validation
- Password field (hidden) with show/hide toggle
- Login button
- Biometric option (if available)
- Link to registration
- Error message display
- Loading state during login

**File**: `lib/views/login_view.dart`

### 3. Registration Screen

**Features**:
- Full name field
- Email field with validation
- Password field with strength requirement
- Confirm password field
- Biometric enrollment option
- Registration button
- Link back to login
- Loading state
- Error message display

**File**: `lib/views/register_view.dart`

### 4. Todo List Screen

**Features**:
- Greeting with user's name
- Task count display
- Task list with:
  - Completion checkbox
  - Task title
  - Priority color chip
  - Due date (if set)
- Add task floating button
- Task details dialog
- Delete confirmation
- User logout option
- Empty state message

**File**: `lib/views/todo_list_view.dart`

### 5. Add Task Dialog

**Features**:
- Task title input (required)
- Description input (optional)
- Due date input
- Priority slider (1-5)
- Cancel button
- Add button
- Input validation

### 6. Reusable Widgets

**SecureTextField**:
- Label and hint text
- Password visibility toggle
- Validation support
- Change callbacks

**SecureButton**:
- Loading state indicator
- Disabled state
- Consistent styling

**SecureErrorWidget**:
- Error icon
- Error message
- Color-coded display

**TodoItemWidget**:
- Task title
- Completion checkbox
- Priority chip
- Due date
- Tap to view details
- Long-press to delete

**Files**: `lib/views/widgets/secure_widgets.dart`

---

## 🔧 Technical Features

### 1. Code Generation

**Tool**: Build Runner  
**Generates**:
- `todo_model.g.dart`
- `user_model.g.dart`

**Purpose**: Hive adapter code for serialization

**Command**: `flutter pub run build_runner build`

### 2. Hive Database

**Features**:
- Lightweight NoSQL database
- Built-in encryption support
- Cross-platform (Android, iOS, Web)
- Type-safe data access
- Automatic serialization

**Boxes Used**:
- `todos` - Task storage
- `user` - User profile
- `session` - Session data

**File**: `lib/services/database_service.dart`

### 3. Data Models

**Todo Model**:
- ID (UUID)
- Title
- Description (encrypted)
- Completion status
- Priority (1-5)
- Created date
- Updated date
- Due date

**User Model**:
- ID (UUID)
- Email
- Hashed password
- Biometric enabled status
- Creation date
- Last login date
- Full name

**Files**: `lib/models/*.dart`

### 4. Configuration Management

**Constants File**: `lib/utils/constants.dart`
- Session timeout value (changeable)
- Database box names
- Secure storage keys
- Encryption parameters
- Error messages
- Validation rules

---

## 📊 Feature Completion Matrix

| Feature | Status | Location |
|---------|--------|----------|
| AES-256 Encryption | ✅ | encryption_service.dart |
| Database Encryption | ✅ | database_service.dart |
| Biometric Auth | ✅ | auth_viewmodel.dart |
| Hardware-Backed Storage | ✅ | key_storage_service.dart |
| Auto-Logout | ✅ | session_service.dart |
| Screenshot Prevention | ✅ | main.dart |
| User Registration | ✅ | auth_viewmodel.dart |
| User Login | ✅ | auth_viewmodel.dart |
| Task CRUD | ✅ | todo_viewmodel.dart |
| Priority System | ✅ | todo_model.dart |
| Error Handling | ✅ | all files |
| MVVM Pattern | ✅ | architecture |
| Dependency Injection | ✅ | main.dart |
| State Management | ✅ | viewmodels |
| Responsive UI | ✅ | all views |
| Input Validation | ✅ | all viewmodels |

---

## 🎓 Educational Value

This implementation teaches:
- ✅ Enterprise-grade security practices
- ✅ Encryption fundamentals
- ✅ Biometric authentication
- ✅ Secure local storage
- ✅ MVVM architecture
- ✅ State management patterns
- ✅ Dependency injection
- ✅ Flutter best practices
- ✅ Code organization
- ✅ Error handling

---

**Feature Documentation Complete** ✅

For implementation details, see: `IMPLEMENTATION_GUIDE.md`  
For quick start, see: `QUICK_START.md`  
For team coordination, see: `TEAM_GUIDE.md`
