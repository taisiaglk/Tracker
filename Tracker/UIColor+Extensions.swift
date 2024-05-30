//
//  UIColor+Extensions.swift
//  Tracker
//
//  Created by Тася Галкина on 08.05.2024.
//

import Foundation
import UIKit

extension UIColor {
    static var gray_color: UIColor { UIColor(named: "gray_color") ?? UIColor.gray }
    static var black_color: UIColor { UIColor(named: "black_color") ?? UIColor.black }
    static var white_color: UIColor { UIColor(named: "white_color") ?? UIColor.white }
    static var red_color: UIColor { UIColor(named: "red_color") ?? UIColor.red }
    static var blue_color: UIColor { UIColor(named: "blue_color") ?? UIColor.red }
    static var background_color: UIColor { UIColor(named: "background_color") ?? UIColor.gray.withAlphaComponent(0.5) }
    static var colorr1: UIColor { UIColor(named: "color1") ?? UIColor.red }
    static var colorr2: UIColor { UIColor(named: "color2") ?? UIColor.orange }
    static var colorr3: UIColor { UIColor(named: "color3") ?? UIColor.blue }
    static var colorr4: UIColor { UIColor(named: "color4") ?? UIColor.purple }
    static var colorr5: UIColor { UIColor(named: "color5") ?? UIColor.green }
    static var colorr6: UIColor { UIColor(named: "color6") ?? UIColor.systemPink }
    static var colorr7: UIColor { UIColor(named: "color7") ?? UIColor.systemPink }
    static var colorr8: UIColor { UIColor(named: "color8") ?? UIColor.blue }
    static var colorr9: UIColor { UIColor(named: "color9") ?? UIColor.green }
    static var colorr10: UIColor { UIColor(named: "color10") ?? UIColor.purple }
    static var colorr11: UIColor { UIColor(named: "color11") ?? UIColor.orange }
    static var colorr12: UIColor { UIColor(named: "color12") ?? UIColor.systemPink }
    static var colorr13: UIColor { UIColor(named: "color13") ?? UIColor.orange }
    static var colorr14: UIColor { UIColor(named: "color14") ?? UIColor.blue }
    static var colorr15: UIColor { UIColor(named: "color15") ?? UIColor.purple }
    static var colorr16: UIColor { UIColor(named: "color16") ?? UIColor.purple }
    static var colorr17: UIColor { UIColor(named: "color17") ?? UIColor.purple }
    static var colorr18: UIColor { UIColor(named: "color18") ?? UIColor.green }

}


extension UIColor {
    convenience init(hexString: String) {
        var hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if hex.count == 6 {
            hex.append("FF")
        }

        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 8:
            (a, r, g, b) = (int >> 24 & 0xFF, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        case 6:
            (a, r, g, b) = (255, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

