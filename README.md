# MeuExame

An iOS application built with Swift and UIKit using the VIPER architecture pattern.

## Project Information

- **Bundle ID**: com.meuexame.app
- **iOS Deployment Target**: iOS 15.0+
- **Language**: Swift 5.0
- **UI Framework**: UIKit (View Code - Programmatic UI)
- **Architecture**: VIPER
- **Dependency Manager**: Swift Package Manager (SPM)
- **Backend**: Firebase (Auth, Firestore, Storage)

## Project Structure

```
MeuExame/
├── AppDelegate.swift
├── SceneDelegate.swift
├── Info.plist
├── Scenes/
│   └── Login/              # Login module (VIPER)
├── Common/
│   ├── Helpers/            # Helper classes and utilities
│   ├── Protocols/          # Common protocols
│   └── Extensions/         # Swift extensions
├── Services/
│   ├── Firebase/           # Firebase services
│   └── Networking/         # Network layer
└── Resources/
    ├── Assets.xcassets     # App assets
    └── LaunchScreen.storyboard
```

## Features

- ✅ Programmatic UI (View Code) - No Storyboards for main UI
- ✅ VIPER Architecture ready
- ✅ Modular structure for scalability
- ✅ Swift 5.0
- ✅ iOS 15.0+ support
- ✅ Firebase Integration (Auth, Firestore, Storage)
- ✅ Dependency Injection Pattern
- ✅ Protocol-Oriented Design

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/tbdbatista/meu-exame.git
cd meu-exame
```

### 2. Configure Firebase

Follow the detailed guide in [FIREBASE_SETUP.md](FIREBASE_SETUP.md) to:
- Add Firebase dependencies via Swift Package Manager
- Download and add `GoogleService-Info.plist`
- Configure Firebase services

### 3. Open and Run

1. Open `MeuExame.xcodeproj` in Xcode
2. Wait for SPM to resolve dependencies
3. Select your target device or simulator
4. Build and run (⌘R)

## Architecture - VIPER

The project follows the VIPER (View, Interactor, Presenter, Entity, Router) architecture pattern:

- **View**: Displays UI and forwards user actions to the Presenter
- **Interactor**: Contains business logic
- **Presenter**: Contains view logic for preparing content for display and reacting to user inputs
- **Entity**: Contains basic model objects
- **Router**: Handles navigation between modules

## Requirements

- Xcode 15.0+
- iOS 15.0+
- Swift 5.0+

## Dependencies

The project uses Swift Package Manager for dependency management:

- **Firebase iOS SDK** (11.0.0+)
  - FirebaseAuth - User authentication
  - FirebaseFirestore - Cloud database
  - FirebaseStorage - File storage

See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for detailed setup instructions.

## Architecture Details

### Dependency Injection

The project uses a `DependencyContainer` to manage dependencies:

```swift
let container = DependencyContainer.shared
let loginVC = container.makeLoginModule()
```

### Firebase Services

All Firebase services are abstracted through protocols:
- `FirebaseConfigurable` - Configuration management
- `FirebaseAuthenticationService` - Authentication operations
- `FirebaseFirestoreService` - Database operations
- `FirebaseStorageService` - File storage operations

This allows for:
- Easy testing with mock implementations
- Loose coupling between components
- Flexibility to swap implementations

## Testing

The project is designed with testability in mind using dependency injection:

```swift
// Example: Mock Firebase for testing
class MockFirebaseManager: FirebaseConfigurable {
    func configure() { }
    func isConfigured() -> Bool { return true }
}

// Inject in tests
let appDelegate = AppDelegate()
appDelegate.firebaseManager = MockFirebaseManager()
```

## Next Steps

- ✅ Firebase integration complete
- ⏳ Implement Login module with VIPER components
- ⏳ Configure networking layer
- ⏳ Add common extensions and utilities

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

Created on November 9, 2025

