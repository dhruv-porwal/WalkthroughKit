//
//  WalkthroughKitViewController.swift
//  WalkthroughKit
//
//  Created by Dhruv Porwal on 12/25/25.
//


import UIKit

public final class WalkthroughKitViewController: UIViewController {
    private let models: [WalkthroughKitModel]
    private let theme: WalkthroughKitTheme
    private var currentIndex: Int = 0
    private let onFinish: () -> Void
    private let onStepShown: ((_ index: Int) -> Void)?

    // Layout Constraints
    private var containerTopConstraint: NSLayoutConstraint?
    private var containerLeadingConstraint: NSLayoutConstraint?
    private var containerWidthConstraint: NSLayoutConstraint?
    private var containerHeightConstraint: NSLayoutConstraint?
    private var nextButtonWidthConstraint: NSLayoutConstraint?
    private var imageViewHeightConstraint: NSLayoutConstraint?
    private var descriptionTopConstraint: NSLayoutConstraint?

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = theme.containerBackgroundColor
        view.layer.cornerRadius = theme.containerCornerRadius
        view.clipsToBounds = false // Allow shadow to show
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Card elevation shadow
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowRadius = 24
        view.layer.shadowOffset = CGSize(width: 0, height: 18)
        view.layer.masksToBounds = false
        
        return view
    }()

    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var animatedLayers: [CAShapeLayer] = []

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = theme.titleFont
        label.textColor = theme.titleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.85
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var dotsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var dotViews: [UIView] = []

    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = theme.nextButtonFont
        button.setTitleColor(theme.nextButtonTextColor, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = theme.nextButtonBorderColor.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return button
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = theme.backButtonFont
        button.setTitleColor(theme.backButtonTextColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return button
    }()

    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = theme.overlayColor
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        view.addGestureRecognizer(tap)
        return view
    }()

    private let maskLayer = CAShapeLayer()

    public init(models: [WalkthroughKitModel], theme: WalkthroughKitTheme = .default, onFinish: @escaping () -> Void, onStepShown: ((_ index: Int) -> Void)? = nil) {
        self.models = models
        self.theme = theme
        self.onFinish = onFinish
        self.onStepShown = onStepShown
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// Configures the initial view hierarchy, background, and starts the first step.
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupOverlay()
        setupUI()
        // Set initial image state for animation
        imageView.alpha = 0
        imageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        updateStep(animated: false)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Animate image on first appearance
        if let image = imageView.image, imageView.alpha == 0 {
            UIView.animate(
                withDuration: 0.5,
                delay: 0.2,
                usingSpringWithDamping: 0.75,
                initialSpringVelocity: 0.5,
                options: .curveEaseOut,
                animations: {
                    self.imageView.alpha = 1
                    self.imageView.transform = .identity
                }
            )
        }
    }

    /// Updates the overlay frame and spotlight path when the view layout changes (e.g., device rotation).
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        overlayView.frame = view.bounds
        updateCurrentsFrames()
        if models.indices.contains(currentIndex) {
            updateSpotlight(for: models[currentIndex].targetFrame)
        }
    }
    
    /// Configures the dimmed background layer and sets up the CAShapeLayer for the mask effect.
    private func setupOverlay() {
        overlayView.frame = view.bounds
        view.insertSubview(overlayView, at: 0)
        view.addSubview(containerView)
        maskLayer.fillRule = .evenOdd
        overlayView.layer.mask = maskLayer
    }

    /// Adds subviews to the container and applies the initial Auto Layout constraints.
    private func setupUI() {
        containerView.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        [titleLabel, descriptionLabel, dotsStackView, nextButton, backButton].forEach { containerView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: nextButton.topAnchor, constant: -12),

            nextButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            nextButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            nextButton.heightAnchor.constraint(equalToConstant: 33),
            
            backButton.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor),
            backButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -15),
            
            dotsStackView.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor),
            dotsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12)
        ])
        
        imageViewHeightConstraint = imageContainerView.heightAnchor.constraint(equalToConstant: theme.imageHeight)
        imageViewHeightConstraint?.isActive = true
        
        setupAnimatedCurrents()
        
        nextButtonWidthConstraint = nextButton.widthAnchor.constraint(equalToConstant: 65)
        nextButtonWidthConstraint?.isActive = true
        
        containerWidthConstraint = containerView.widthAnchor.constraint(equalToConstant: theme.popupWidth)
        containerHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: theme.popupHeightWithImage)
        containerLeadingConstraint = containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        containerTopConstraint = containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            containerWidthConstraint!, containerHeightConstraint!, containerLeadingConstraint!, containerTopConstraint!
        ])
        
        setupDots()
        
        // Set initial description top constraint (will be updated in updateStep)
        descriptionTopConstraint = descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
        descriptionTopConstraint?.isActive = true
    }

    /// Handles the "Next" button tap. Advances to the next step or dismisses the popup if it's the last step.
    @objc private func nextTapped() {
        if currentIndex < models.count - 1 { currentIndex += 1; updateStep(animated: true) } else { dismiss(animated: true) { [weak self] in self?.onFinish() } }
    }
    
    /// Handles the "Back" button tap. Returns to the previous step.
    @objc private func backTapped() { guard currentIndex > 0 else { return }; currentIndex -= 1; updateStep(animated: true) }
    
    /// Handles taps on the dimmed background area. Functions as a "Next" action for better UX.
    @objc private func overlayTapped() { nextTapped() }
}


