import UIKit

open class BlurViewController: UIViewController {
    public var isClosable: Bool = true {
        didSet {
            panGestureRecognizer?.isEnabled = isClosable
            sliderLayer.isHidden = !isClosable
        }
    }
    
    let sliderLayer: CALayer = {
        let layer = CALayer()
        layer.cornerRadius = 2
        layer.backgroundColor = SoramitsuUI.shared.theme.palette.color(.fgTertiary).cgColor
        return layer
    }()
    
    public var backgroundColor: SoramitsuColor = .custom(uiColor: .clear)
    public var completionHandler: (() -> Void)?
    
    lazy var blurredView: UIView = {
        let containerView = UIView()
        let blurEffect = UIBlurEffect(style: .light)
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.5)
        customBlurEffectView.frame = self.view.bounds

        containerView.addSubview(customBlurEffectView)
        return containerView
    }()

    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupView()
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        view.backgroundColor = SoramitsuUI.shared.theme.palette.color(backgroundColor)
        view.addSubview(blurredView)
        
        view.layer.addSublayer(sliderLayer)
        
        let xPosition = (UIScreen.main.bounds.width / 2) - 16
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let yPosition = scene?.windows.first?.safeAreaInsets.top ?? .zero
        sliderLayer.frame = CGRect(x: xPosition, y: yPosition, width: 32, height: 4)
        
        view.sendSubviewToBack(blurredView)

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        panGestureRecognizer?.isEnabled = isClosable
        view.addGestureRecognizer(panGestureRecognizer!)
    }

    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)

        if panGesture.state == .began {
            originalPosition = view.center
            currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            view.frame.origin = CGPoint(
                x: 0,
                y: translation.y > 0 ? translation.y : 0
            )
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)

            if velocity.y >= 1500 {
                UIView.animate(withDuration: 0.2
                               , animations: {
                    self.view.frame.origin = CGPoint(
                        x: 0,
                        y: self.view.frame.size.height
                    )
                }, completion: { [weak self] (isCompleted) in
                    if isCompleted {
                        self?.dismiss(animated: false, completion: self?.completionHandler)
                    }
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalPosition!
                })
            }
        }
    }
}
