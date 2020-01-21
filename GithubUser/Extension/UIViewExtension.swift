//
//  UIViewExtension.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/21/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController?
            }
        }
        return nil
    }
    
    func frameWithCenteredX(with size: CGSize) -> CGRect {
        return CGRect(x: frame.width / 2 - size.width / 2, y: 0, width: size.width, height: size.height)
    }
    
    func isVisibleToUser() -> Bool {
        return !isHidden && window != nil && alpha > 0
    }
    
    func loadFromNib(nibName: String? = nil) {
        let fileName = nibName ?? String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: fileName, bundle: bundle)
        let contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        contentView.frame = bounds
        contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(contentView)
    }
    
    func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view = self.superview else { return nil }
        return (view as? T) ?? view.parentView(of: T.self)
    }
}
