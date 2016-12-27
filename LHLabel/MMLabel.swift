//
//  MMLabel.swift
//  LHLabel
//
//  Created by bangong on 16/12/14.
//  Copyright © 2016年 luhai. All rights reserved.
//

import UIKit

class MMLabel: UIView {

    var textLayout = LHTextLayout() {
        didSet {
            setNeedsDisplay()
        }
    }

    var attributedText = NSAttributedString() {
        didSet {
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


    fileprivate let maxLayoutWidth: CGFloat = 1000000

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
          textLayout.textContainer.size = CGSize.init(width: maxLayoutWidth, height: preferredMaxLayoutWidth)
        }else {
            textLayout.textContainer.size = CGSize.init(width: preferredMaxLayoutWidth, height: maxLayoutWidth)
        }

        textLayout.updateLayout(container: textLayout.textContainer);
        return textLayout.bounds.size
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        if verticalForm {
             textLayout.textContainer.size = CGSize.init(width: maxLayoutWidth, height:size.height)
        }else {
             textLayout.textContainer.size = CGSize.init(width: size.width, height:maxLayoutWidth)
        }
        textLayout.updateLayout(container: textLayout.textContainer);
        return textLayout.bounds.size
    }

    open override func layoutSubviews() {
       // super.layoutSubviews()
        if textLayout.bounds.size.equalTo(self.lh_size) {
            return
        }
        textLayout.textContainer.size = self.lh_size
        textLayout.updateLayout(container: textLayout.textContainer)
        setNeedsDisplay()
    }

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


                avoidSuperCall = true
            }else{
               // textStorage.setLh_color(color: selectedTextColor, range: selectedRange);

            }
        case .ended:
            if let element = touche(at: location) {
                //代理回调
                //delegate?.didSelect(element: element)
                avoidSuperCall = true
            }
            //textStorage.setLh_color(color: selectedTextColor, range: selectedRange);

            break
        case .cancelled:
           // textStorage.setLh_color(color: selectedTextColor, range: selectedRange);
            break
        case .stationary:
            break
        }
        setNeedsDisplay()
        return avoidSuperCall
    }

    fileprivate func touche(at location: CGPoint) -> ElementResult? {
     let a =   textLayout.glyphIndex(at: location)
        print(a)
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
