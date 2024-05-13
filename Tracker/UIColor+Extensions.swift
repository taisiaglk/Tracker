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
    

}

