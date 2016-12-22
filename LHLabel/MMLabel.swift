//
//  MMLabel.swift
//  LHLabel
//
//  Created by bangong on 16/12/14.
//  Copyright © 2016年 luhai. All rights reserved.
//

import UIKit

class MMLabel: UIView {

    var textLayout = LHTextLayout(){
        didSet{
            setNeedsDisplay()

        }
    }
    
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }

   required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Auto layout
    open override var intrinsicContentSize: CGSize {

        return textLayout.textSize
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return textLayout.textSize
    }
   
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
     
        textLayout.draw(context: context!, rect: rect, point: CGPoint.init())

    }

}
