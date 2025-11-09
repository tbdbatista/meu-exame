# Firebase Setup Guide for MeuExame

This guide will help you configure Firebase in your MeuExame iOS project.

## 📋 Prerequisites

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Register your iOS app with Bundle ID: `com.meuexame.app`
3. Download the `GoogleService-Info.plist` file

## 🔧 Step 1: Add Firebase Dependencies via Swift Package Manager

### Using Xcode:

1. Open `MeuExame.xcodeproj` in Xcode
2. Go to **File → Add Package Dependencies...**
3. Enter the Firebase SDK URL:
   ```
   https://github.com/firebase/firebase-ios-sdk
   ```
4. Select version: **Up to Next Major Version** (11.0.0 or later)
5. Click **Add Package**
6. Select the following products to add to your target:
   - ✅ **FirebaseAuth** (for Authentication)
   - ✅ **FirebaseFirestore** (for Database)
   - ✅ **FirebaseStorage** (for File Storage)
7. Click **Add Package**

### Alternative: Using Package.swift (if needed)

If you're managing dependencies via Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.0.0")
],
targets: [
    .target(
        name: "MeuExame",
        dependencies: [
            .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
            .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
            .product(name: "FirebaseStorage", package: "firebase-ios-sdk")
        ]
    )
]
```

## 📄 Step 2: Add GoogleService-Info.plist

1. Download `GoogleService-Info.plist` from Firebase Console:
   - Go to Project Settings
   - Select your iOS app
   - Download the configuration file

2. Add to Xcode:
   - Drag `GoogleService-Info.plist` into your Xcode project
   - **Important**: Make sure to check "Copy items if needed"
   - Ensure it's added to the **MeuExame** target

3. Verify the file location:
   ```
   MeuExame/
   ├── GoogleService-Info.plist  ← Should be here
   ├── AppDelegate.swift
   └── ...
   ```

## ✅ Step 3: Verify Installation

The project is already configured to initialize Firebase automatically!

### What's Already Done:

1. ✅ **FirebaseManager.swift** created with:
   - Singleton pattern for easy access
   - Dependency injection support
   - Authentication service
   - Firestore service
   - Storage service

2. ✅ **FirebaseConfigurable Protocol** created for:
   - Testability
   - Flexibility
   - Dependency injection

3. ✅ **AppDelegate** updated to:
   - Initialize Firebase on app launch
   - Use dependency injection pattern
   - Provide configuration feedback

### Test the Configuration:

Run your app and check the console. You should see:

```
✅ Firebase configured successfully
✅ Firebase initialized successfully in AppDelegate
```

If you see a warning about missing `GoogleService-Info.plist`, complete Step 2 above.

## 🔥 Firebase Services Available

### Authentication Service

```swift
let firebaseManager = FirebaseManager.shared

// Sign In
firebaseManager.signIn(email: "user@example.com", password: "password") { result in
    switch result {
    case .success(let userId):
        print("Logged in: \(userId)")
    case .failure(let error):
        print("Error: \(error)")
    }
}

// Sign Up
firebaseManager.signUp(email: "user@example.com", password: "password") { result in
    // Handle result
}

// Sign Out
try? firebaseManager.signOut()

// Get Current User
if let userId = firebaseManager.getCurrentUserId() {
    print("Current user: \(userId)")
}
```

### Firestore Service

```swift
// Save data
struct User: Codable {
    let name: String
    let email: String
}

let user = User(name: "John", email: "john@example.com")
firebaseManager.save(data: user, to: "users", documentId: "userId") { result in
    // Handle result
}

// Fetch data
firebaseManager.fetch(from: "users", documentId: "userId", as: User.self) { result in
    switch result {
    case .success(let user):
        print("Fetched user: \(user.name)")
    case .failure(let error):
        print("Error: \(error)")
    }
}

// Delete document
firebaseManager.delete(from: "users", documentId: "userId") { result in
    // Handle result
}
```

### Storage Service

```swift
// Upload file
let imageData = UIImage(named: "photo")?.jpegData(compressionQuality: 0.8)
firebaseManager.upload(data: imageData!, to: "images/photo.jpg") { result in
    switch result {
    case .success(let url):
        print("Uploaded to: \(url)")
    case .failure(let error):
        print("Error: \(error)")
    }
}

// Download file
firebaseManager.download(from: "images/photo.jpg") { result in
    switch result {
    case .success(let data):
        let image = UIImage(data: data)
    case .failure(let error):
        print("Error: \(error)")
    }
}

// Delete file
firebaseManager.delete(from: "images/photo.jpg") { result in
    // Handle result
}
```

## 🧪 Dependency Injection for Testing

The project uses dependency injection to allow for easy testing:

```swift
// In tests or for mocking
class MockFirebaseManager: FirebaseConfigurable {
    func configure() {
        // Mock implementation
    }
    
    func isConfigured() -> Bool {
        return true
    }
}

// Inject mock in AppDelegate
let appDelegate = AppDelegate()
appDelegate.firebaseManager = MockFirebaseManager()
```

## 🔒 Firebase Security Rules

### Firestore Rules (Basic):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Storage Rules (Basic):

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 🛠 Troubleshooting

### Issue: "GoogleService-Info.plist not found"
**Solution**: Make sure the file is added to your project and is included in the target.

### Issue: "Module 'FirebaseAuth' not found"
**Solution**: 
1. Clean build folder (Cmd + Shift + K)
2. Re-add Firebase packages
3. Restart Xcode

### Issue: Firebase not initializing
**Solution**: Check that:
1. GoogleService-Info.plist is in the correct location
2. The file is added to the MeuExame target
3. Bundle ID matches the one in Firebase Console

## 📚 Additional Resources

- [Firebase iOS Documentation](https://firebase.google.com/docs/ios/setup)
- [Firebase Authentication](https://firebase.google.com/docs/auth/ios/start)
- [Cloud Firestore](https://firebase.google.com/docs/firestore/quickstart)
- [Cloud Storage](https://firebase.google.com/docs/storage/ios/start)

---

**Next Steps**: After completing this setup, you can proceed to implement the Login module using VIPER architecture!

