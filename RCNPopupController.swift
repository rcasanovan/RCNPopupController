//
//  RCNPopupController.swift
//  Pods-RCNPopupController_Example
//
//  Created by Ricardo Casanova on 10/07/2019.
//

import UIKit

public protocol RCNPopupControllerDelegate: class {
    func popupControllerWillPresent(_ controller: RCNPopupController)
    func popupControllerDidPresent(_ controller: RCNPopupController)
    func popupControllerWillDismiss(_ controller: RCNPopupController)
    func popupControllerDidDismiss(_ controller: RCNPopupController)
}

//__ This is to allow the methods to be optional
//__ https://medium.com/@ant_one/how-to-have-optional-methods-in-protocol-in-pure-swift-without-using-objc-53151cddf4ce
public extension RCNPopupControllerDelegate {
    func popupControllerWillPresent(_ controller: RCNPopupController) {}
    func popupControllerDidPresent(_ controller: RCNPopupController) {}
    func popupControllerWillDismiss(_ controller: RCNPopupController) {}
    func popupControllerDidDismiss(_ controller: RCNPopupController) {}
}

public class RCNPopupController: NSObject {
    
    private var applicationWindow: UIWindow? = UIApplication.shared.keyWindow
    private var maskView: UIView = UIView()
    private var blurEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private var backgroundTapRecognizer: UITapGestureRecognizer?
    private var popupView: UIView = UIView()
    private var views: [UIView] = []
    private var dismissAnimated: Bool = false
    
    public var theme: RCNPopupTheme = RCNPopupTheme()
    public weak var delegate: RCNPopupControllerDelegate?
    
    public init(contents: [UIView]) {
        super.init()
        
        self.views = contents
        
        self.popupView.backgroundColor = .white
        self.popupView.clipsToBounds = true
        
        if let applicationWindow = self.applicationWindow {
            self.maskView.frame = applicationWindow.bounds
        }
        self.maskView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.backgroundTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        self.backgroundTapRecognizer?.delegate = self
        if let backgroundTapRecognizer = self.backgroundTapRecognizer {
            self.maskView.addGestureRecognizer(backgroundTapRecognizer)
        }
        
        if !UIAccessibility.isReduceTransparencyEnabled {
            self.blurEffectView.frame = self.maskView.bounds
            self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.maskView.addSubview(self.blurEffectView)
        }
        
        self.maskView.addSubview(self.popupView)
        
        addPopupContents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        //            [[NSNotificationCenter defaultCenter] addObserver:self
        //                selector:@selector(orientationWillChange)
        //                name:UIApplicationWillChangeStatusBarOrientationNotification
        //                object:nil];
        //            [[NSNotificationCenter defaultCenter] addObserver:self
        //                selector:@selector(orientationChanged)
        //                name:UIApplicationDidChangeStatusBarOrientationNotification
        //                object:nil];
    }
    
    public func presentAnimated(_ animated: Bool) {
        delegate?.popupControllerWillPresent(self)
        
        dismissAnimated = animated
        
        applyTheme()
        
        let _ = calculateContentSizeThatFits(CGSize(width: popupWidth(), height: maskView.frame.size.height), updateLayout: true)
        popupView.center = originPoint()
        
        applicationWindow?.addSubview(maskView)
        
        maskView.alpha = 0.0
        let animateDuration = Double(animated ? theme.animationDuration : 0.0)
        UIView.animate(withDuration: animateDuration, animations: {
            self.maskView.alpha = 1.0
            self.popupView.center = self.endingPoint()
        }) { (finished) in
            self.popupView.isUserInteractionEnabled = true
            self.delegate?.popupControllerDidPresent(self)
        }
    }
    
    public func dismissAnimated(_ animated: Bool) {
        delegate?.popupControllerWillDismiss(self)
        let animateDuration = Double(animated ? theme.animationDuration : 0.0)
        UIView.animate(withDuration: animateDuration, animations: {
            self.maskView.alpha = 0.0
            self.popupView.center = self.dismissedPoint()
        }) { (finished) in
            self.maskView.removeFromSuperview()
            self.delegate?.popupControllerDidDismiss(self)
        }
    }
    
}

extension RCNPopupController {
    
    @objc private func backgroundTapped() {
        if theme.shouldDismissOnBackgroundTouch {
            popupView.endEditing(true)
            dismissAnimated(self.dismissAnimated)
        }
    }
    
    private func addPopupContents() {
        for view in views {
            popupView.addSubview(view)
        }
    }
    
    @objc private func keyboardWillShow() {
        
    }
    
    @objc private func keyboardWillHide() {
        
    }
    
}

extension RCNPopupController {
    
    private func applyTheme() {
        if theme.popupStyle == .fullScreen {
            theme.presentationStyle = .fadeIn
        }
        
        if theme.popupStyle == .actionSheet {
            theme.presentationStyle = .slideInFromBottom
        }
        
        self.blurEffectView.alpha = theme.blurEffectAlpha
        popupView.layer.cornerRadius = theme.popupStyle == .centered ? theme.cornerRadius : 0.0
        popupView.backgroundColor = theme.backgroundColor
        
        var maskBackgroundColor: UIColor?
        if theme.popupStyle == .fullScreen {
            maskBackgroundColor = popupView.backgroundColor
        } else {
            switch theme.maskType {
            case .clear:
                maskBackgroundColor = .clear
            case .custom:
                maskBackgroundColor = theme.customMaskColor
            case .dimmed:
                maskBackgroundColor = UIColor.white.withAlphaComponent(0.7)
            }
        }
        
        maskView.backgroundColor = maskBackgroundColor
    }
    
