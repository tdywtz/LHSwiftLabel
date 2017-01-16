//
//  ViewController.swift
//  LHLabel
//
//  Created by luhai on 16/11/12.
//  Copyright © 2016年 luhai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        let mm = MMLabel.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        mm.backgroundColor = UIColor.init(colorLiteralRed: 0.1, green: 0.5, blue: 0.8, alpha: 0.8)
       // mm.insets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        mm.verticalForm = true
        self.view.addSubview(mm)


//        let p = self.buffer(frame: CGRect.init(x: 20, y: 20, width: 30, height: 30))
//        mm.exclusionPaths = [p]
//dfasdf沧海月明珠有泪，蓝田日暖玉生烟，此情可待成追忆，只是当时已惘
        let att = NSMutableAttributedString.init(string: "my Hart is go on 沧海月明珠有泪，蓝田日暖玉生烟，此情可待成追忆，只是当时已惘然 The designated initializer. If you subclass UIViewController, you must call the super implementation of this method, even if you aren't using a NIB.  (As a convenience, the default init method will do this for you,and specify nil for both of this methods arguments.) In the specified NIB, the File's Owner proxy should")
        att.lh_font = UIFont.systemFont(ofSize: 15)
        att.lh_color = UIColor.white
       // att.insert(image: UIImage.init(named: "buffer"), frame: CGRect.init(x: 0, y: 0, width: 60, height: 30), index: 3)


        let hi = LHTextHighlight()
        hi.tapAction = { (a,b,c) in
           
        }
        att.lh_set(textHighlight: hi, range: NSRange.init(location: 0, length: 5))
        mm.attributedText = att
     //   mm.sizeToFit()
 
//        UIFont.asynchronouslySetFontName(UIFont.fontNameSTXingkai_SC_Bold()) { (name) in
//            att.lh_font = UIFont.init(name: name!, size: 28)
//            mm.attributedText = att
//            mm.sizeToFit()
//        }
        return
    }

    func buffer(frame: CGRect) -> UIBezierPath {
        let bezier = UIBezierPath.init()
        bezier.move(to: frame.origin)
        bezier.addQuadCurve(to: CGPoint.init(x: frame.minX+frame.width/2, y: frame.maxY), controlPoint: CGPoint.init(x: frame.minX+frame.width/6, y: frame.maxY+frame.height/3))
        bezier.addQuadCurve(to: CGPoint.init(x: frame.maxX, y: frame.minY), controlPoint: CGPoint.init(x: frame.maxX-frame.width/6, y: frame.maxY+frame.height/3))
        bezier.addQuadCurve(to: CGPoint.init(x: frame.minX+frame.width/2, y: frame.minY+frame.height/4), controlPoint: CGPoint.init(x: frame.maxX, y: frame.minY-frame.height/3))
        bezier.addQuadCurve(to: frame.origin, controlPoint: CGPoint.init(x: frame.minX, y: frame.minY-frame.height/3))
        return bezier
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

