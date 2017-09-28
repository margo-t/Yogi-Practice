//
//  DesignableButton.swift
//  Yogi Practice
//
//  Created by margot on 2017-09-27.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import UIKit

@IBDesignable class DesignableButton: UIButton {

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
//    @IBInspectable var borderColor: UIColor = UIColor.white {
//        didSet {
//            self.layer.borderColor = (borderColor as! CGColor )
//        }
//    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

}
