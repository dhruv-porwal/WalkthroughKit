//
//  ViewController.swift
//  WalkthroughKitDemo
//
//  Created by Dhruv Porwal on 12/25/25.
//

import UIKit
import WalkthroughKit

class DemoViewController: UIViewController {

    let homeButton = UIButton(type: .system)
    let profileButton = UIButton(type: .system)
    let configButton = UIButton(type: .system)
    let subtleButton = UIButton(type: .system)
    let radioButton = UIButton(type: .system)
    let testButton = UIButton(type: .system)
    let clusterButton = UIButton(type: .system)
    let breweryButton = UIButton(type: .system)
    let showWalkthroughButton = UIButton(type: .system)
    let showWalkthroughButton2 = UIButton(type: .system)
    let showWalkthroughButton3 = UIButton(type: .system)
    let showWalkthroughButton4 = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupButtons()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setupButtons() {
        // Home
        homeButton.setTitle("Home", for: .normal)
        homeButton.frame = CGRect(x: 50, y: 150, width: 120, height: 50)
        view.addSubview(homeButton)

        // Profile
        profileButton.setTitle("Profile", for: .normal)
        profileButton.frame = CGRect(x: 50, y: 230, width: 120, height: 50)
        view.addSubview(profileButton)
        
        // Home
        configButton.setTitle("configButton", for: .normal)
        configButton.frame = CGRect(x: 50, y: 150, width: 120, height: 50)
        view.addSubview(configButton)

        // Profile
        subtleButton.setTitle("subtleButton", for: .normal)
        subtleButton.frame = CGRect(x: 50, y: 230, width: 120, height: 50)
        view.addSubview(subtleButton)
        
        // Home
        radioButton.setTitle("radioButton", for: .normal)
        radioButton.frame = CGRect(x: 50, y: 150, width: 120, height: 50)
        view.addSubview(radioButton)

        // Profile
        testButton.setTitle("testButton", for: .normal)
        testButton.frame = CGRect(x: 50, y: 230, width: 120, height: 50)
        view.addSubview(testButton)
        
        // Home
        clusterButton.setTitle("clusterButton", for: .normal)
        clusterButton.frame = CGRect(x: 50, y: 150, width: 120, height: 50)
        view.addSubview(clusterButton)

        // Profile
        breweryButton.setTitle("breweryButton", for: .normal)
        breweryButton.frame = CGRect(x: 50, y: 230, width: 120, height: 50)
        view.addSubview(breweryButton)
        
        // Profile
        showWalkthroughButton.setTitle("showWalkthroughButton", for: .normal)
        showWalkthroughButton.frame = CGRect(x: 50, y: 230, width: 120, height: 50)
        
        // Walkthrough Trigger
        showWalkthroughButton.setTitle("Show Walkthrough", for: .normal)
        showWalkthroughButton.frame = CGRect(x: 50, y: 330, width: 200, height: 50)
        showWalkthroughButton.backgroundColor = .systemBlue
        showWalkthroughButton.setTitleColor(.white, for: .normal)
        showWalkthroughButton.layer.cornerRadius = 8

        showWalkthroughButton.addTarget(
            self,
            action: #selector(didTapShowWalkthrough),
            for: .touchUpInside
        )

        view.addSubview(showWalkthroughButton)
        
        // Profile
        showWalkthroughButton2.setTitle("showWalkthroughButton", for: .normal)
        showWalkthroughButton2.frame = CGRect(x: 50, y: 230, width: 120, height: 50)
        
        view.addSubview(showWalkthroughButton2)
        // Profile
        showWalkthroughButton3.setTitle("showWalkthroughButton", for: .normal)
        showWalkthroughButton3.frame = CGRect(x: 50, y: 230, width: 120, height: 50)
        
        view.addSubview(showWalkthroughButton3)
        // Profile
        showWalkthroughButton4.setTitle("showWalkthroughButton", for: .normal)
        showWalkthroughButton4.frame = CGRect(x: 50, y: 230, width: 120, height: 50)
        
        
        view.addSubview(showWalkthroughButton4)
        
        
        

      
    }

    @objc private func didTapShowWalkthrough() {
        let allSteps: [(step: OnboardingStep, targetView: UIView)] = [
            (.home, homeButton),
            (.profile, profileButton),
            (.configButton, configButton),
            (.subtleButton, subtleButton),
            (.radioButton, radioButton),
            (.testButton, testButton),
            (.clusterButton, clusterButton),
            (.breweryButton, breweryButton),
            (.showWalkthroughButton, showWalkthroughButton),
            (.showWalkthroughButton2, showWalkthroughButton2),
            (.showWalkthroughButton3, showWalkthroughButton3),
            (.showWalkthroughButton4, showWalkthroughButton4),
        ]

        WalkthroughKitManager.shared.show(
            on: self,
            items: allSteps,
            theme: .default,
            onFinish: {
                print("Walkthrough finished")
            }
        )
    }
}
