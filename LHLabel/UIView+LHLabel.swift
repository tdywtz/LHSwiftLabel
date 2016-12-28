//
//  UIView+LHLabel.swift
//  LHLabel
//
//  Created by luhai on 16/11/12.
//  Copyright © 2016年 luhai. All rights reserved.
//

import UIKit

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



extension UIView {

    ///截取view
    func screenshot(at aView: UIView) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(aView.lh_size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext(){
            aView.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
            return nil
    }
}




