import UIKit

extension UIColor {
    static var gray_color: UIColor { UIColor(named: "gray_color") ?? UIColor.gray }
    static var black_color: UIColor { UIColor(named: "black_color") ?? UIColor.black }
    static var white_color: UIColor { UIColor(named: "white_color") ?? UIColor.white }
    static var red_color: UIColor { UIColor(named: "red_color") ?? UIColor.red }
    static var blue_color: UIColor { UIColor(named: "blue_color") ?? UIColor.blue }
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
    static var black_forAll: UIColor { UIColor(named: "black_forAll") ?? UIColor.black }
    static var date_color: UIColor { UIColor(named: "date_color") ?? UIColor.black }
    

    func hexString() -> String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        return String(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }

    static func color(from hex: String) -> UIColor {
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
