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
        set (new){
            var frame = self.frame;
            frame.origin.y += new;
            self.frame = frame;
        }
    }
    
    var lh_left: CGFloat {
        get {
            return self.frame.minX;
        }
        set (new){
            var frame = self.frame;
            frame.origin.x += new;
            self.frame = frame;
        }
    }
    
    var lh_bottom: CGFloat {
        get {
            return self.frame.maxY;
        }
        set (new){
            var frame = self.frame;
            frame.origin.y = new - self.frame.height;
            self.frame = frame;
        }
    }
    
    var lh_right: CGFloat {
        get {
            return self.frame.minX;
        }
        set (new){
            var frame = self.frame;
            frame.origin.x = new - self.frame.width;
            self.frame = frame;
        }
    }
    
    var lh_width: CGFloat {
        get {
            return self.frame.width;
        }
        set (new){
            var frame = self.frame;
            frame.size.width = new;
            self.frame = frame;
        }
    }
    
    var lh_height: CGFloat {
        get {
            return self.frame.height;
        }
        set (new){
            var frame = self.frame;
            frame.size.height = new;
            self.frame = frame;
        }
    }
    
    var lh_size: CGSize {
        get {
            return self.frame.size;
        }
        set (newSize){
            var frame = self.frame;
            frame.size.width = newSize.width;
            frame.size.height = newSize.height;
            self.frame = frame;
        }
    }
    
    var lh_centerX: CGFloat {
        get {
            return self.center.x
        }
        set (new) {
            var center = self.center;
            center.x = new
            self.center = center;
        }
    }
    
    var lh_centerY: CGFloat {
        get {
            return self.center.y
        }
        set (new) {
            var center = self.center;
            center.y = new
            self.center = center;
        }
    }
    
    var lh_center: CGPoint {
        get {
            return self.center
        }
        set (newPoint) {
            self.center = newPoint
        }
    }
    
}

