//
//  NSMutableAttributedString+LHText.swift
//  LHLabel
//
//  Created by luhai on 16/11/12.
//  Copyright © 2016年 luhai. All rights reserved.
//

import UIKit
//MARK:
extension NSMutableAttributedString{

    /*字体*/
    var lh_font: UIFont? {
        get {
            return self.lh_font(index: 0);
        }
        set (newFont){
            self.setLh_font(font: newFont, range: NSMakeRange(0, self.length))
        }
    }

    ///字体颜色
    var lh_color: UIColor? {
        get {
            var index = 0
            return self.lh_color(index: &index);
        }
        set (newColor) {
            self.setLh_color(color: newColor, range: NSMakeRange(0, self.length))
        }
    }

    ///字体间距
    var lh_kern: NSNumber? {
        get {
            return self.lh_kern(index: 0)
        }
        set (newKern) {
            self.setLh_kern(kern: newKern, range: NSMakeRange(0, self.length))
        }
    }

    ///段落属性
    var lh_paragraphStyle:NSParagraphStyle? {
        get {
            return self.lh_paragraphStyle(index: 0)
        }

        set (newStyle){
            self.setLh_paragraphStyle(style: newStyle, range: NSRange.init(location: 0, length: self.length))
        }
    }
}


//MARK:获取属性
extension NSMutableAttributedString{
    ///返回指定位置字体
    func lh_font(index: NSInteger) -> UIFont? {
        let font = self.lh_attribute(attributeName: NSFontAttributeName, index: index) as? UIFont
        return font
    }

    ///返回指定位置字体颜色
    func lh_color(index:inout NSInteger) -> UIColor? {

        let color = self.lh_attribute(attributeName: NSForegroundColorAttributeName as String, index: index)
        return color as? UIColor
    }

    ///返回字距
    func lh_kern(index: NSInteger) -> NSNumber? {
        let kern = self.lh_attribute(attributeName: NSKernAttributeName, index: index)
        return kern as? NSNumber
    }

    //返回短落属性
    func lh_paragraphStyle(index:NSInteger) -> NSParagraphStyle? {

        let paragraphStyle = self.lh_attribute(attributeName: NSParagraphStyleAttributeName, index: index)
        return paragraphStyle as? NSParagraphStyle
    }

    ///返回指定位置字符对应富文本属性值
    func lh_attribute(attributeName: String, index: NSInteger) -> Any? {
        if self.length == 0 {
            return nil
        }
        var atIndex = index

        if atIndex == self.length{
            atIndex -= 1
        }
        return self.attribute(attributeName, at: atIndex, effectiveRange: nil)
    }
}

//MARK:设置属性
extension NSMutableAttributedString{
    ///设置字体
    func setLh_font(font: UIFont?, range: NSRange) -> Void {

        self.lh_setAttribute(attributeName: NSFontAttributeName, value: font, range: range)
    }

    ///设置字体颜色
    func setLh_color(color: UIColor?, range: NSRange) -> Void {
        self.lh_setAttribute(attributeName: NSForegroundColorAttributeName as String, value: color, range: range)
        //self.lh_setAttribute(attributeName: <#T##String#>, value: <#T##Any?#>, range: <#T##NSRange#>)
    }

    ///设置字距
    func setLh_kern(kern: NSNumber?, range: NSRange) -> Void {
        self.lh_setAttribute(attributeName: NSKernAttributeName as String, value: kern, range: range)
    }

    //短落属性
    func setLh_paragraphStyle(style: NSParagraphStyle?, range: NSRange) -> Void {
        self.lh_setAttribute(attributeName: NSParagraphStyleAttributeName, value: style, range: range)
    }

    //设置富文本属性
    func lh_setAttribute(attributeName:String, value:Any?, range:NSRange) -> Void {
        if NSNull.isEqual(attributeName) {
            return;
        }


        if (value != nil && !NSNull.isEqual(attributeName)){
            //移除旧的，添加新的
            self.removeAttribute(attributeName, range: range)
            self.addAttribute(attributeName, value: value!, range: range)
        }else{
            //移除属性
            self.removeAttribute(attributeName, range: range)
        }
    }
}


//MARK:添加图片
extension NSMutableAttributedString{
    func add(image: UIImage, frame: CGRect, range: NSRange) -> Void {
        let attribute = self.attribute(image: image, frame: frame)
        self.replaceCharacters(in: range, with: attribute)
    }

    func insert(image: UIImage, frame: CGRect, index: Int) -> Void {
        let attribute = self.attribute(image: image, frame: frame)
        self.insert(attribute, at: index)
    }

    func append(image: UIImage, frame: CGRect) -> Void {
        let attribute = self.attribute(image: image, frame: frame)
        self .append(attribute)
    }

    func attribute(image: UIImage, frame: CGRect) -> NSAttributedString {
        let attachment = NSTextAttachment.init()
        attachment.image = image
        attachment.bounds = frame
        let attributed = NSAttributedString.init(attachment: attachment)
        return attributed
    }
}
