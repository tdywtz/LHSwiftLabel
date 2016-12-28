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

    var attributedText = NSAttributedString() {
        didSet {
            
            innerText = attributedText.mutableCopy() as! NSMutableAttributedString
            textLayout.update(attributedText: attributedText)
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
            textLayout.textContainer.verticalForm = verticalForm
        }
    }

    var maximumNumberOfRows: Int = 0 {
        didSet {
            textLayout.textContainer.maximumNumberOfRows = maximumNumberOfRows
        }
    }

    var exclusionPaths: [UIBezierPath] = [] {
        didSet {
            textLayout.textContainer.exclusionPaths = exclusionPaths
        }
    }

    var insets = UIEdgeInsets() {
        didSet {
            textLayout.textContainer.insets = insets
        }
    }


    private let maxLayoutHeight: CGFloat = 1000000
    private var innerText = NSMutableAttributedString()


    override init(frame: CGRect) {
        super.init(frame: frame)
        textLayout = LHTextLayout.layout(size: UIScreen.main.bounds.size, text: attributedText)
    }

   required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Auto layout
    open override var intrinsicContentSize: CGSize {
        if verticalForm {
          textLayout.textContainer.size = CGSize.init(width: maxLayoutHeight, height: preferredMaxLayoutWidth)
        }else {
            textLayout.textContainer.size = CGSize.init(width: preferredMaxLayoutWidth, height: maxLayoutHeight)
        }

        textLayout.updateLayout(container: textLayout.textContainer);
        return textLayout.bounds.size
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        if verticalForm {
             textLayout.textContainer.size = CGSize.init(width: maxLayoutHeight, height:size.height)
        }else {
             textLayout.textContainer.size = CGSize.init(width: size.width, height:maxLayoutHeight)
        }
        textLayout.updateLayout(container: textLayout.textContainer);
        return textLayout.bounds.size
    }

//    open override func layoutSubviews() {
//       // super.layoutSubviews()
//        if textLayout.bounds.size.equalTo(self.lh_size) {
//            return
//        }
//        textLayout.textContainer.size = self.lh_size
//        textLayout.updateLayout(container: textLayout.textContainer)
//        
//    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        if context != nil {
            var point = CGPoint.zero
            if textLayout.bounds.height < rect.height {
                point.y = (rect.height - textLayout.bounds.height)/2
            }
          textLayout.draw(context: context!, rect: rect, point: point, targetView: self, targetLayer: self.layer)
        }
    }

    // MARK: - touch events
    func onTouch(_ touch: UITouch) -> Bool {
        let location = touch.location(in: self)
        var avoidSuperCall = false

        switch touch.phase {
        case .began, .moved:
            if let element = touche(at: location) {
                let matt = innerText.mutableCopy() as! NSMutableAttributedString
                matt.setLh_color(color: UIColor.blue, range: element.range)
                textLayout.update(attributedText: matt)
                avoidSuperCall = true
            }else{
                let att = innerText.copy() as! NSAttributedString
                textLayout.update(attributedText: att)

            }
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
            textLayout.update(attributedText: att)
            break
        case .cancelled:
            let att = innerText.copy() as! NSAttributedString
            textLayout.update(attributedText: att)
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
