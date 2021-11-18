//
//  UIColor+Hex.swift
//  App
//
//  Created by tyler on 2021/11/18.
//

import UIKit

public extension UIColor {
    convenience init(hex: String) {
        let hexStr: NSString = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased() as NSString
        let scan = Scanner(string: hexStr as String)

        if hexStr.hasPrefix("#") {
            scan.scanLocation = 1
        }

        var color: UInt32 = 0
        scan.scanHexInt32(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    func toHexStr() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0

        return NSString(format: "#%06x", rgb) as String
    }

    convenience init(r: Int, g: Int, b: Int, a: CGFloat? = nil) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a ?? 255) / 255)
    }
}
