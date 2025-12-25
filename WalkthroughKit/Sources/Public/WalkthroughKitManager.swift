//
//  WalkthroughKit.swift
//  WalkthroughKit
//
//  Created by Dhruv Porwal on 12/25/25.
//

import UIKit

@MainActor
public final class WalkthroughKitManager {
    public static let shared = WalkthroughKitManager()
    
    /// Maximum number of steps allowed in a walkthrough
    public static let maxStepsLimit: Int = 9
    
    private init() {}
    private weak var currentPopup: WalkthroughKitViewController?

    public func show<Stage: WalkthroughKitStepable>(
        on presentingVC: UIViewController,
        items: [(step: Stage, targetView: UIView)],
        theme: WalkthroughKitTheme = .default,
        onStepShown: ((_ step: Stage) -> Void)? = nil,
        onFinish: @escaping () -> Void) {
            print("Hey from WalkthroughKitManager")
        
        // Validate and limit number of steps
        guard !items.isEmpty else {
            print("WalkthroughKit: Error - No items provided")
            return
        }
        
        // Truncate to max limit if exceeded
        let limitedItems: [(step: Stage, targetView: UIView)]
        if items.count > Self.maxStepsLimit {
            print("WalkthroughKit: Warning - \(items.count) steps provided, limiting to \(Self.maxStepsLimit) steps")
            limitedItems = Array(items.prefix(Self.maxStepsLimit))
        } else {
            limitedItems = items
        }
        
        let stepsWithFrames = limitedItems.map { (step, view) -> (step: Stage, frame: CGRect) in
            let absoluteFrame = view.convert(view.bounds, to: nil)
            return (step, absoluteFrame)
        }
        
        guard !stepsWithFrames.isEmpty, currentPopup == nil else { return }

        let models = stepsWithFrames.map { (data) -> WalkthroughKitModel in
            return WalkthroughKitModel(
                image: data.step.image,
                title: WalkthroughKitTextModel(text: data.step.title ?? ""),
                description: WalkthroughKitTextModel(text: data.step.description),
                targetFrame: data.frame
            )
        }
        
        let steps = stepsWithFrames.map { $0.step }

        let popupVC = WalkthroughKitViewController(
            models: models,
            theme: theme,
            onFinish: { [weak self] in
                self?.currentPopup = nil
                onFinish()
            },
            onStepShown: { index in
                guard steps.indices.contains(index) else { return }
                onStepShown?(steps[index])
            }
        )

        currentPopup = popupVC
        presentingVC.present(popupVC, animated: true)
    }
}