private extension WalkthroughKitViewController {
    
    /// Creates a cut-out "hole" in the overlay layer to highlight the specified target frame.
    /// - Parameter targetFrame: The frame of the UI element to be highlighted.
    private func updateSpotlight(for targetFrame: CGRect) {
        let path = UIBezierPath(rect: view.bounds)
        let hole = UIBezierPath(roundedRect: targetFrame, cornerRadius: 12)
        path.append(hole)
        maskLayer.path = path.cgPath
        animatePopup(around: targetFrame)
    }

    /// Calculates the optimal position for the popup (above, below, or center) relative to the target and animates the layout changes.
    /// - Parameter targetFrame: The frame of the highlighted element to position the popup around.
    private func animatePopup(around targetFrame: CGRect) {
        let screenBounds = view.bounds
        let popupWidth = theme.popupWidth
        let hasImage = models[currentIndex].image != nil
        let popupHeight = hasImage ? theme.popupHeightWithImage : theme.popupHeightWithoutImage
        let canShowBelow = targetFrame.maxY + popupHeight + 12 < screenBounds.height
        let canShowAbove = targetFrame.minY - popupHeight - 12 > 0

        let yOffset: CGFloat = canShowBelow ? targetFrame.maxY + 12 : (canShowAbove ? targetFrame.minY - popupHeight - 12 : screenBounds.midY - popupHeight / 2)
        let popupX = min(max(targetFrame.midX - popupWidth / 2, 12), screenBounds.width - popupWidth - 12)

        containerWidthConstraint?.constant = popupWidth
        containerHeightConstraint?.constant = popupHeight
        containerLeadingConstraint?.constant = popupX
        containerTopConstraint?.constant = yOffset
        imageViewHeightConstraint?.constant = hasImage ? theme.imageHeight : 0

        UIView.animate(withDuration: 0.25) { self.view.layoutIfNeeded() }
    }
    
    /// Updates the UI content (text, image, buttons) for the current step index and triggers the spotlight animation.
    /// - Parameter animated: Determines if the layout update should be animated.
    func updateStep(animated: Bool) {
        guard models.indices.contains(currentIndex) else { return }
        let model = models[currentIndex]
        
        // Show/hide currents based on image presence
        animatedLayers.forEach { $0.isHidden = model.image == nil }
        
        // Animate image appearance
        if animated && model.image != nil {
            // Fade out and scale down
            UIView.animate(withDuration: 0.15, animations: {
                self.imageView.alpha = 0
                self.imageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { _ in
                // Update image
                self.imageView.image = model.image
                // Fade in and scale up with spring
                self.imageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                UIView.animate(
                    withDuration: 0.4,
                    delay: 0,
                    usingSpringWithDamping: 0.7,
                    initialSpringVelocity: 0.5,
                    options: .curveEaseOut,
                    animations: {
                        self.imageView.alpha = 1
                        self.imageView.transform = .identity
                    }
                )
            })
        } else {
            // No animation - just set image
            imageView.image = model.image
            imageView.alpha = model.image != nil ? 1 : 0
            imageView.transform = .identity
        }
        
        // Update title
        if let title = model.title {
            titleLabel.isHidden = false
            titleLabel.font = title.font ?? theme.titleFont
            titleLabel.textColor = title.color ?? theme.titleColor
            titleLabel.text = title.text
            // Description below title
            descriptionTopConstraint?.isActive = false
            descriptionTopConstraint = descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
            descriptionTopConstraint?.isActive = true
        } else {
            titleLabel.isHidden = true
            // Description directly below image
            descriptionTopConstraint?.isActive = false
            descriptionTopConstraint = descriptionLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 12)
            descriptionTopConstraint?.isActive = true
        }
        
        // Update description
        descriptionLabel.font = model.description.font ?? theme.descriptionFont
        descriptionLabel.textColor = model.description.color ?? theme.descriptionColor
        descriptionLabel.text = model.description.text
        
        updateDots()

        backButton.isHidden = currentIndex == 0
        backButton.setTitle(theme.backButtonText, for: .normal)
        
        let buttonText = (models.count == 1 || currentIndex == models.count - 1) ? theme.finishButtonText : theme.nextButtonText
        nextButton.setTitle(buttonText, for: .normal)
        
        let textWidth = buttonText.size(withAttributes: [.font: theme.nextButtonFont]).width
        nextButtonWidthConstraint?.constant = max(65, textWidth + 32)
        
        let generator = UIImpactFeedbackGenerator(style: .light); generator.impactOccurred()
        updateSpotlight(for: model.targetFrame)
        onStepShown?(currentIndex)
    }
    
