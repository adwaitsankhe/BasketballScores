//
//  UIColor+FromHex.swift
//  FD_iOS_takehome
//
//  Created by Adwait Y Sankhé on 2/7/20.
//  Copyright © 2020 FanDuel. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        var color: UInt32 = 0
        scanner.scanLocation = hexString.hasPrefix("#") ? 1 : 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask, g = Int(color >> 8) & mask, b = Int(color) & mask
        let red = CGFloat(r) / 255.0, green = CGFloat(g) / 255.0, blue = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