    private func calculateContentSizeThatFits(_ size: CGSize, updateLayout update: Bool) -> CGSize {
        let inset = theme.popupContentInsets
        var originalSize = size
        originalSize.width -= (inset.left + inset.right)
        originalSize.height -= (inset.top + inset.bottom)
        
        var result = CGSize(width: 0.0, height: inset.top)
        for view in popupView.subviews {
            view.autoresizingMask = []
            if !view.isHidden {
                var viewSize = view.frame.size
                if viewSize.equalTo(.zero) {
                    viewSize = view.sizeThatFits(originalSize)
                    viewSize.width = originalSize.width
                    if update {
                        view.frame = CGRect(x: inset.left, y: result.height, width: viewSize.width, height: viewSize.height)
                    }
                } else {
                    if update {
                        view.frame = CGRect(x: 0.0, y: result.height, width: viewSize.width, height: viewSize.height)
                    }
                }
                
                result.height += viewSize.height + theme.contentVerticalPadding
                result.width = max(result.width, viewSize.width)
            }
        }
        
        result.height -= theme.contentVerticalPadding
        result.width += (inset.left + inset.right)
        result.height = CGFloat(min(MAXFLOAT, Float(max(0.0, result.height + inset.bottom))))
        
        if update {
            for subview in popupView.subviews {
                subview.frame = CGRect(x: (result.width - subview.frame.size.width) * 0.5, y: subview.frame.origin.y, width: subview.frame.size.width, height: subview.frame.size.height)
            }
        }
        
        popupView.frame = CGRect(x: 0.0, y: 0.0, width: result.width, height: result.height)
        
        return result
    }
    
    private func popupWidth() -> CGFloat {
        var width = theme.maxPopupWidth
        let maskViewWidth = maskView.bounds.size.width
        if width > maskViewWidth || theme.popupStyle == .fullScreen {
            width = maskViewWidth
        }
        
        return width
    }
    
    private func originPoint() -> CGPoint {
        var origin: CGPoint = .zero
        switch theme.presentationStyle {
        case .fadeIn:
            origin = maskView.center
        case .slideInFromBottom:
            origin = CGPoint(x: maskView.center.x, y: maskView.bounds.size.height + popupView.bounds.size.height)
        case .slideInFromLeft:
            origin = CGPoint(x: -popupView.bounds.size.width, y: maskView.center.y)
        case .slideInFromRight:
            origin = CGPoint(x: maskView.bounds.size.width + popupView.bounds.size.width, y: maskView.center.y)
        case .slideInFromTop:
            origin = CGPoint(x: maskView.center.x, y: -popupView.bounds.size.height)
        }
        
        return origin
    }
    
    private func endingPoint() -> CGPoint {
        var center: CGPoint = .zero
        if theme.popupStyle == .actionSheet {
            center = CGPoint(x: maskView.center.x, y: maskView.bounds.size.height - (popupView.bounds.size.height * 0.5))
        } else {
            center = maskView.center
        }
        
        return center
    }
    
    private func dismissedPoint() -> CGPoint {
        var dismissed: CGPoint = maskView.center
        
        switch theme.presentationStyle {
        case .fadeIn:
            dismissed = maskView.center
        case .slideInFromBottom:
            dismissed = theme.dismissesOppositeDirection ? CGPoint(x: maskView.center.x, y: -popupView.bounds.size.height) : CGPoint(x: maskView.center.x, y: maskView.bounds.size.height + popupView.bounds.size.height)
            if theme.popupStyle == .actionSheet {
                dismissed = CGPoint(x: maskView.center.x, y: maskView.bounds.size.height + popupView.bounds.size.height)
            }
        case .slideInFromLeft:
            dismissed = theme.dismissesOppositeDirection ? CGPoint(x: maskView.bounds.size.width + popupView.bounds.size.width, y: maskView.center.y) : CGPoint(x: -popupView.bounds.size.width, y: maskView.center.y)
        case .slideInFromRight:
            dismissed = theme.dismissesOppositeDirection ? CGPoint(x: -popupView.bounds.size.width, y: maskView.center.y) : CGPoint(x: maskView.bounds.size.width + popupView.bounds.size.width, y: maskView.center.y)
        case .slideInFromTop:
            dismissed = theme.dismissesOppositeDirection ? CGPoint(x: maskView.center.x, y: maskView.bounds.size.height + popupView.bounds.size.height) : CGPoint(x: maskView.center.y, y: -popupView.bounds.size.height)
        }
        
        return dismissed
    }
    
}

extension RCNPopupController: UIGestureRecognizerDelegate {
    
    private func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else {
            return true
        }
        
        if view.isDescendant(of: popupView) {
            return false
        }
        
        return true
    }
    
}
