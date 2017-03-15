
//
//  UIResponder+Extension.swift
//  LHLabel
//
//  Created by bangong on 17/3/15.
//  Copyright © 2017年 luhai. All rights reserved.
//

import Foundation

//MARK: UIView layout
extension UIView{

    var lh_top: CGFloat {
        get {
            return self.frame.minY;
        }
        set {
            var frame = self.frame;
            frame.origin.y += newValue;
            self.frame = frame;
        }
    }

    var lh_left: CGFloat {
        get {
            return self.frame.minX;
        }
        set {
            var frame = self.frame;
            frame.origin.x += newValue;
            self.frame = frame;
        }
    }

    var lh_bottom: CGFloat {
        get {
            return self.frame.maxY;
        }
        set {
            var frame = self.frame;
            frame.origin.y = newValue - self.frame.height;
            self.frame = frame;
        }
    }

    var lh_right: CGFloat {
        get {
            return self.frame.minX;
        }
        set {
            var frame = self.frame;
            frame.origin.x = newValue - self.frame.width;
            self.frame = frame;
        }
    }

    var lh_width: CGFloat {
        get {
            return self.frame.width;
        }
        set {
            var frame = self.frame;
            frame.size.width = newValue;
            self.frame = frame;
        }
    }

    var lh_height: CGFloat {
        get {
            return self.frame.height;
        }
        set {
            var frame = self.frame;
            frame.size.height = newValue;
            self.frame = frame;
        }
    }

    var lh_size: CGSize {
        get {
            return self.frame.size;
        }
        set {
            var frame = self.frame;
            frame.size.width = newValue.width;
            frame.size.height = newValue.height;
            self.frame = frame;
        }
    }

    var lh_centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            var center = self.center;
            center.x = newValue
            self.center = center;
        }
    }

    var lh_centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            var center = self.center;
            center.y = newValue
            self.center = center;
        }
    }

    var lh_center: CGPoint {
        get {
            return self.center
        }
        set {
            self.center = newValue
        }
    }
}


//MARK: UIView method
extension UIView {

    /// 设置边框
    ///
    /// - Parameters:
    ///   - cornerRadius: 圆角半径
    ///   - lineColor: 线条颜色
    ///   - lineWith: 线条宽度
    func border(radius: CGFloat, color: UIColor, with: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = with
    }

    ///高斯模糊
    @available(iOS 8.0, *)
    func setBlur(style: UIBlurEffectStyle) {
        let effect = UIBlurEffect.init(style: style)
        let effectView = UIVisualEffectView.init(effect: effect)
        effectView.frame = self.bounds
        self .addSubview(effectView)
    }

    ///截取view
    func screenShot() -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, 0.0)
        if let context = UIGraphicsGetCurrentContext(){
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }

    func setTransform3D(_ angle: CGFloat, anchorPoint: CGPoint){

        var transform = CATransform3DIdentity
        transform.m34 = 0.001;
        transform = CATransform3DRotate(transform, angle, 0, 1, 0)

        self.layer.anchorPoint = anchorPoint
        self.layer.transform = transform
    }

}

//MARK: UILabel method
extension UILabel {
    class func label(font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel.init()
        label.font = font
        label.textColor = color
        return label
    }
}
