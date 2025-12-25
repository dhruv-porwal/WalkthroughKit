//
//  WalkthroughKitTheme.swift
//  WalkthroughKit
//
//  Created by Dhruv Porwal on 12/25/25.
//

import UIKit

@MainActor
public struct WalkthroughKitTheme {
    public var nextButtonText: String
    public var backButtonText: String
    public var finishButtonText: String
    
    public var popupWidth: CGFloat
    public var imageHeight: CGFloat
    public var popupHeightWithImage: CGFloat
    public var popupHeightWithoutImage: CGFloat
    public var containerCornerRadius: CGFloat
    
    public var containerBackgroundColor: UIColor
    public var titleFont: UIFont
    public var titleColor: UIColor
    public var descriptionFont: UIFont
    public var descriptionColor: UIColor
    public var stepLabelFont: UIFont
    public var stepLabelColor: UIColor
    
    public var nextButtonFont: UIFont
    public var nextButtonTextColor: UIColor
    public var nextButtonBorderColor: UIColor
    public var backButtonFont: UIFont
    public var backButtonTextColor: UIColor
    
    public var overlayColor: UIColor
    
    public static let `default` = WalkthroughKitTheme(
        nextButtonText: "Continue",
        backButtonText: "Back",
        finishButtonText: "Done",
        popupWidth: 300,
        imageHeight: 120,
        popupHeightWithImage: 280,
        popupHeightWithoutImage: 160,
        containerCornerRadius: 12,
        containerBackgroundColor: .systemBackground,
        titleFont: .systemFont(ofSize: 20, weight: .bold),
        titleColor: .label,
        descriptionFont: .systemFont(ofSize: 15, weight: .regular),
        descriptionColor: .label,
        stepLabelFont: .systemFont(ofSize: 15, weight: .regular),
        stepLabelColor: UIColor.systemBlue,
        nextButtonFont: .systemFont(ofSize: 15, weight: .semibold),
        nextButtonTextColor: .systemGreen,
        nextButtonBorderColor: .systemGreen,
        backButtonFont: .systemFont(ofSize: 15, weight: .bold),
        backButtonTextColor: .systemGreen,
        overlayColor: UIColor.black.withAlphaComponent(0.6)
    )
    
    // Custom init
    public init(
        nextButtonText: String = "Next",
        backButtonText: String = "Back",
        finishButtonText: String = "Got it",
        popupWidth: CGFloat = 300,
        imageHeight: CGFloat = 120,
        popupHeightWithImage: CGFloat = 280,
        popupHeightWithoutImage: CGFloat = 160,
        containerCornerRadius: CGFloat = 12,
        containerBackgroundColor: UIColor = .systemBackground,
        titleFont: UIFont = .systemFont(ofSize: 20, weight: .bold),
        titleColor: UIColor = .label,
        descriptionFont: UIFont = .systemFont(ofSize: 15),
        descriptionColor: UIColor = .label,
        stepLabelFont: UIFont = .systemFont(ofSize: 15),
        stepLabelColor: UIColor = .secondaryLabel,
        nextButtonFont: UIFont = .systemFont(ofSize: 15, weight: .semibold),
        nextButtonTextColor: UIColor = .systemGreen,
        nextButtonBorderColor: UIColor = .systemGreen,
        backButtonFont: UIFont = .systemFont(ofSize: 15, weight: .bold),
        backButtonTextColor: UIColor = .systemGreen,
        overlayColor: UIColor = UIColor.black.withAlphaComponent(0.6))
    {
        self.nextButtonText = nextButtonText
        self.backButtonText = backButtonText
        self.finishButtonText = finishButtonText
        self.popupWidth = popupWidth
        self.imageHeight = imageHeight
        self.popupHeightWithImage = popupHeightWithImage
        self.popupHeightWithoutImage = popupHeightWithoutImage
        self.containerCornerRadius = containerCornerRadius
        self.containerBackgroundColor = containerBackgroundColor
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.descriptionFont = descriptionFont
        self.descriptionColor = descriptionColor
        self.stepLabelFont = stepLabelFont
        self.stepLabelColor = stepLabelColor
        self.nextButtonFont = nextButtonFont
        self.nextButtonTextColor = nextButtonTextColor
        self.nextButtonBorderColor = nextButtonBorderColor
        self.backButtonFont = backButtonFont
        self.backButtonTextColor = backButtonTextColor
        self.overlayColor = overlayColor
    }
}
