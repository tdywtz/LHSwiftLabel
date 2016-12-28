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


    let imageView =   UIImageView.init(image: UIImage.init(named: "lantian.jpg"))
        imageView.contentMode = .scaleAspectFit
        imageView.lh_size = CGSize.init(width: 375, height: 400)
        self.view.addSubview(imageView)

        let mm = MMLabel.init(frame: self.view.frame)
        mm.backgroundColor = UIColor.init(colorLiteralRed: 0.1, green: 0.5, blue: 0.8, alpha: 0.8)
       // mm.insets = UIEdgeInsets.init(top: 0, left: 0, bottom: 10, right: 0)
        mm.verticalForm = true
        self.view.addSubview(mm)



        mm.lh_left = 100;
        mm.lh_top = 100;
        mm.lh_size = CGSize.init(width: 200, height: 200)
//        let p = self.buffer(frame: CGRect.init(x: 20, y: 20, width: 30, height: 30))
//        mm.exclusionPaths = [p]

        let att = NSMutableAttributedString.init(string: "沧海月明珠有泪，蓝田日暖玉生烟，此情可待成追忆，只是当时已惘然")
        att.lh_font = UIFont.systemFont(ofSize: 15)
        att.lh_color = UIColor.white
      //  att.lh_lineSpacing = 10
        //att.lh_kern = (5)
        att.lh_color = UIColor.orange
       // att.insert(image: UIImage.init(named: "buffer"), frame: CGRect.init(x: 0, y: 0, width: 60, height: 30), index: 3)

        
//        let image = UIImage.init(named: "buffer")
//        let iv = UIImageView.init(image: image)
//        let attachment = LHTextAttachment.attchment(content: iv)
//        attachment.bounds = CGRect.init(x: 0, y: 0, width: 30, height: 30)
//        let text = NSMutableAttributedString.attribute(attchment: attachment)
//        att.insert(text, at: 5)
        
        let hi = LHTextHighlight()
        hi.tapAction = { (a,b,c) in
           print(a)
            print(c)
        }
        att.lh_set(textHighlight: hi, range: NSRange.init(location: 0, length: 2))
    
    
     
        UIFont.asynchronouslySetFontName(UIFont.fontNameSTXingkai_SC_Bold()) { (name) in
            att.lh_font = UIFont.init(name: name!, size: 18)
            mm.attributedText = att
            mm.sizeToFit()
          
        }
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

