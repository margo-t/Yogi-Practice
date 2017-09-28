//
//  DesignableView.swift
//  Yogi Practice
//
//  Created by margot on 2017-09-27.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import UIKit

class DesignableView: UIView {

    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
