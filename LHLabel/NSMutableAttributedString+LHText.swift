//
//  NSMutableAttributedString+LHText.swift
//  LHLabel
//
//  Created by luhai on 16/11/12.
//  Copyright © 2016年 luhai. All rights reserved.
//

//* 1. NSFontAttributeName ->设置字体属性，默认值：字体：Helvetica(Neue) 字号：12
//* 2. NSParagraphStyleAttributeName ->设置文本段落排版格式，取值为 NSParagraphStyle 对象(详情见下面的API说明)
//* 3. NSForegroundColorAttributeName ->设置字体颜色，取值为 UIColor对象，默认值为黑色
//* 4. NSBackgroundColorAttributeName ->设置字体所在区域背景颜色，取值为 UIColor对象，默认值为nil, 透明色
//* 5. NSLigatureAttributeName ->设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符
//* 6. NSKernAttributeName ->设置字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
//* 7. NSStrikethroughStyleAttributeName ->设置删除线，取值为 NSNumber 对象（整数）
//* 8. NSStrikethroughColorAttributeName ->设置删除线颜色，取值为 UIColor 对象，默认值为黑色
//* 9. NSUnderlineStyleAttributeName ->设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
//* 10. NSUnderlineColorAttributeName ->设置下划线颜色，取值为 UIColor 对象，默认值为黑色
//* 11. NSStrokeWidthAttributeName ->设置笔画宽度(粗细)，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
//* 12. NSStrokeColorAttributeName ->填充部分颜色，不是字体颜色，取值为 UIColor 对象
//* 13. NSShadowAttributeName ->设置阴影属性，取值为 NSShadow 对象
//* 14. NSTextEffectAttributeName ->设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用
//* 15. NSBaselineOffsetAttributeName ->设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
//* 16. NSObliquenessAttributeName ->设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
//* 17. NSExpansionAttributeName ->设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
//* 18. NSWritingDirectionAttributeName ->设置文字书写方向，从左向右书写或者从右向左书写
//* 19. NSVerticalGlyphFormAttributeName ->设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
//* 20. NSLinkAttributeName ->设置链接属性，点击后调用浏览器打开指定URL地址
//* 21. NSAttachmentAttributeName ->设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
import UIKit
//MARK:
extension NSMutableAttributedString{

    ///NSFontAttributeName(字体)
    ///该属性所对应的值是一个 UIFont 对象。该属性用于改变一段文本的字体。如果不指定该属性，则默认为12-point Helvetica(Neue)。
    var lh_font: UIFont? {
        get {
            return self.lh_font(index: 0);
        }
        set (newValue){
            self.setLh_font(font: newValue, range: NSMakeRange(0, self.length))
        }
    }

