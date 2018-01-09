//
//  DesignableButton.swift
//  Yogi Practice
//
//  Created by margot on 2017-09-27.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import UIKit

@IBDesignable class DesignableButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
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
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

//    @IBInspectable var borderWidth: CGFloat = 0.0 {
//        didSet {
//            self.layer.borderWidth = borderWidth
//        }
//    }
    
//    @IBInspectable var borderColor: UIColor = UIColor.white {
//        didSet {
//            self.layer.borderColor = (borderColor as! CGColor )
//        }
//    }
    
//    @IBInspectable var cornerRadius: CGFloat = 0 {
//        didSet {
//            self.layer.cornerRadius = cornerRadius
//        }
//    }

}
