//
//  WalkthroughKitModels.swift
//  WalkthroughKit
//
//  Created by Dhruv Porwal on 12/25/25.
//


import UIKit

public protocol WalkthroughKitStepable {
    var title: String? { get }
    var description: String { get }
    var image: UIImage? { get }
}

public struct WalkthroughKitTextModel {
    public let text: String
    public let font: UIFont?
    public let color: UIColor?
    
    public init(text: String, font: UIFont? = nil, color: UIColor? = nil) {
        self.text = text
        self.font = font
        self.color = color
    }
}

public struct WalkthroughKitModel {
    public let image: UIImage?
    public let title: WalkthroughKitTextModel?
    public let description: WalkthroughKitTextModel
    public var targetFrame: CGRect
    
    public init(image: UIImage? = nil, title: WalkthroughKitTextModel? = nil, description: WalkthroughKitTextModel, targetFrame: CGRect) {
        self.image = image
        self.title = title
        self.description = description
        self.targetFrame = targetFrame
    }
}