    ///NSParagraphStyleAttributeName(段落)
    ///该属性所对应的值是一个 NSParagraphStyle 对象。该属性在一段文本上应用多个属性。如果不指定该属性，则默认为 NSParagraphStyle 的defaultParagraphStyle 方法返回的默认段落属性。
    var lh_paragraphStyle:NSParagraphStyle? {
        get {
            return self.lh_paragraphStyle(index: 0)
        }

        set (newValue){
            self.setLh_paragraphStyle(style: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }


    ///NSForegroundColorAttributeName(字体颜色)
    ///该属性所对应的值是一个 UIColor 对象。该属性用于指定一段文本的字体颜色。如果不指定该属性，则默认为黑色。
    var lh_color: UIColor? {
        get {
            var index = 0
            return self.lh_color(index: &index);
        }
        set (newValue) {
            self.setLh_color(color: newValue, range: NSMakeRange(0, self.length))
        }
    }

    ///NSBackgroundColorAttributeName(字体背景色)
   /// 该属性所对应的值是一个 UIColor 对象。该属性用于指定一段文本的背景颜色。如果不指定该属性，则默认无背景色。
    var lh_backGroundColor: UIColor? {
        get {
            return self.lh_backGroundColor(at: 0)
        }
        set (newValue){
            self.setLh_backGroundColor(color: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }

    ///连体
    ///该属性所对应的值是一个 NSNumber 对象(整数)。连体字符是指某些连在一起的字符，它们采用单个的图元符号。0 表示没有连体字符。1 表示使用默认的连体字符。2表示使用所有连体符号。默认值为 1（注意，iOS 不支持值为 2）
    var lh_ligature: NSNumber? {
        get {
            return self.lh_ligature(at: 0)
        }
        set (newValue) {
            self.setLh_ligature(ligature: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }

    ///字体间距
    ///NSKernAttributeName 设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
    var lh_kern: NSNumber? {
        get {
            return self.lh_kern(index: 0)
        }
        set (newValue) {
            self.setLh_kern(kern: newValue, range: NSMakeRange(0, self.length))
        }
    }
    ///NSStrikethroughStyleAttributeName(删除线)
    ///NSStrikethroughStyleAttributeName 设置删除线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值：


    /// 文字阴影
    var lh_shadow: NSShadow? {
        get {
            return self.lh_shadow(at: 0)
        }
        set (newValue){
            self.setLh_shadow(shadow: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }
}


//MARK:获取属性
extension NSMutableAttributedString{
    ///返回指定位置字体
    func lh_font(index: Int) -> UIFont? {
        let font = self.lh_attribute(attributeName: NSFontAttributeName, index: index) as? UIFont
        return font
    }

    //返回短落属性
    func lh_paragraphStyle(index:Int) -> NSParagraphStyle? {

        let paragraphStyle = self.lh_attribute(attributeName: NSParagraphStyleAttributeName, index: index)
        return paragraphStyle as? NSParagraphStyle
    }

    ///返回指定位置字体颜色
    func lh_color(index:inout Int) -> UIColor? {

        let color = self.lh_attribute(attributeName: NSForegroundColorAttributeName as String, index: index)
        return color as? UIColor
    }

    ///背景颜色
    func lh_backGroundColor(at index: Int) -> UIColor? {
        let color = self.lh_attribute(attributeName: NSBackgroundColorAttributeName, index: 0)
        return color as? UIColor
    }

    ///连体
    func lh_ligature(at index: Int) -> NSNumber? {
        let ligature = self.lh_attribute(attributeName: NSLigatureAttributeName, index: index)
        return ligature as? NSNumber
    }

    ///返回字距
    func lh_kern(index: Int) -> NSNumber? {
        let kern = self.lh_attribute(attributeName: NSKernAttributeName, index: index)
        return kern as? NSNumber
    }

    ///删除线

    
    /// 文字阴影
    func lh_shadow(at index: Int) -> NSShadow? {
        let shadow = self.lh_attribute(attributeName: NSShadowAttributeName, index: index)
        return shadow as? NSShadow
    }

    ///返回指定位置字符对应富文本属性值
    func lh_attribute(attributeName: String, index: Int) -> Any? {
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

    //短落属性
    func setLh_paragraphStyle(style: NSParagraphStyle?, range: NSRange) -> Void {
        self.lh_setAttribute(attributeName: NSParagraphStyleAttributeName, value: style, range: range)
    }

    ///设置字体颜色
    func setLh_color(color: UIColor?, range: NSRange) -> Void {
        self.lh_setAttribute(attributeName: NSForegroundColorAttributeName as String, value: color, range: range)
    }

    ///背景颜色
    func setLh_backGroundColor(color: UIColor?, range: NSRange) {
        self.lh_setAttribute(attributeName: NSBackgroundColorAttributeName, value: color, range: range)
    }

    ///连体
    func setLh_ligature(ligature: NSNumber?, range: NSRange) {
       self.lh_setAttribute(attributeName: NSLigatureAttributeName, value: ligature, range: range)
    }
    ///设置字距
    func setLh_kern(kern: NSNumber?, range: NSRange) -> Void {
        self.lh_setAttribute(attributeName: NSKernAttributeName as String, value: kern, range: range)
    }

    ///删除线
    func setLh_strikethroughStyle(style: NSUnderlineStyle, range: NSRange) {
       self.lh_setAttribute(attributeName: NSStrikethroughStyleAttributeName, value: (style.hashValue), range: range)
    }
    
    /// 文字阴影
    func setLh_shadow(shadow: NSShadow?, range: NSRange) {
        self.lh_setAttribute(attributeName: NSShadowAttributeName, value: shadow, range: range)
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
    func add(image: UIImage?, frame: CGRect, range: NSRange) -> Void {
        let attribute = self.attribute(image: image, frame: frame)
        self.replaceCharacters(in: range, with: attribute)
    }

    func insert(image: UIImage?, frame: CGRect, index: Int) -> Void {
        let attribute = self.attribute(image: image, frame: frame)
        self.insert(attribute, at: index)
    }

    func append(image: UIImage?, frame: CGRect) -> Void {
        let attribute = self.attribute(image: image, frame: frame)
        self .append(attribute)
    }

    func attribute(image: UIImage?, frame: CGRect) -> NSAttributedString {
        let attachment = NSTextAttachment.init()
        attachment.image = image
        attachment.bounds = frame
        let attributed = NSAttributedString.init(attachment: attachment)
        return attributed
    }
}
