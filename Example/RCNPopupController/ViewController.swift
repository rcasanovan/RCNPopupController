//
//  ViewController.swift
//  RCNPopupController
//
//  Created by Ricardo Casanova on 07/10/2019.
//  Copyright (c) 2019 Ricardo Casanova. All rights reserved.
//

import UIKit

import RCNPopupController

class ViewController: UIViewController {
    
    var popupController: RCNPopupController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPopupWithStyle(_ popupStyle: RCNPopupStyle) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraphStyle.alignment = NSTextAlignment.center
        
        let title = NSAttributedString(string: "It's A Popup!", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24), NSAttributedString.Key.paragraphStyle: paragraphStyle])
        let lineOne = NSAttributedString(string: "You can add text and images", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.paragraphStyle: paragraphStyle])
        let lineTwo = NSAttributedString(string: "With style, using NSAttributedString", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.6), NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let button = UIButton.init(frame: CGRect(x: 0.0, y: 0.0, width: 200, height: 60))
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Close Me", for: UIControl.State())
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 4;
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0;
        titleLabel.attributedText = title
        
        let lineOneLabel = UILabel()
        lineOneLabel.numberOfLines = 0;
        lineOneLabel.attributedText = lineOne;
        
        let lineTwoLabel = UILabel()
        lineTwoLabel.numberOfLines = 0;
        lineTwoLabel.attributedText = lineTwo;
        
        let customView = UIView.init(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 55))
        customView.backgroundColor = UIColor.lightGray
        
        let textField = UITextField.init(frame: CGRect(x: 10, y: 10, width: 230, height: 35))
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder = "Custom view!"
        customView.addSubview(textField)
        
        let popupController = RCNPopupController(contents:[titleLabel, lineOneLabel, lineTwoLabel, customView, button])
        popupController.theme = RCNPopupTheme()
        popupController.theme.popupStyle = popupStyle
        // LFL added settings for custom color and blur
        popupController.theme.maskType = .custom
        popupController.theme.customMaskColor = UIColor.black.withAlphaComponent(0.2)
        popupController.theme.blurEffectAlpha = 1.0
        popupController.delegate = self
        self.popupController = popupController
        popupController.presentAnimated(true)
    }
    
    // Example action - TODO: replace with yours
    @IBAction func showPopupCentered(_ sender: AnyObject) {
        self.showPopupWithStyle(RCNPopupStyle.centered)
    }
    @IBAction func showPopupFormSheet(_ sender: AnyObject) {
        self.showPopupWithStyle(RCNPopupStyle.actionSheet)
    }
    @IBAction func showPopupFullscreen(_ sender: AnyObject) {
        self.showPopupWithStyle(RCNPopupStyle.fullScreen)
    }
    
    @objc private func buttonPressed() {
        popupController?.dismissAnimated(true)
    }
}

extension ViewController: RCNPopupControllerDelegate {
    
    func popupControllerDidPresent(_ controller: RCNPopupController) {
        print("Popup controller presented")
    }
    
    func popupControllerWillDismiss(_ controller: RCNPopupController) {
        print("Popup controller will be dismissed")
    }
    
}

