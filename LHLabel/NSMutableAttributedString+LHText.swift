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

    ///*1. 该属性所对应的值是一个 UIFont 对象。该属性用于改变一段文本的字体。如果不指定该属性，则默认为12-point Helvetica(Neue)。
    var lh_font: UIFont? {
        get {
            return self.lh_font(index: 0);
        }
        set (newValue){
            self.setLh_font(font: newValue, range: NSMakeRange(0, self.length))
        }
    }

    ///*2. 该属性所对应的值是一个 NSParagraphStyle 对象。该属性在一段文本上应用多个属性。如果不指定该属性，则默认为 NSParagraphStyle 的defaultParagraphStyle 方法返回的默认段落属性。
    var lh_paragraphStyle:NSParagraphStyle? {
        get {
            return self.lh_paragraphStyle(index: 0)
        }

        set (newValue){
            self.setLh_paragraphStyle(style: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }

    ///*3. 该属性所对应的值是一个 UIColor 对象。该属性用于指定一段文本的字体颜色。如果不指定该属性，则默认为黑色。
    var lh_color: UIColor? {
        get {
            var index = 0
            return self.lh_color(index: &index);
        }
        set (newValue) {
            self.setLh_color(color: newValue, range: NSMakeRange(0, self.length))
        }
    }

    ///*4.  该属性所对应的值是一个 UIColor 对象。该属性用于指定一段文本的背景颜色。如果不指定该属性，则默认无背景色。
    var lh_backGroundColor: UIColor? {
        get {
            return self.lh_backGroundColor(at: 0)
        }
        set (newValue){
            self.setLh_backGroundColor(color: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }

    ///*5. 该属性所对应的值是一个 NSNumber 对象(整数)。连体字符是指某些连在一起的字符，它们采用单个的图元符号。0 表示没有连体字符。1 表示使用默认的连体字符。2表示使用所有连体符号。默认值为 1（注意，iOS 不支持值为 2）
    var lh_ligature: NSNumber? {
        get {
            return self.lh_ligature(at: 0)
        }
        set (newValue) {
            self.setLh_ligature(ligature: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }

    ///*6. NSKernAttributeName 设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
    var lh_kern: NSNumber? {
        get {
            return self.lh_kern(index: 0)
        }
        set (newValue) {
            self.setLh_kern(kern: newValue, range: NSMakeRange(0, self.length))
        }
    }

    ///*7. NSStrikethroughStyleAttributeName(删除线)
    var lh_strikethroughStyle: NSUnderlineStyle? {
        get {
            return self.lh_strikethroughStyle(at: 0)
        }
        set (newValue) {
            self.setLh_strikethroughStyle(style: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }

    ///* 8. NSStrikethroughColorAttributeName ->设置删除线颜色，取值为 UIColor 对象，默认值为黑色
    var lh_strikethroughColor: UIColor? {
        get {
            return self.lh_strikethroughColor(at: 0)
        }
        set (newValue){
            self.setLh_strikethroughColor(color: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }

    ///* 9. NSUnderlineStyleAttributeName ->设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
    var lh_underlineStyle: NSUnderlineStyle {
        get {
            return self.lh_underlineStyle(at: 0)
        }
        set (newValue) {
            self.setLh_underlineStyle(style: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }

    //* 10. NSUnderlineColorAttributeName ->设置下划线颜色，取值为 UIColor 对象，默认值为黑色
    var lh_underlineColor: UIColor? {
        get {
            return self.lh_underlineColor(at: 0)
        }
        set (newValue){
            self.setLh_underlineColor(color: newValue, range: NSRange.init(location: 0, length: length))
        }
    }


    ///* 11. NSStrokeWidthAttributeName ->设置笔画宽度(粗细)，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
    var lh_strokeWidth: NSNumber? {
        get {
            return self.lh_strokeWidth(at: 0)
        }
        set (newValue){
            self.setLh_strokeWidth(width: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }

    //* 12. NSStrokeColorAttributeName ->填充部分颜色，不是字体颜色，取值为 UIColor 对象
    var lh_strokeColor: UIColor? {
        get {
            return self.lh_strokeColor(at: 0)
        }
        set (newValue) {
            self.setLh_strokeColor(color: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }

    //* 13. NSShadowAttributeName ->设置阴影属性，取值为 NSShadow 对象
    var lh_shadow: NSShadow? {
        get {
            return self.lh_shadow(at: 0)
        }
        set (newValue){
            self.setLh_shadow(shadow: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }
    //* 14. NSTextEffectAttributeName ->设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用
    var lh_textEffect: NSString? {
        get {
            return self.lh_textEffect(at: 0)
        }
        set (newValue) {
            self.setLh_textEffect(textEffect: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }
    //* 15. NSBaselineOffsetAttributeName ->设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
    var lh_baselineOffset: NSNumber? {
        get {
            return self.lh_baselineOffset(at: 0)
        }
        set (newValue) {
            self.setLh_baselineOffset(baselineOffset: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }

    //* 16. NSObliquenessAttributeName ->设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
    var lh_obliqueness: NSNumber? {
        get {
            return self.lh_obliqueness(at: 0)
        }
        set (newValue) {
            self.setLh_obliqueness(obliqueness: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }

    //* 17. NSExpansionAttributeName ->设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
    var lh_expansion: NSNumber? {
        get {
            return self.lh_expansion(at: 0)
        }
        set (newValue) {
            self.setLh_expansion(expansion: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }

    //* 18. NSWritingDirectionAttributeName ->设置文字书写方向，从左向右书写或者从右向左书写
    //    var lh_writingDirection: String? {
    //        get {
    //
    //        }
    //        set (newValue) {
    //
    //        }
    //    }

    //* 19. NSVerticalGlyphFormAttributeName ->设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
    //    var lh_verticalGlyph: String? {
    //        get {
    //
    //        }
    //        set (newValue) {
    //
    //        }
    //    }

    //* 20. NSLinkAttributeName ->设置链接属性，点击后调用浏览器打开指定URL地址
    var lh_link: NSURL? {
        get {
            return self.lh_link(at: 0)
        }
        set (newValue) {
            self.setLh_link(link: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }

    //* 21. NSAttachmentAttributeName ->设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
    var lh_attachment: NSTextAttachment? {
        get {
            return self.lh_attachment(at: 0)
        }
        set (newValue) {
            self.setLh_attachment(attachment: newValue, range: NSRange.init(location: 0, length: self.length))
        }
    }
}


//MARK:获取属性
extension NSMutableAttributedString{
    ///1 返回指定位置字体
    func lh_font(index: Int) -> UIFont? {
        let font = self.lh_attribute(attributeName: NSFontAttributeName, index: index) as? UIFont
        return font
    }

    //2 返回短落属性
    func lh_paragraphStyle(index:Int) -> NSParagraphStyle? {

        let paragraphStyle = self.lh_attribute(attributeName: NSParagraphStyleAttributeName, index: index)
        return paragraphStyle as? NSParagraphStyle
    }

    ///3 返回指定位置字体颜色
    func lh_color(index:inout Int) -> UIColor? {

        let color = self.lh_attribute(attributeName: NSForegroundColorAttributeName as String, index: index)
        return color as? UIColor
    }

    ///4 背景颜色
    func lh_backGroundColor(at index: Int) -> UIColor? {
        let color = self.lh_attribute(attributeName: NSBackgroundColorAttributeName, index: 0)
        return color as? UIColor
    }

    ///5 连体
    func lh_ligature(at index: Int) -> NSNumber? {
        let ligature = self.lh_attribute(attributeName: NSLigatureAttributeName, index: index)
        return ligature as? NSNumber
    }

    ///6 返回字距
    func lh_kern(index: Int) -> NSNumber? {
        let kern = self.lh_attribute(attributeName: NSKernAttributeName, index: index)
        return kern as? NSNumber
    }

    ///7 删除线
    func lh_strikethroughStyle(at index: Int) -> NSUnderlineStyle {
        return NSUnderlineStyle.styleNone
    }

    ///8 删除线颜色
    func lh_strikethroughColor(at index: Int) -> UIColor? {
        let color = self.lh_attribute(attributeName: NSStrikethroughColorAttributeName, index: index)
        return color as? UIColor
    }

    ///9 下滑线
    func lh_underlineStyle(at index: Int) -> NSUnderlineStyle {
        return NSUnderlineStyle.styleNone
    }

    //10 下划线颜色
    func lh_underlineColor(at index: Int) -> UIColor? {
        return self.lh_attribute(attributeName: NSUnderlineColorAttributeName, index: index) as? UIColor
    }
    //11 绘制线宽
    func lh_strokeWidth(at index: Int) -> NSNumber? {
        return self.lh_attribute(attributeName: NSStrokeWidthAttributeName, index: index) as? NSNumber
    }

    //* 12. NSStrokeColorAttributeName ->填充部分颜色，不是字体颜色，取值为 UIColor 对象
    func lh_strokeColor(at index: Int) -> UIColor? {
        return self.lh_attribute(attributeName: NSStrokeColorAttributeName, index: index) as? UIColor
    }

    ///13 文字阴影
    func lh_shadow(at index: Int) -> NSShadow? {
        let shadow = self.lh_attribute(attributeName: NSShadowAttributeName, index: index)
        return shadow as? NSShadow
    }

    //* 14. NSTextEffectAttributeName ->设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用
    func lh_textEffect(at index: Int) -> NSString? {
        return self.lh_attribute(attributeName: NSTextEffectAttributeName, index: index) as? NSString
    }
    //* 15. NSBaselineOffsetAttributeName ->设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
    func lh_baselineOffset(at index: Int) -> NSNumber? {
        return self.lh_attribute(attributeName: NSBaselineOffsetAttributeName, index: index) as? NSNumber
    }
    //* 16. NSObliquenessAttributeName ->设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
    func lh_obliqueness(at index: Int) -> NSNumber? {
        return self.lh_attribute(attributeName: NSObliquenessAttributeName, index: index) as? NSNumber
    }
    //* 17. NSExpansionAttributeName ->设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
    func lh_expansion(at index: Int) -> NSNumber? {
        return self.lh_attribute(attributeName: NSExpansionAttributeName, index: index) as? NSNumber
    }
    //* 18. NSWritingDirectionAttributeName ->设置文字书写方向，从左向右书写或者从右向左书写
    //* 19. NSVerticalGlyphFormAttributeName ->设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
    //* 20. NSLinkAttributeName ->设置链接属性，点击后调用浏览器打开指定URL地址
    func lh_link(at index: Int) -> NSURL? {
        return self.lh_attribute(attributeName: NSLinkAttributeName, index: index) as? NSURL
    }
    //* 21. NSAttachmentAttributeName ->设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
    func lh_attachment(at index: Int) -> NSTextAttachment? {
        return self.lh_attribute(attributeName: NSAttachmentAttributeName, index: index) as? NSTextAttachment
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
    ///1 设置字体
    func setLh_font(font: UIFont?, range: NSRange) -> Void {

        self.lh_setAttribute(attributeName: NSFontAttributeName, value: font, range: range)
    }

    //2 短落属性
    func setLh_paragraphStyle(style: NSParagraphStyle?, range: NSRange) -> Void {
        self.lh_setAttribute(attributeName: NSParagraphStyleAttributeName, value: style, range: range)
    }

    ///3 设置字体颜色
    func setLh_color(color: UIColor?, range: NSRange) -> Void {
        self.lh_setAttribute(attributeName: NSForegroundColorAttributeName as String, value: color, range: range)
    }

    ///4 背景颜色
    func setLh_backGroundColor(color: UIColor?, range: NSRange) {
        self.lh_setAttribute(attributeName: NSBackgroundColorAttributeName, value: color, range: range)
    }

    ///5 连体
    func setLh_ligature(ligature: NSNumber?, range: NSRange) {
        self.lh_setAttribute(attributeName: NSLigatureAttributeName, value: ligature, range: range)
    }
    ///6 设置字距
    func setLh_kern(kern: NSNumber?, range: NSRange) -> Void {
        self.lh_setAttribute(attributeName: NSKernAttributeName as String, value: kern, range: range)
    }

    ///7 删除线
    func setLh_strikethroughStyle(style: NSUnderlineStyle?, range: NSRange) {
        self.lh_setAttribute(attributeName: NSStrikethroughStyleAttributeName, value: style?.hashValue, range: range)
    }

    ///8 删除先颜色
    func setLh_strikethroughColor(color: UIColor?, range: NSRange) {
        self.lh_setAttribute(attributeName: NSStrikethroughColorAttributeName, value: color, range: range)
    }

    //9 下划线
    func setLh_underlineStyle(style: NSUnderlineStyle, range: NSRange) {
        self.lh_setAttribute(attributeName: NSUnderlineStyleAttributeName, value: (style.hashValue), range: range)
    }

    //10 下划线颜色
    func setLh_underlineColor(color: UIColor?, range: NSRange) {
        self.lh_setAttribute(attributeName: NSUnderlineColorAttributeName, value: color, range: range)
    }

    //11 绘制线宽
    func setLh_strokeWidth(width: NSNumber?, range: NSRange) {
        self.lh_setAttribute(attributeName: NSStrokeWidthAttributeName, value: width, range: range)
    }

    //* 12. NSStrokeColorAttributeName ->填充部分颜色，不是字体颜色，取值为 UIColor 对象
    func setLh_strokeColor(color: UIColor?, range: NSRange) {
        self.lh_setAttribute(attributeName: NSStrokeColorAttributeName, value: color, range: range)
    }

    ///13 文字阴影
    func setLh_shadow(shadow: NSShadow?, range: NSRange) {
        self.lh_setAttribute(attributeName: NSShadowAttributeName, value: shadow, range: range)
    }

    //* 14. NSTextEffectAttributeName ->设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用
    func setLh_textEffect(textEffect: NSString?, range: NSRange) {
        self.lh_setAttribute(attributeName: NSTextEffectAttributeName, value: textEffect, range: range)
    }

    //* 15. NSBaselineOffsetAttributeName ->设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
    func setLh_baselineOffset(baselineOffset: NSNumber?, range: NSRange) {
        self.lh_setAttribute(attributeName: NSBaselineOffsetAttributeName, value: baselineOffset, range: range)
    }

    //* 16. NSObliquenessAttributeName ->设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
    func setLh_obliqueness(obliqueness: NSNumber?, range: NSRange) {
        self.lh_setAttribute(attributeName: NSObliquenessAttributeName, value: obliqueness, range: range)
    }

    //* 17. NSExpansionAttributeName ->设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
    func setLh_expansion(expansion: NSNumber?, range: NSRange) {
        self.lh_setAttribute(attributeName: NSExpansionAttributeName, value: expansion, range: range)
    }

    //* 18. NSWritingDirectionAttributeName ->设置文字书写方向，从左向右书写或者从右向左书写
    //* 19. NSVerticalGlyphFormAttributeName ->设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本

    //* 20. NSLinkAttributeName ->设置链接属性，点击后调用浏览器打开指定URL地址
    func setLh_link(link: NSURL?, range: NSRange) {
        self.lh_setAttribute(attributeName: NSLinkAttributeName, value: link, range: range)
    }

    //* 21. NSAttachmentAttributeName ->设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
    func setLh_attachment(attachment: NSTextAttachment?, range: NSRange) {
        self.lh_setAttribute(attributeName: NSAttachmentAttributeName, value: attachment, range: range)
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

//MARK: 段落样式
extension NSMutableAttributedString {
    var lh_lineSpacing: CGFloat {
        get {
           return self.lh_getParagraphStyle().lineSpacing
        }
        set {
            let paragraphStyle = self.lh_getParagraphStyle();
            paragraphStyle.lineSpacing = newValue
            self.lh_paragraphStyle = paragraphStyle
        }
    }

    var lh_paragraphSpacing: CGFloat {
        get {
            return self.lh_getParagraphStyle().paragraphSpacing
        }
        set {
            let paragraphStyle = self.lh_getParagraphStyle();
            paragraphStyle.paragraphSpacing = newValue
            self.lh_paragraphStyle = paragraphStyle
        }
    }

    var lh_alignment: NSTextAlignment {
        get {
            return self.lh_getParagraphStyle().alignment
        }
        set {
            let paragraphStyle = self.lh_getParagraphStyle();
            paragraphStyle.alignment = newValue
            self.lh_paragraphStyle = paragraphStyle
        }
    }

    var lh_firstLineHeadIndent: CGFloat {
        get {
            return self.lh_getParagraphStyle().firstLineHeadIndent
        }
        set {
            let paragraphStyle = self.lh_getParagraphStyle();
            paragraphStyle.firstLineHeadIndent = newValue
            self.lh_paragraphStyle = paragraphStyle
        }
    }

    var lh_headIndent: CGFloat {
        get {
            return self.lh_getParagraphStyle().headIndent
        }
        set {
            let paragraphStyle = self.lh_getParagraphStyle();
            paragraphStyle.headIndent = newValue
            self.lh_paragraphStyle = paragraphStyle
        }
    }

    var lh_tailIndent: CGFloat {
        get {
            return self.lh_getParagraphStyle().tailIndent
        }
        set {
            let paragraphStyle = self.lh_getParagraphStyle();
            paragraphStyle.tailIndent = newValue
            self.lh_paragraphStyle = paragraphStyle
        }
    }

    var lh_lineBreakMode: NSLineBreakMode {
        get {
            return self.lh_getParagraphStyle().lineBreakMode
        }
        set {
            let paragraphStyle = self.lh_getParagraphStyle();
            paragraphStyle.lineBreakMode = newValue
            self.lh_paragraphStyle = paragraphStyle
        }
    }

    var lh_minimumLineHeight: CGFloat {
        get {
            return self.lh_getParagraphStyle().minimumLineHeight
        }
        set {
            let paragraphStyle = self.lh_getParagraphStyle();
            paragraphStyle.minimumLineHeight = newValue
            self.lh_paragraphStyle = paragraphStyle
        }
    }

    var lh_maximumLineHeight: CGFloat {
        get {
            return self.lh_getParagraphStyle().maximumLineHeight
        }
        set {
            let paragraphStyle = self.lh_getParagraphStyle();
            paragraphStyle.maximumLineHeight = newValue
            self.lh_paragraphStyle = paragraphStyle
        }
    }

    var lh_baseWritingDirection: NSWritingDirection {
        get {
            return self.lh_getParagraphStyle().baseWritingDirection
        }
        set {
            let paragraphStyle = self.lh_getParagraphStyle();
            paragraphStyle.baseWritingDirection = newValue
            self.lh_paragraphStyle = paragraphStyle
        }
    }

    var lh_lineHeightMultiple: CGFloat {
        get {
            return self.lh_getParagraphStyle().lineHeightMultiple
        }
        set {
            let paragraphStyle = self.lh_getParagraphStyle();
            paragraphStyle.lineHeightMultiple = newValue
            self.lh_paragraphStyle = paragraphStyle
        }
    }

    var lh_paragraphSpacingBefore: CGFloat {
        get {
            return self.lh_getParagraphStyle().paragraphSpacingBefore
        }
        set {
            let paragraphStyle = self.lh_getParagraphStyle();
            paragraphStyle.paragraphSpacingBefore = newValue
            self.lh_paragraphStyle = paragraphStyle
        }
    }

    var lh_hyphenationFactor: Float {
        get {
            return self.lh_getParagraphStyle().hyphenationFactor
        }
        set {
            let paragraphStyle = self.lh_getParagraphStyle();
            paragraphStyle.hyphenationFactor = newValue
            self.lh_paragraphStyle = paragraphStyle
        }
    }


    func lh_getParagraphStyle() -> NSMutableParagraphStyle {
        var paragraphStyle = NSMutableParagraphStyle();
        if let _ = self.lh_paragraphStyle {
            paragraphStyle = self.lh_paragraphStyle?.mutableCopy() as! NSMutableParagraphStyle
        }
        return paragraphStyle
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
        self.append(attribute)

    }

    func attribute(image: UIImage?, frame: CGRect) -> NSAttributedString {

        var objectReplacementChar:unichar           = 0xFFFC;
        let objectReplacementString = NSString.init(characters: &objectReplacementChar, length: 1)
        let att = NSMutableAttributedString.init(string: objectReplacementString as String)

        let ac = LHTextAttachment.attchment(content: image!)

        let delegate = getRunDelegate(attachment: ac, font: UIFont.systemFont(ofSize: 11))
         att.addAttribute(kCTRunDelegateAttributeName as String, value: delegate, range: NSRange.init(location: 0, length: 1))
        return att

        let attachment = NSTextAttachment.init()
        attachment.image = image
        attachment.bounds = frame
        let attributed = NSAttributedString.init(attachment: attachment)

        let matt = NSMutableAttributedString.init(attributedString: attributed)
        matt.lh_font = UIFont.systemFont(ofSize: 1)
        return matt
    }

}

public let  LHTextAttachmentAttributeName = "LHTextAttachmentAttributeName"

func getRunDelegate(attachment: LHTextAttachment, font: UIFont) -> CTRunDelegate {
    var cbs = CTRunDelegateCallbacks(version: kCTRunDelegateCurrentVersion, dealloc: { (refCon) -> Void in

    }, getAscent: { (refCon) -> CGFloat in
        let a = refCon.assumingMemoryBound(to: LHTextAttachment.self)
        let r = a.pointee
        if r.content.isKind(of: UIImage.classForCoder()){
            let image = r.content as! UIImage
            print(image)
           // return image.size.height
        }
        return 50
    }, getDescent: { (refCon) -> CGFloat in

        return 0
    },getWidth: { (refCon) -> CGFloat in

        return 30 
    })

    let a = UnsafeMutableRawPointer.allocate(bytes: 0, alignedTo: 0)
    a.initializeMemory(as: LHTextAttachment.self, to: attachment)
    return CTRunDelegateCreate(&cbs, a)!
}


