//
//  MMLabel.swift
//  LHLabel
//
//  Created by bangong on 16/12/14.
//  Copyright © 2016年 luhai. All rights reserved.
//

import UIKit

typealias LHElementResult = (range: NSRange, index: Int, value:AnyObject)

class MMLabel: UIView {

    var textLayout = LHTextLayout() {
        didSet {
            setNeedsDisplay()
        }
    }
    var textContainer = LHTextContainer()


    var attributedText = NSAttributedString() {
        didSet {
            innerText = attributedText.mutableCopy() as! NSMutableAttributedString
            textContainer.size = frame.size
            textLayout = LHTextLayout.layout(container: textContainer, text: attributedText)
            setNeedsDisplay()
        }
    }

    var preferredMaxLayoutWidth: CGFloat = 320 {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    var verticalForm = false {
        didSet {
            textContainer.verticalForm = verticalForm
        }
    }

    var maximumNumberOfRows: Int = 0 {
        didSet {
            textContainer.maximumNumberOfRows = maximumNumberOfRows
        }
    }

    var exclusionPaths: [UIBezierPath] = [] {
        didSet {
            textContainer.exclusionPaths = exclusionPaths
        }
    }

    var insets = UIEdgeInsets() {
        didSet {
            textContainer.insets = insets
        }
    }


    private let maxLayoutHeight: CGFloat = 1000000
    private var innerText = NSMutableAttributedString()


    override init(frame: CGRect) {
        super.init(frame: frame)
        textContainer.size = frame.size
    }


    required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Auto layout
    open override var intrinsicContentSize: CGSize {
        if verticalForm {
            textContainer.size = CGSize.init(width: maxLayoutHeight, height: preferredMaxLayoutWidth)
        }else {
            textContainer.size = CGSize.init(width: preferredMaxLayoutWidth, height: maxLayoutHeight)
        }

        textLayout = LHTextLayout.layout(container: textContainer, text: innerText);
        return textLayout.bounds.size
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        if verticalForm {
             textContainer.size = CGSize.init(width: maxLayoutHeight, height:size.height)
        }else {
             textContainer.size = CGSize.init(width: size.width, height:maxLayoutHeight)
        }
        textLayout = LHTextLayout.layout(container: textContainer, text: innerText);
 
        return textLayout.bounds.size
    }

    override func draw(_ rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()
        if context != nil {
            let point = middlePoint(rect: rect)
            textLayout.draw(context: context!, rect: rect, point: point, targetView: self, targetLayer: self.layer)
        }
    }

    func middlePoint(rect: CGRect) -> CGPoint {
        var point = CGPoint.zero
        if textLayout.bounds.height < rect.height {
            if !self.verticalForm {
                 point.y = (rect.height - textLayout.bounds.height)/2
            }else {
                point.x = (rect.width - textLayout.bounds.width)/2
            }
        }
        return point
    }

    // MARK: - touch events
    func onTouch(_ touch: UITouch) -> Bool {
        var location = touch.location(in: self)
        location.y -= middlePoint(rect: bounds).y
        var avoidSuperCall = false

        switch touch.phase {
        case .began:
            if let element = touche(at: location) {
                let matt = innerText.mutableCopy() as! NSMutableAttributedString
                if element.value.isKind(of: LHTextHighlight.classForCoder()) {
                 matt.lh_setColor(color: (element.value as! LHTextHighlight).highlightColor, range: element.range)
                }

               textLayout = LHTextLayout.layout(container: textContainer, text: matt);
                avoidSuperCall = true
            }else{
                let att = innerText.copy() as! NSAttributedString
               textLayout = LHTextLayout.layout(container: textContainer, text: att);

            }
        case .moved:
            break
            
        case .ended:
            if let element = touche(at: location) {
                if element.value.isKind(of: LHTextHighlight.classForCoder()) {
                    let highlight = element.value as! LHTextHighlight
                    if highlight.tapAction != nil {
                        highlight.tapAction!(self,NSDictionary(),element.range)
                    }
                }
                avoidSuperCall = true
                
            }
            let att = innerText.copy() as! NSAttributedString
            textLayout = LHTextLayout.layout(container: textContainer, text: att);
            break
        case .cancelled:
            let att = innerText.copy() as! NSAttributedString
            textLayout = LHTextLayout.layout(container: textContainer, text: att);
            break
        case .stationary:
            break
        }
        setNeedsDisplay()
        return avoidSuperCall
    }

    fileprivate func touche(at location: CGPoint) -> LHElementResult? {
      let glyphIndex =   textLayout.glyphIndex(at: location)
        
        if glyphIndex != NSNotFound {
            var range = NSRange()
            let highlight = textLayout.attributedText.attribute(LHTextHighlightAttributeName, at: glyphIndex, effectiveRange: &range) as? NSObject

            if highlight != nil {
              
                let element = LHElementResult(range: range, index: glyphIndex, value: highlight!)
                return element

            }
        }
        return nil
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
}
