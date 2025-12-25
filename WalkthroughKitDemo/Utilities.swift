//
//  Utilities.swift
//  WalkthroughKit
//
//  Created by Dhruv Porwal on 12/25/25.
//

import Foundation
import WalkthroughKit
import UIKit

enum OnboardingStep: WalkthroughKitStepable {

    case home
    case profile
    case configButton
    case subtleButton
    case radioButton
    case testButton
    case clusterButton
    case breweryButton
    case showWalkthroughButton
    case showWalkthroughButton2
    case showWalkthroughButton3
    case showWalkthroughButton4

    var title: String? {
        switch self {

        case .home:
            return "Home"

        case .profile:
            return "Profile"

        case .configButton:
            return "Configuration"

        case .subtleButton:
            return "Subtle Actions"

        case .radioButton:
            return "Quick Selection"

        case .testButton:
            return "Try It Out"

        case .clusterButton:
            return "Grouped Options"

        case .breweryButton:
            return "Discover Breweries"

        case .showWalkthroughButton:
            return "Guided Tour"
            
        case .showWalkthroughButton2:
            return "Guided Tour"
            
        case .showWalkthroughButton3:
            return "Guided Tour"
            
        case .showWalkthroughButton4:
            return "Guided Tour"
        }
    }

    var description: String {
        switch self {

        case .home:
            return "This is your main hub where you can explore features and updates."

        case .profile:
            return "View and edit your personal details and account settings here."

        case .configButton:
            return "Customize your app settings and preferences."

        case .subtleButton:
            return "Access secondary actions that stay out of the way until needed."

        case .radioButton:
            return "Choose one option quickly without extra steps."

        case .testButton:
            return "Run a quick test or preview before applying changes."

        case .clusterButton:
            return "Explore related features grouped together for convenience."

        case .breweryButton:
            return "Browse nearby breweries and discover new places."

        case .showWalkthroughButton:
            return "Replay this walkthrough anytime to learn the interface again."
        case .showWalkthroughButton2:
            return "Replay this walkthrough anytime to learn the interface again."
        case .showWalkthroughButton3:
            return "Replay this walkthrough anytime to learn the interface again."
        case .showWalkthroughButton4:
            return "Replay this walkthrough anytime to learn the interface again."
        }
    }

    var image: UIImage? {
        switch self {

        case .home:
            return UIImage(systemName: "house.fill")

        case .profile:
            return UIImage(systemName: "person.crop.circle")

        case .configButton:
            return UIImage(systemName: "gearshape.fill")

        case .subtleButton:
            return UIImage(systemName: "circle.dashed")

        case .radioButton:
            return UIImage(systemName: "dot.circle.fill")

        case .testButton:
            return UIImage(systemName: "")

        case .clusterButton:
            return UIImage(systemName: "")

        case .breweryButton:
            return UIImage(systemName: "")

        case .showWalkthroughButton:
            return UIImage(systemName: "")
            
        case .showWalkthroughButton2:
            return UIImage(systemName: "")
            
        case .showWalkthroughButton3:
            return UIImage(systemName: "")
            
        case .showWalkthroughButton4:
            return UIImage(systemName: "")
        }
    }
}
