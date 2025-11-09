# MeuExame

An iOS application built with Swift and UIKit using the VIPER architecture pattern.

## Project Information

- **Bundle ID**: com.meuexame.app
- **iOS Deployment Target**: iOS 15.0+
- **Language**: Swift 5.0
- **UI Framework**: UIKit (View Code - Programmatic UI)
- **Architecture**: VIPER

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

## Getting Started

1. Open `MeuExame.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run (⌘R)

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

## Next Steps

- Implement Login module with VIPER components
- Add Firebase integration
- Configure networking layer
- Add common protocols and extensions

---

Created on November 9, 2025

