# WalkthroughKit 🚀

**WalkthroughKit** is a lightweight, highly customizable, and animated onboarding popup library for iOS, written in pure Swift (UIKit). It features a "spotlight" effect to highlight specific UI elements, guiding users through your app's features with style.

![Platform](https://img.shields.io/badge/Platform-iOS-orange.svg)
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)

<p align="center">
  <img src="" alt="Demo Animation" width="600" />
</p>

## ✨ Features

- [x] **Spotlight Effect:** Highlights target views by dimming the background with cutout holes.
- [x] **Title & Description Support:** Optional titles with customizable styling for each step.
- [x] **Card Elevation:** Beautiful shadow effects for a modern, elevated card appearance.
- [x] **Animated Currents:** Flowing decorative lines around images with smooth animations.
- [x] **Image Animations:** Smooth fade-in and scale animations when images appear or change.
- [x] **Dots Indicator:** Visual progress dots showing current step (bright) and others (dull).
- [x] **Step Limit:** Maximum 9 steps per walkthrough for optimal UX.
- [x] **Pure UIKit:** No Storyboards or XIBs, purely programmatic UI.
- [x] **Fully Customizable:** Change colors, fonts, corner radius, sizes, and more via `Theme`.
- [x] **Manager Support:** Easy-to-use Singleton Manager to handle popup flows.
- [x] **Auto Layout:** Automatically calculates positions relative to target views.
- [x] **Swift Package Manager (SPM):** Easy installation.
- [x] **iOS 15+ Support:** Supports Dark Mode and dynamic system colors.


## 📲 Installation

### Swift Package Manager

To integrate **WalkthroughKit** into your Xcode project using SPM:

1. Open Xcode and go to **File > Add Packages...**
2. Enter the repository URL:
   ```text

3. Select Up to Next Major Version.
4. Click Add Package.


## 📝 SwiftUI Usage (Workaround)

```swift
import SwiftUI
import WalkthroughKit

struct SwiftUIExampleView: View {
    
    // 1. State variables to capture the global frames (screen coordinates) of target views.
    // Unlike UIKit, SwiftUI views don't expose a direct 'frame' property easily,
    // so we need to capture them manually using GeometryReader.
    @State private var profileFrame: CGRect = .zero
    @State private var settingsFrame: CGRect = .zero
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                
                // --- Target 1: Profile Image ---
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
                    // 2. We use a transparent overlay with GeometryReader to get the frame.
                    .overlay(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    // Capture the frame in the global screen coordinate space
                                    self.profileFrame = geo.frame(in: .global)
                                }
                        }
                    )
                
                Text("Welcome to the App!")
                    .font(.title2)
                
                // --- Target 2: Settings Button ---
                Button(action: {}) {
                    HStack {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
                // Attaching the reader to the second target
                .overlay(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                self.settingsFrame = geo.frame(in: .global)
                            }
                    }
                )
                
                Spacer()
                
                // --- Trigger Button ---
                Button("Start Onboarding Tour") {
                    startOnboarding()
                }
                .font(.headline)
                .padding(.bottom, 50)
            }
            .navigationTitle("SwiftUI Demo")
        }
    }
    
    // 3. Logic to bridge SwiftUI and the UIKit Popup Library
    func startOnboarding() {
        // A. Find the Root View Controller.
        // Since WalkthroughKit is a UIViewController, it needs a host to be presented.
        // We access the active window scene to find the top-most controller.
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            print("Error: Could not find Root View Controller")
            return
        }
        
        // B. Prepare the steps using the captured CGRects (States).
        // Note: We act as if we are passing manual frames instead of UIView references.
        let stepsWithFrames: [(MyOnboardingStep, CGRect)] = [
            (.profile, profileFrame),
            (.settings, settingsFrame)
        ]
        
        // C. Call the Manager
        // Note: For SwiftUI, you'll need to adapt the protocol to work with CGRects
        // This is a simplified example - you may need to create a wrapper
        WalkthroughKitManager.shared.show(
            on: rootVC,
            items: stepsWithFrames.map { ($0.0, UIView()) }, // Adapt as needed
            onFinish: {
                print("SwiftUI Onboarding Completed")
            }
        )
    }
}
```


## 🚀 Quick Start
1. Define Your Steps
Create an enum that conforms to the WalkthroughKitStepable protocol. This defines the content of your popup steps.

```swift
import UIKit
import WalkthroughKit

