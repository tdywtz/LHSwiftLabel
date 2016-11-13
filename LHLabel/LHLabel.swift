//
//  LHLabel.swift
//  LHLabel
//
//  Created by luhai on 16/11/12.
//  Copyright © 2016年 luhai. All rights reserved.
//

import UIKit

class LHLabel: UILabel {
    
    var textInsets = UIEdgeInsets()
    

   fileprivate var textStorage = NSTextStorage()
   fileprivate var layoutManager = NSLayoutManager()
   fileprivate var textContainer = NSTextContainer()
    
   override var text: String?{
        didSet{
            var attribute = NSAttributedString()
            if text != nil {
                attribute = NSAttributedString.init(string: text!)
            }
            attributedText = attribute
            updateTextStorage()
            self.setNeedsLayout()
        }
    }
    
   override var attributedText: NSAttributedString?{
        didSet{
         
            updateTextStorage()
            self.setNeedsLayout()
        }
    }
    
    override var numberOfLines: Int{
        didSet{
            textContainer.maximumNumberOfLines = numberOfLines
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
    
    func setupLabel(){
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 5
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
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
        textContainer.size = CGSize(width: superSize.width, height: CGFloat.greatestFiniteMagnitude)
        var size = layoutManager.usedRect(for: textContainer).size
//        size.width += textInsets.left + textInsets.right
//        size.height += textInsets.top + textInsets.bottom
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        let superSize = super.sizeThatFits(size)
    
        textContainer.size = CGSize(width: superSize.width-textInsets.left-textInsets.right, height: CGFloat.greatestFiniteMagnitude)
       
        var size = layoutManager.usedRect(for: textContainer).size
        print(size)
        size.width += textInsets.left + textInsets.right
        size.height += textInsets.top + textInsets.bottom
        print(size)
        
        return CGSize(width: ceil(size.width), height: ceil(size.height))

    }
//
   //d
    open override func drawText(in rect: CGRect) {
        let range = NSRange(location: 0, length: textStorage.length)
        let textRect = UIEdgeInsetsInsetRect(rect, textInsets)
        
       
        let newOrigin = textRect.origin
        
        for bezier in textContainer.exclusionPaths {
           
            bezier.fill(with: .colorBurn, alpha: 1)
        }
        layoutManager.drawBackground(forGlyphRange: range, at: newOrigin)
        layoutManager.drawGlyphs(forGlyphRange: range, at: newOrigin)
    }
    
    fileprivate func textOrigin(inRect rect: CGRect) -> CGPoint {
        let usedRect = layoutManager.usedRect(for: textContainer)
        let  heightCorrection = (rect.height - usedRect.height)/2
        let glyphOriginY = heightCorrection > 0 ? rect.origin.y + heightCorrection : rect.origin.y
        return CGPoint(x: rect.origin.x, y: glyphOriginY)
    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
