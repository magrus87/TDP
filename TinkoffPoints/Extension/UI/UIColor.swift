//
//  UIColor.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 16/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import UIKit

public extension UIColor {
    convenience init(netHex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((netHex >> 16) & 0xff)
        let green = CGFloat((netHex >> 8) & 0xff)
        let blue = CGFloat(netHex & 0xff)
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
