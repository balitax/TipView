import UIKit
import PlaygroundSupport

class TipViewController: UIViewController {
    
    /// The view that is shown inside TipView. It can be any custom UIView.
    private let messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged"
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        return messageLabel
    }()
    
    private lazy var showButton: UIButton = {
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { _ in
            self.showTipView()
        }))
        button.layer.borderColor = UIColor.link.cgColor
        button.layer.borderWidth = 1.0
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.cornerRadius = 8
        button.setTitle("Show tip", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(showButton)
        NSLayoutConstraint.activate([
            showButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func showTipView() {
        let tipPreferences = TipView.TipViewPrefenreces(
            messageView: messageLabel,
            sourceView: showButton,
            containerView: view,
            position: .below,
            leftMargin: 16,
            rightMargin: 16
        )
        let tipView = TipView(preferences: tipPreferences)
        tipView.show()
    }
}


let vc = TipViewController()

PlaygroundPage.current.liveView = vc
