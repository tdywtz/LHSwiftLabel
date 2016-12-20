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

   
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: 1, y: -1)
       // context?.translateBy(x: 0, y: rect.height)
        textLayout.draw(context: context!, size: rect.size, point: CGPoint.init())
    }

}
