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
        var text = "床前明月光床前明月光床前明月光床前明月光床前明月光床前明月光床前明月光床前"

        let mAtt = NSMutableAttributedString.init(string: text)
        mAtt.lh_font = UIFont.systemFont(ofSize: 18)
        mAtt.lh_color = UIColor.red
       // mAtt.lh_lineSpacing = 10
       // mAtt.insert(image: UIImage.init(named: "skt1.jpg"), frame: CGRect.init(x: 0, y: 0, width: 50, height: 50), index: 5)
        label.attributedText = mAtt
        let url = URL.init(string: "https://www.baidu.com")
        label.addValue(value: url!, range: NSRange.init(location: 5, length: 4))


        var arr = Array<LHImagePath>.init()
        let path = UIBezierPath.init(roundedRect: CGRect.init(x: 40.5, y: 50, width: 70, height: 70), cornerRadius: 0)
        let image = UIImage.init(named:"buffer")

        let be = LHImagePath(bezier: self.buffer(), image: image!, frame: CGRect.init(x: 40.5, y: 50, width: 70, height: 70))
        arr.append(be)
        label.addBeziers(beziers: arr)


           label.sizeToFit()

// Do any additional setup after loading the view, typically from a nib.
    }

    func buffer() -> UIBezierPath {
        let bezier = UIBezierPath.init()
        bezier.move(to: CGPoint.init(x: 30, y: 30))
        bezier.addQuadCurve(to: CGPoint.init(x: 60, y: 90), controlPoint: CGPoint.init(x: 30, y: 60))
        bezier.addQuadCurve(to: CGPoint.init(x: 90, y: 30), controlPoint: CGPoint.init(x: 90, y: 60))
        bezier.addQuadCurve(to: CGPoint.init(x: 60, y: 60), controlPoint: CGPoint.init(x: 90, y: 20))
        bezier.addQuadCurve(to: CGPoint.init(x: 30, y: 30), controlPoint: CGPoint.init(x: 30, y: 20))
        return bezier
    }

    func didSelect(element: ElementResult) {

        UIApplication.shared.open(element.value as! URL, options: [:], completionHandler: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

