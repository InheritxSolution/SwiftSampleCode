//
//  CustomeComponents.swift
//  Code_structure_with_login
//
//  Created by vishal lakum on 13/11/20.
//  Copyright © 2020 vishal lakum. All rights reserved.
//
import UIKit

class CustomButton: UIButton {

    @IBInspectable override var cornerRadius: CGFloat {
        didSet {
            layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
            self.layer.masksToBounds = true
        }
    }

    @IBInspectable var cornerRadiusByHeight: Bool = false {
        didSet {
            layer.cornerRadius = self.frame.size.height/2
        }
    }

    @IBInspectable var roundButton: Bool = false {
        didSet {
            layer.cornerRadius = self.frame.size.width / 2
            self.clipsToBounds = true
            self.layer.masksToBounds = true
        }
    }

    override internal func awakeFromNib() {
        super.awakeFromNib()
    }

}

class MainActionButton: CustomButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cornerRadius = 10
        self.backgroundColor = UIColor.init(named: "buttonColor")
        self.setTitleColor(UIColor.init(named: "buttonTitleColor"), for: .normal)
    }
}
