//
//  CustomButton .swift
//  CRUD app
//
//  Created by KhaledNada on 8/30/19.
//  Copyright © 2019 KhaledNada. All rights reserved.
//

import UIKit
@IBDesignable
class CustomButton: UIButton {
    
    
    @IBInspectable var cornerRadius :CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth :CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
}
