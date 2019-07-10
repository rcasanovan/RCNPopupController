//
//  RCNPopupTheme.swift
//  RCNPopupController
//
//  Created by Ricardo Casanova on 10/07/2019.
//

import UIKit

public enum RCNPopupStyle {
    case actionSheet
    case centered
    case fullScreen
}

public enum RCNPopupPresentationStyle {
    case fadeIn
    case slideInFromTop
    case slideInFromBottom
    case slideInFromLeft
    case slideInFromRight
}

public enum RCNPopupMaskType {
    case clear
    case dimmed
    case custom
}

public struct RCNPopupTheme {
    
    public var backgroundColor: UIColor
    public var customMaskColor: UIColor
    public var cornerRadius: CGFloat
    public var popupContentInsets: UIEdgeInsets
    public var popupStyle: RCNPopupStyle
    public var maskType: RCNPopupMaskType
    public var presentationStyle: RCNPopupPresentationStyle
    public var dismissesOppositeDirection: Bool
    public var shouldDismissOnBackgroundTouch: Bool
    public var movesAboveKeyboard: Bool
    public var blurEffectAlpha: CGFloat
    public var contentVerticalPadding: CGFloat
    public var maxPopupWidth: CGFloat
    public var animationDuration: CGFloat
    
    public init() {
        self.backgroundColor = .white
        self.customMaskColor = .clear
        self.cornerRadius = 4.0
        self.popupContentInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        self.popupStyle = .centered
        self.maskType = .dimmed
        self.presentationStyle = .slideInFromBottom
        self.dismissesOppositeDirection = false
        self.shouldDismissOnBackgroundTouch = true
        self.movesAboveKeyboard = true
        self.blurEffectAlpha = 0.0
        self.contentVerticalPadding = 16.0
        self.maxPopupWidth = 300.0
        self.animationDuration = 0.3
    }
    
}