enum MyOnboardingStep: WalkthroughKitStepable {
    case profile
    case settings
    
    var title: String? {
        switch self {
        case .profile: return "Your Profile"
        case .settings: return "Settings"
        }
    }
    
    var description: String {
        switch self {
        case .profile: return "Tap here to edit your profile details."
        case .settings: return "Configure your app preferences here."
        }
    }
    
    var image: UIImage? {
        switch self {
        case .profile: return UIImage(systemName: "person.circle")
        case .settings: return UIImage(systemName: "gear")
        }
    }
}
```

2. Show the Popup
Use the WalkthroughKitManager to launch the onboarding flow. You don't need to calculate frames manually; just pass the UIView references!

```swift
class ViewController: UIViewController {

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let steps: [(MyOnboardingStep, UIView)] = [
            (.profile, profileButton),
            (.settings, settingsButton)
        ]
        
        WalkthroughKitManager.shared.show(
            on: self,
            items: steps,
            onStepShown: { step in
                print("User is seeing: \(step)")
            },
            onFinish: {
                print("Onboarding completed!")
            }
        )
    }
}
```

## 🎨 Customization (Theming)
You can fully customize the look and feel of the popup by passing a WalkthroughKitTheme object.

```swift
// 1. Create a custom theme
var oceanTheme = WalkthroughKitTheme.default

// Layout
oceanTheme.popupWidth = 320
oceanTheme.containerCornerRadius = 16

// Colors
oceanTheme.containerBackgroundColor = UIColor(red: 0.9, green: 0.95, blue: 1.0, alpha: 1.0) // Light Blue
oceanTheme.overlayColor = UIColor.black.withAlphaComponent(0.7)

// Fonts & Text Colors
oceanTheme.titleFont = .systemFont(ofSize: 22, weight: .bold)
oceanTheme.titleColor = .systemIndigo
oceanTheme.descriptionColor = .systemIndigo
oceanTheme.nextButtonTextColor = .systemBlue
oceanTheme.nextButtonBorderColor = .systemBlue

// Texts
oceanTheme.nextButtonText = "Next Step"
oceanTheme.finishButtonText = "Awesome!"

// 2. Pass it to the manager
WalkthroughKitManager.shared.show(
    on: self,
    items: steps,
    theme: oceanTheme, // <--- Apply theme here
    onFinish: { print("Finished with Custom Theme") }
)
```

## 📱 Running the Demo
This repository includes a fully functional example project where you can play with customization settings in real-time.

Clone the repo.

Open Example/WalkthroughKitDemo.xcodeproj.

Select the simulator (e.g., iPhone 15).

Press Cmd + R to run.

Tap "⚙️ Configure & Test Popup" to try different themes and settings.


## 📋 Requirements
- iOS 15.0+
- Swift 5.0+
- Xcode 14.0+

## 🎯 Key Highlights

### Maximum Steps
The walkthrough supports up to **9 steps** maximum. If more steps are provided, only the first 9 will be shown.

```swift
// Limit is enforced automatically
WalkthroughKitManager.maxStepsLimit = 9 // Default
```

### Title & Description
Each step can have an optional title and description:

```swift
var title: String? {
    return "Step Title" // Optional - can return nil
}

var description: String {
    return "Step description text"
}
```

### Visual Indicators
- **Dots Indicator:** Shows progress with animated dots (current step is bright, others are dull)
- **Card Elevation:** Beautiful shadow effects for depth
- **Animated Currents:** Flowing decorative lines around images
- **Smooth Animations:** Image fade-in/scale and step transitions

## 📚 API Reference

### WalkthroughKitStepable Protocol
```swift
public protocol WalkthroughKitStepable {
    var title: String? { get }        // Optional title
    var description: String { get }   // Required description
    var image: UIImage? { get }       // Optional image
}
```

### WalkthroughKitManager
```swift
public static let shared: WalkthroughKitManager
public static var maxStepsLimit: Int // Default: 9

public func show<Step: WalkthroughKitStepable>(
    on presentingVC: UIViewController,
    items: [(step: Step, targetView: UIView)],
    theme: WalkthroughKitTheme = .default,
    onStepShown: ((_ step: Step) -> Void)? = nil,
    onFinish: @escaping () -> Void
)
```

## 🤝 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License
This project is licensed under the MIT License.

## 🙏 Acknowledgments
Built with ❤️ using UIKit.
