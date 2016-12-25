//
//  ViewController.swift
//  LHLabel
//
//  Created by luhai on 16/11/12.
//  Copyright © 2016年 luhai. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LHLabelDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mm = MMLabel.init(frame: self.view.frame)
        self.view.addSubview(mm)
        mm.backgroundColor = UIColor.gray
//        mm.lh_left = 100;
//        mm.lh_top = 100;
//        mm.lh_size = CGSize.init(width: 200, height: 200)
    
        let att = NSMutableAttributedString.init(string: "我自横刀")
        att.lh_font = UIFont.systemFont(ofSize: 16)
        att.lh_color = UIColor.white
       // att.lh_lineSpacing = 20
       // att.insert(image: UIImage.init(named: "buffer"), frame: CGRect.init(x: 0, y: -7, width: 60, height: 60), index: 2)
        let path = UIBezierPath.init(rect: CGRect.init(x: 30 , y: 30, width: 30, height: 30))
        let container = LHTextContainer.container(size: CGSize.init(width: 200, height: 200))
        container.maximumNumberOfRows = 0
        container.verticalForm = true
      //  container.exclusionPaths = [path]
        
        mm.textLayout = LHTextLayout.layout(container: container, text: att, range: NSRange.init(location: 0, length: att.length))
      // mm.sizeToFit()
      
        return
        
        
        let label = LHLabel.init()
        label.backgroundColor = UIColor.lightGray
        label.textColor = UIColor.red
        label.preferredMaxLayoutWidth = 100;
       label.delegate = self
        self.view.addSubview(label)
       // label.text = "床前明月光床前明月光床前明月光床前明月光床前明月光床前明月光床前明月光床前明月光"
        
       // label.textInsets = UIEdgeInsets.init(top: 5, left: 15, bottom: 30, right: 45)
       // label.attributedText = NSAttributedString.init(string: "sdfdfgdf\nfdgjgfidgjhoif")
        label.numberOfLines = 20
        label.lh_top = 50
        label.lh_left = 30
        label.lh_size = CGSize.init(width: 140, height: 311)


      //  label.translatesAutoresizingMaskIntoConstraints = false

//        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[label]", options: .alignAllTop, metrics: nil, views: ["label":label]))
//        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-100-[label]", options: .alignAllLeft, metrics: nil, views: ["label":label]))



        let text = "床前明月光床前明月光床前明月光床明月光床明月http://baidu.com 我"

        let mAtt = NSMutableAttributedString.init(string: text)
        mAtt.lh_color = UIColor.red
        mAtt.lh_lineSpacing = 100

        mAtt.lh_font = UIFont.systemFont(ofSize: 18)

        label.attributedText = mAtt

        let rect = CGRect.init(x: 30, y: 30, width: 150, height: 150)
        let a =  LHImagePath(bezier: self.buffer(frame: rect), image: UIImage.init(named: "buffer"), frame: rect)
      //  label.addBeziers(beziers: [a])
//        label.add(image: nil, bezierRect: CGRect.init(x: 10, y: 160, width: 40, height: 40), insets: UIEdgeInsets.zero)
//
//        let url = URL.init(string: "https://www.baidu.com")
//        label.addValue(value: url!, range: NSRange.init(location: 6, length: 4))
        label.urlset()
        label.sizeToFit()

     let bool =   RegexParser.emaileResult(text: "12365auto@sina.cn")




// Do any additional setup after loading the view, typically from a nib.
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

    func didSelect(element: ElementResult) {
print(element)
        //UIApplication.shared.open(element.value as! URL, options: [:], completionHandler: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

