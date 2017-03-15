
//
//  NSObject+Extension.swift
//  LHLabel
//
//  Created by bangong on 17/3/15.
//  Copyright © 2017年 luhai. All rights reserved.
//

import Foundation

extension UIImage {
    func scale(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect.init(origin: CGPoint.zero, size: size))
        let scaleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaleImage
    }
}

extension UIColor {
    class func color(_ hex: String) -> UIColor {

        let rgbValue = strtoul(hex, nil, 16)

        let r = (rgbValue & 0xFF0000) >> 16
        let g = (rgbValue & 0xFF00) >> 8
        let b = rgbValue & 0xFF
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1);
    }


    class func hexcolor(_ hex: String) -> UIColor {
        return self.hexcolor(hex: hex, alpha: 1)
    }

    class func hexcolor(hex: String, alpha: CGFloat) -> UIColor {
        var cStr = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if cStr.hasPrefix("#") {
            cStr = cStr.substring(from: cStr.startIndex)
        }else if cStr.hasPrefix("0x") {
            cStr = cStr.substring(from: cStr.index(cStr.startIndex, offsetBy: 2))
        }

        if cStr.characters.count != 6 {
            return UIColor.black
        }
        let rStr = cStr.substring(with: cStr.startIndex ..< cStr.index(cStr.startIndex, offsetBy: 2))
        let gStr = cStr.substring(with: cStr.index(cStr.startIndex, offsetBy: 2) ..< cStr.index(cStr.startIndex, offsetBy: 4))
        let bStr = cStr.substring(with: cStr.index(cStr.startIndex, offsetBy: 4) ..< cStr.index(cStr.startIndex, offsetBy: 6))

        var r: UInt32 = 0x00
        var g: UInt32 = 0x00
        var b: UInt32 = 0x00

        Scanner.init(string: rStr).scanHexInt32(&r)
        Scanner.init(string: gStr).scanHexInt32(&g)
        Scanner.init(string: bStr).scanHexInt32(&b)

        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }

    func rgbaArray() -> Array<CGFloat> {
        var red = CGFloat.init()
        var green = CGFloat.init()
        var blue = CGFloat.init()
        var al = CGFloat.init()

        self.getRed(&red, green: &green, blue: &blue, alpha: &al)

        return [red,green,blue,al]
    }

    func hexString() -> String {
        let arr = rgbaArray()
        let r = arr[0] * 255
        let g = arr[1] * 255
        let b = arr[2] * 255
        let c = Int32(r) << 16 | Int32(g) << 8 | Int32(b)
        return String.init(format: "%x", c)
    }


    class func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor.rgba(r,g,b,1)
    }

    class func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }

//    class func color() -> UIColor {
//
//    }
}

//MARK: UIFont method
extension UIFont {
    ///通过px设置字体大小
    class func font(px: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: (72.0/96.0)*px)
    }

    class func fontTen() -> UIFont {
        return UIFont.systemFont(ofSize: 10)
    }
    class func fontEleven() -> UIFont {
        return UIFont.systemFont(ofSize: 11)
    }
    class func fontTwelve() -> UIFont {
        return UIFont.systemFont(ofSize: 12)
    }
    class func fontThirteen() -> UIFont {
        return UIFont.systemFont(ofSize: 13)
    }
    class func fontFourteen() -> UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
    class func fontFifteen() -> UIFont {
        return UIFont.systemFont(ofSize: 15)
    }
    class func fontSixteen() -> UIFont {
        return UIFont.systemFont(ofSize: 16)
    }
    class func fontSeventeen() -> UIFont {
        return UIFont.systemFont(ofSize: 17)
    }
    class func fontEighteen() -> UIFont {
        return UIFont.systemFont(ofSize: 18)
    }
    class func fontNineteen() -> UIFont {
        return UIFont.systemFont(ofSize: 19)
    }
    class func fontTwenty() -> UIFont {
        return UIFont.systemFont(ofSize: 20)
    }

}
