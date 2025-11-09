import ProjectDescription

let project = Project(
    name: "MeuExame",
    organizationName: "MeuExame",
    packages: [
        .remote(
            url: "https://github.com/firebase/firebase-ios-sdk",
            requirement: .upToNextMajor(from: "11.0.0")
        )
    ],
    settings: .settings(
        base: [
            "SWIFT_VERSION": "5.0",
            "IPHONEOS_DEPLOYMENT_TARGET": "15.0"
        ]
    ),
    targets: [
        .target(
            name: "MeuExame",
            destinations: .iOS,
            product: .app,
            bundleId: "com.meuexame.app",
            infoPlist: .file(path: "MeuExame/Info.plist"),
            sources: ["MeuExame/**/*.swift"],
            resources: [
                "MeuExame/Resources/**",
                "MeuExame/GoogleService-Info.plist"
            ],
            dependencies: [
                .package(product: "FirebaseAuth", type: .runtime),
                .package(product: "FirebaseFirestore", type: .runtime),
                .package(product: "FirebaseStorage", type: .runtime)
            ],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                    "CODE_SIGN_STYLE": "Automatic",
                    "CURRENT_PROJECT_VERSION": "1",
                    "MARKETING_VERSION": "1.0",
                    "PRODUCT_BUNDLE_IDENTIFIER": "com.meuexame.app",
                    "PRODUCT_NAME": "$(TARGET_NAME)",
                    "INFOPLIST_KEY_UILaunchStoryboardName": "LaunchScreen",
                    "INFOPLIST_KEY_UISupportedInterfaceOrientations": "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight"
                ]
            )
        )
    ]
)
