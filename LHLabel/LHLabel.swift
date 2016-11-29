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
typealias LHImagePath = (bezier: UIBezierPath, image: UIImage?, frame: CGRect)

protocol LHLabelDelegate : NSObjectProtocol{
    func didSelect(element: ElementResult)
}


open class LHLabel: UILabel {

    var textInsets = UIEdgeInsets() //文字范围

    weak var delegate: LHLabelDelegate?
    var selectedTextColor = UIColor.blue
    var selectedTextHighlightedColor = UIColor.orange


    fileprivate var textStorage = NSTextStorage()
    fileprivate var layoutManager = NSLayoutManager()
    fileprivate var textContainer = NSTextContainer()

    fileprivate var isNewRect = false

    private var imagePaths = Array<LHImagePath>()
    private var heightCorrection: CGFloat = 0
    private var selectedRange = NSRange()

    override open var text: String?{
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

    override open var attributedText: NSAttributedString?{
        didSet{
            updateTextStorage()
            setNeedsLayout()
        }
    }

    override open var numberOfLines: Int{
        didSet{
            textContainer.maximumNumberOfLines = numberOfLines
            setNeedsLayout()
        }
    }

    override open var lineBreakMode: NSLineBreakMode {
        didSet {
            textContainer.lineBreakMode = lineBreakMode
            setNeedsLayout()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }


    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }

    ///初始化属性
    private func setupLabel(){
        layoutManager.delegate = self
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        isUserInteractionEnabled = true

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
        if textStorage.length == 0 {
            return CGSize.init()
        }

        return CGSize(width: ceil(reviseSize.width), height: ceil(reviseSize.height))
    }


    //MARK:draw
    open override func drawText(in rect: CGRect) {
       
        let range = NSRange(location: 0, length: textStorage.length)
        let textRect = UIEdgeInsetsInsetRect(rect, textInsets)

        let newOrigin = self.textOrigin(inRect: textRect)

        for imagePath in imagePaths {
            if imagePath.image != nil {
                var frame = imagePath.frame
                frame.origin.y += newOrigin.y
                frame.origin.x += textRect.origin.x
                imagePath.image!.draw(in: frame)
            }

           // imagePath.bezier.fill()
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
   let rect =   layoutManager.boundingRect(forGlyphRange: range, in: textContainer)
            print(rect)
            let element = ElementResult(range: range, index: index, value: id!)
            return element
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

                textStorage.setLh_color(color: selectedTextColor, range: selectedRange);
                textStorage.setLh_color(color: selectedTextHighlightedColor, range: element.range)
                selectedRange = element.range

                avoidSuperCall = true
            }else{
                textStorage.setLh_color(color: selectedTextColor, range: selectedRange);

            }
        case .ended:
            if let element = touche(at: location) {
                //代理回调
                delegate?.didSelect(element: element)
                avoidSuperCall = true
            }
            textStorage.setLh_color(color: selectedTextColor, range: selectedRange);

            break
        case .cancelled:
            textStorage.setLh_color(color: selectedTextColor, range: selectedRange);
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


    //MARK: - 添加点击事件range
    public  func addValue(value: Any, range: NSRange) {
        textStorage.addAttribute(kLHTextRunAttributedName, value: value, range: range);
        textStorage.setLh_color(color: selectedTextColor, range: range)

        setNeedsDisplay()
    }

    public func urlset(){
        let urlPattern = "(^|[\\s.:;?\\-\\]<\\(])" + "((https?://|www\\.|pic\\.)[-\\w;/?:@&=+$\\|\\_.!~*\\|'()\\[\\]%#,☺]+[\\w/#](\\(\\))?)" + "(?=$|[\\s',\\|\\(\\).:;?\\-\\[\\]>\\)])"

        let regular =  try? NSRegularExpression(pattern: urlPattern, options: [.caseInsensitive])

        let ar = regular?.matches(in: textStorage.string, options: [], range: NSRange.init(location: 0, length: textStorage.string.characters.count))

        if ar == nil {
            return
        }
      let  results = ar! as [NSTextCheckingResult]
        for result in results{
            self.addValue(value: "ddf", range: result.range)
        }
    }

    //MARK: - 添加避让路径
    func addBeziers(beziers:[LHImagePath]) {
        var arr = Array<UIBezierPath>.init()
        for bezier in beziers {
            arr.append(bezier.bezier)
        }

        textContainer.exclusionPaths = arr
        imagePaths = beziers

        setNeedsDisplay()
    }

    func add(image: UIImage?, bezierRect: CGRect, insets: UIEdgeInsets) {

        let bezier = UIBezierPath.init(rect: bezierRect)

        let frame = UIEdgeInsetsInsetRect(bezierRect, insets)
        let path = LHImagePath(bezier: bezier,image: image, frame: frame)

        imagePaths.append(path)
        textContainer.exclusionPaths.append(bezier)

        setNeedsDisplay()
    }
}


extension LHLabel : NSLayoutManagerDelegate {
 
    public func layoutManager(_ layoutManager: NSLayoutManager, shouldSetLineFragmentRect lineFragmentRect: UnsafeMutablePointer<CGRect>, lineFragmentUsedRect: UnsafeMutablePointer<CGRect>, baselineOffset: UnsafeMutablePointer<CGFloat>, in textContainer: NSTextContainer, forGlyphRange glyphRange: NSRange) -> Bool {

        let rect: CGRect = lineFragmentUsedRect[0]
        let font = layoutManager.textStorage?.lh_font(index: glyphRange.location)
        if font == nil {
            return false
        }
        if font!.pointSize > rect.width {
            print(font!.pointSize)
            isNewRect = true
        }
        return isNewRect
    }
}