    /// Creates dot indicators for all steps
    private func setupDots() {
        // Clear existing dots
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews.removeAll()
        
        // Hide dots if only one step
        dotsStackView.isHidden = models.count == 1
        
        // Create dots for each step
        for _ in 0..<models.count {
            let dot = UIView()
            dot.layer.cornerRadius = 4
            dot.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: 8),
                dot.heightAnchor.constraint(equalToConstant: 8)
            ])
            dotsStackView.addArrangedSubview(dot)
            dotViews.append(dot)
        }
        
        updateDots()
    }
    
    /// Updates dot colors based on current step
    private func updateDots() {
        UIView.animate(withDuration: 0.25, animations: {
            for (index, dot) in self.dotViews.enumerated() {
                if index == self.currentIndex {
                    // Current step - colored/bright
                    dot.backgroundColor = self.theme.stepLabelColor
                    dot.alpha = 1.0
                    dot.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                } else {
                    // Other steps - dull/gray
                    dot.backgroundColor = self.theme.stepLabelColor
                    dot.alpha = 0.3
                    dot.transform = .identity
                }
            }
        })
    }
    
    /// Sets up animated decorative currents around the image
    private func setupAnimatedCurrents() {
        // Remove existing layers
        animatedLayers.forEach { $0.removeFromSuperlayer() }
        animatedLayers.removeAll()
        
        // Create multiple flowing paths around the image
        let colors: [UIColor] = [
            theme.stepLabelColor.withAlphaComponent(0.4),
            theme.stepLabelColor.withAlphaComponent(0.25),
            theme.stepLabelColor.withAlphaComponent(0.3)
        ]
        
        for (index, color) in colors.enumerated() {
            let layer = CAShapeLayer()
            layer.strokeColor = color.cgColor
            layer.fillColor = UIColor.clear.cgColor
            layer.lineWidth = 1.5
            layer.lineCap = .round
            layer.opacity = 0.6
            imageContainerView.layer.insertSublayer(layer, at: 0)
            animatedLayers.append(layer)
            
            // Start animation after a delay for staggered effect
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.3) {
                self.animateCurrent(layer: layer, index: index)
            }
        }
        
        // Update layer frames when layout changes
        updateCurrentsFrames()
    }
    
    /// Updates the frames of animated current layers
    private func updateCurrentsFrames() {
        let bounds = imageContainerView.bounds
        guard !bounds.isEmpty else { return }
        
        for (index, layer) in animatedLayers.enumerated() {
            let path = createFlowingPath(in: bounds, index: index)
            layer.path = path.cgPath
            layer.frame = bounds
        }
    }
    
    /// Creates a flowing curved path around the image
    private func createFlowingPath(in bounds: CGRect, index: Int) -> UIBezierPath {
        let path = UIBezierPath()
        let margin: CGFloat = 8
        let width = bounds.width
        let height = bounds.height
        
        // Create flowing curves at different positions
        switch index % 3 {
        case 0:
            // Top flowing curve
            path.move(to: CGPoint(x: -margin, y: height * 0.2))
            path.addCurve(
                to: CGPoint(x: width + margin, y: height * 0.3),
                controlPoint1: CGPoint(x: width * 0.3, y: height * 0.1),
                controlPoint2: CGPoint(x: width * 0.7, y: height * 0.4)
            )
        case 1:
            // Side flowing curve
            path.move(to: CGPoint(x: width * 0.1, y: -margin))
            path.addCurve(
                to: CGPoint(x: width * 0.9, y: height + margin),
                controlPoint1: CGPoint(x: width * 0.4, y: height * 0.3),
                controlPoint2: CGPoint(x: width * 0.6, y: height * 0.7)
            )
        default:
            // Bottom flowing curve
            path.move(to: CGPoint(x: -margin, y: height * 0.7))
            path.addCurve(
                to: CGPoint(x: width + margin, y: height * 0.8),
                controlPoint1: CGPoint(x: width * 0.3, y: height * 0.6),
                controlPoint2: CGPoint(x: width * 0.7, y: height * 0.9)
            )
        }
        
        return path
    }
    
    /// Animates a current layer with flowing motion
    private func animateCurrent(layer: CAShapeLayer, index: Int) {
        // Stroke animation - draw the path
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = 1
        strokeAnimation.duration = 2.0
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Opacity animation - fade in/out
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [0, 0.8, 0.8, 0]
        opacityAnimation.keyTimes = [0, 0.2, 0.8, 1.0]
        opacityAnimation.duration = 3.0
        
        // Group animations
        let group = CAAnimationGroup()
        group.animations = [strokeAnimation, opacityAnimation]
        group.duration = 3.0
        group.repeatCount = .greatestFiniteMagnitude
        group.beginTime = CACurrentMediaTime() + Double(index) * 0.5
        
        layer.add(group, forKey: "flowingAnimation")
    }
    
    
}
