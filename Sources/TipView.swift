import Foundation
import UIKit

import UIKit

public class TipView: UIView {
    
    public struct TipViewPrefenreces {
        /// The view that is shown inside TipView. It can be any custom UIView.
        let messageView: UIView
        /// According to this view the tooltip is positioned
        let sourceView: UIView
        /// Container over tooltip
        weak var containerView: UIView?
        /// Position for tooltip
        let position: TipPosition
        let leftMargin: CGFloat
        let rightMargin: CGFloat
        
        public init(messageView: UIView, sourceView: UIView, containerView: UIView? = nil, position: TipView.TipPosition, leftMargin: CGFloat, rightMargin: CGFloat) {
            self.messageView = messageView
            self.sourceView = sourceView
            self.containerView = containerView
            self.position = position
            self.leftMargin = leftMargin
            self.rightMargin = rightMargin
        }
    }
    
    public enum TipPosition {
        case upon
        case below
    }
    
    public let preferences: TipViewPrefenreces
    private let tailWidth: CGFloat = 20
    private let tailHeight: CGFloat = 10
    
    /// Tail for TipView
    private lazy var tailView: UIView = {
        let tailView = UIView()
        tailView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tailView)
        NSLayoutConstraint.activate([
            tailView.widthAnchor.constraint(equalToConstant: tailWidth),
            tailView.heightAnchor.constraint(equalToConstant: tailWidth),
            preferences.position == .below ? tailView.bottomAnchor.constraint(equalTo: topAnchor) : tailView.topAnchor.constraint(equalTo: bottomAnchor),
            tailView.centerXAnchor.constraint(equalTo: preferences.sourceView.centerXAnchor)
        ])
        return tailView
    }()
    
    public init(preferences: TipViewPrefenreces) {
        self.preferences = preferences
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show() {
        setup()
        showTail()
    }
    
    private func showTail() {
        /// Transform tail if TipView should be shown below of sourceview
        if preferences.position == .below {
            tailView.transform = tailView.transform.rotated(by: CGFloat(Double.pi))
        }
        let tailPath = getTailPath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.black.cgColor
        shapeLayer.path = tailPath
        tailView.layer.addSublayer(shapeLayer)
    }
    
    /// Draw tail
    private func getTailPath() -> CGPath {
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: tailWidth / 2, y: tailHeight))
        bezier.addCurve(to: CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: tailWidth / 2, y: tailHeight / 2), controlPoint2: CGPoint(x: 0, y: 0))
        bezier.addLine(to: CGPoint(x: tailWidth, y: 0))
        bezier.addCurve(to: CGPoint(x: tailWidth / 2, y: tailHeight), controlPoint1: CGPoint(x: tailWidth, y: 0), controlPoint2: CGPoint(x: tailWidth / 2, y: tailHeight / 2))
        bezier.close()
        return bezier.cgPath
    }
    
    private func setup() {
        configureLook()
        preferences.containerView?.addSubview(self)
        addSubview(preferences.messageView)
        setBaseConstraints()
    }
    
    private func setBaseConstraints() {
        [self, preferences.messageView, preferences.sourceView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        guard let superview = superview else { return }
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: preferences.leftMargin),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -preferences.rightMargin),
            preferences.position == .upon ? bottomAnchor.constraint(equalTo: preferences.sourceView.topAnchor, constant: -tailHeight) : topAnchor.constraint(equalTo: preferences.sourceView.bottomAnchor, constant: tailHeight),
            preferences.messageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            preferences.messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            preferences.messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            preferences.messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    private func configureLook() {
        backgroundColor = UIColor.black
        layer.cornerRadius = 8
        layer.opacity = 0.95
        preferences.messageView.backgroundColor = .clear
    }
}
