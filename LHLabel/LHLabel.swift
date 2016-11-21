//
//  LHLabel.swift
//  LHLabel
//
//  Created by luhai on 16/11/12.
//  Copyright © 2016年 luhai. All rights reserved.
//

import UIKit

fileprivate let kLHTextRunAttributedName = "kLHTextRunAttributedName"

typealias ElementResult = (range: NSRange, index: Int, value:Any)

class LHLabel: UILabel {

    var textInsets = UIEdgeInsets() //文字范围


    fileprivate var textStorage = NSTextStorage()
    fileprivate var layoutManager = NSLayoutManager()
    fileprivate var textContainer = NSTextContainer()


    private var heightCorrection: CGFloat = 0
    private var selectedRange = NSRange()

    override var text: String?{
        didSet{
            var attribute = NSAttributedString()
            if text != nil {
                attribute = NSAttributedString.init(string: text!)
            }
            attributedText = attribute
            updateTextStorage()
            setNeedsLayout()
        }
    }


    override var attributedText: NSAttributedString?{
        didSet{
            updateTextStorage()
            setNeedsLayout()
        }
    }

    override var numberOfLines: Int{
        didSet{
            textContainer.maximumNumberOfLines = numberOfLines
            setNeedsLayout()
        }
    }

    override var lineBreakMode: NSLineBreakMode {
        didSet {
            textContainer.lineBreakMode = lineBreakMode
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }


    required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }

    ///初始化属性
    private func setupLabel(){
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        isUserInteractionEnabled = true
        let bezir = UIBezierPath.init(roundedRect: CGRect.init(x: 60, y: 38, width: 30, height: 30), cornerRadius: 15)
        textContainer.exclusionPaths = [bezir]
    }

    fileprivate func updateTextStorage(parseText: Bool = true) {

        // clean up previous active elements
        guard let attributedText = attributedText, attributedText.length > 0 else {

            textStorage.setAttributedString(NSAttributedString())
            setNeedsDisplay()
            return
        }

        if parseText {

        }

        textStorage.setAttributedString(attributedText)
        setNeedsDisplay()
    }

    // MARK: - Auto layout

    open override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        return self.reviseSize(size: superSize)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSize = super.sizeThatFits(size)
        return self.reviseSize(size: superSize)
    }

    private func reviseSize(size: CGSize) -> CGSize {
        textContainer.size = CGSize(width: size.width-textInsets.left-textInsets.right, height: CGFloat.greatestFiniteMagnitude)

        var reviseSize = layoutManager.usedRect(for: textContainer).size

        reviseSize.width += textInsets.left + textInsets.right
        reviseSize.height += textInsets.top + textInsets.bottom

        return CGSize(width: ceil(reviseSize.width), height: ceil(reviseSize.height))
    }


    //d
    open override func drawText(in rect: CGRect) {
        let range = NSRange(location: 0, length: textStorage.length)
        let textRect = UIEdgeInsetsInsetRect(rect, textInsets)

        let newOrigin = self.textOrigin(inRect: textRect)

        for bezier in textContainer.exclusionPaths {
            var frame = bezier.bounds
            frame.origin.y += newOrigin.y
            frame.origin.x += textRect.origin.x
            let bezi = UIBezierPath.init(roundedRect: frame, cornerRadius: 15)
            bezi.fill(with: .colorBurn, alpha: 1)
        }

        layoutManager.drawBackground(forGlyphRange: range, at: newOrigin)
        layoutManager.drawGlyphs(forGlyphRange: range, at: newOrigin)
    }

    fileprivate func textOrigin(inRect rect: CGRect) -> CGPoint {
        textContainer.size = rect.size
        let usedRect = layoutManager.usedRect(for: textContainer)

        heightCorrection = (rect.height - usedRect.height)/2

        let glyphOriginY = heightCorrection > 0 ? rect.origin.y + heightCorrection : rect.origin.y
        return CGPoint(x: rect.origin.x, y: glyphOriginY)
    }

    fileprivate func touche(at location: CGPoint) -> ElementResult? {
        guard textStorage.length > 0 else {
            return nil
        }
        var correctLocation = location
        correctLocation.y -= 0
       // let boundingRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: 0, length: textStorage.length), in: textContainer)
        let textRect = UIEdgeInsetsInsetRect(bounds, textInsets)
        guard textRect.contains(correctLocation) else {
            return nil;
        }
        correctLocation.y -= heightCorrection
        correctLocation.x -= textRect.origin.x

        let index = layoutManager.glyphIndex(for: correctLocation, in: textContainer)
        //let origins = UnsafeMutablePointer<NSRange>.allocate(capacity: 0)
        var range = NSRange.init()
        let id =  textStorage.attribute(kLHTextRunAttributedName, at: index, effectiveRange: &range)
        if id != nil {
            return ElementResult(range: range, index: index, value: id!)
        }
        return nil
    }

    // MARK: - touch events
    func onTouch(_ touch: UITouch) -> Bool {
        let location = touch.location(in: self)
        var avoidSuperCall = false

        switch touch.phase {
        case .began, .moved:
            if let element = touche(at: location) {

                textStorage.setLh_color(color: UIColor.orange, range: selectedRange);

                textStorage.setLh_color(color: UIColor.blue, range: element.range)
                selectedRange = element.range

                avoidSuperCall = true
            }else{
                textStorage.setLh_color(color: UIColor.orange, range: selectedRange);

            }
        case .ended:
            if let _ = touche(at: location) {
           textStorage.setLh_color(color: UIColor.orange, range: selectedRange);

                avoidSuperCall = true
            }else{
           textStorage.setLh_color(color: UIColor.orange, range: selectedRange);

            }
            break
        case .cancelled:
            textStorage.setLh_color(color: UIColor.orange, range: selectedRange);
            break
        case .stationary:
            break
        }
        setNeedsDisplay()
        return avoidSuperCall
    }

    //MARK: - Handle UI Responder touches
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if onTouch(touch) { return }
        super.touchesBegan(touches, with: event)
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if onTouch(touch) { return }
        super.touchesMoved(touches, with: event)
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        _ = onTouch(touch)
        super.touchesCancelled(touches, with: event)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if onTouch(touch) { return }
        super.touchesEnded(touches, with: event)
    }

///添加
   public  func addAttribute(value: Any, range: NSRange) {
        textStorage.addAttribute(kLHTextRunAttributedName, value: value, range: range);
    }
    
//    func addAttribute(attributeName: String, value: Any, range: NSRange) {
//
//    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
