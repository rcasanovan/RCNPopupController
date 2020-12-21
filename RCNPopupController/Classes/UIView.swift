//
//  UIView.swift
//  RCNPopupController
//
//  Created by Ricardo Casanova on 21/12/20.
//

import UIKit

extension UIView {
    
    func removeAllSubviews() {
        self.subviews.forEach { (subView) in
            subView.removeFromSuperview()
        }
    }
    
    /**
     * Add constraint(s) to a view using VFL
     *
     * **Usage**
     * ````
     * someView.addConstraintsWithFormat("H:|-[v0]-[v1]-|", label1, label2)
     * ````
     *
     * **Important**
     *
     * * The views referenced in the VFL string, have to be numbered starting from 0 (zero)
     * including the letter **v** as prefix (eg: v0, v1, ..., vn).
     * * The number of views passed has to be equal to the number of views referenced in the **format** parameter
     *
     * - parameters:
     *     - format: A string representing the VFL structure
     *     - views: Comma separated list of views referenced within the VFL
     */
    @discardableResult func addConstraintsWithFormat(_ format: String, views: UIView...) -> [NSLayoutConstraint] {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary)
        addConstraints(constraints)
        
        return constraints
    }
    
    func alignAllCenteredSubview(_ subview: UIView) {
        // Center horizontally
        var constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[superview]-(<=1)-[subview]",
            options: NSLayoutConstraint.FormatOptions.alignAllCenterX,
            metrics: nil,
            views: ["superview":self, "subview":subview])

        self.addConstraints(constraints)

        // Center vertically
        constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[superview]-(<=1)-[subview]",
            options: NSLayoutConstraint.FormatOptions.alignAllCenterY,
            metrics: nil,
            views: ["superview":self, "subview":subview])

        self.addConstraints(constraints)
    }

}
