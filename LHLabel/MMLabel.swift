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
           resetting()
            setNeedsDisplay()
        }
    }

    var preferredMaxLayoutWidth: CGFloat = 0 {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    func resetting() {
        textLayout.update(attributedText: attributedText)
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        textLayout = LHTextLayout.layout(size: UIScreen.main.bounds.size, text: attributedText)
    }

   required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Auto layout
    open override var intrinsicContentSize: CGSize {

        return textLayout.textBoundingRect.size
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        print("ssss=\(self.frame)")
        return textLayout.textBoundingRect.size
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        textLayout.textContainer.size = self.lh_size
        print("\(self.frame)")
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        if context != nil {
            var point = CGPoint.zero
            if textLayout.textBoundingRect.height < rect.height {
                point.y = (rect.height - textLayout.textBoundingRect.height)/2
            }
          textLayout.draw(context: context!, rect: rect, point: point, targetView: self, targetLayer: self.layer)
        }
    }

}
