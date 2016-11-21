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
       
        let label = LHLabel.init()
        label.backgroundColor = UIColor.lightGray
        label.textColor = UIColor.red
        label.preferredMaxLayoutWidth = 100;
        self.view.addSubview(label)
       // label.text = "床前明月光床前明月光床前明月光床前明月光床前明月光床前明月光床前明月光床前明月光"
        
       // label.textInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 10, right: 10)
       // label.attributedText = NSAttributedString.init(string: "sdfdfgdf\nfdgjgfidgjhoif")
        label.numberOfLines = 0
        label.lh_top = 122
        label.lh_left = 30
        label.lh_size = CGSize.init(width: 100, height: 311)

        
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[label]", options: .alignAllTop, metrics: nil, views: ["label":label]))
//        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-100-[label]", options: .alignAllLeft, metrics: nil, views: ["label":label]))

        let mAtt = NSMutableAttributedString.init(string: "床前明月光床前明月光床前明月光床前明月光床前明月光床前明月光床前明月光床前明月光")
        mAtt.lh_font = UIFont.systemFont(ofSize: 18)
        mAtt.lh_color = UIColor.red



       // mAtt.insert(image: UIImage.init(named: "skt1.jpg"), frame: CGRect.init(x: 0, y: 0, width: 50, height: 50), index: 5)
        label.attributedText = mAtt
    label.addAttribute(value: ["df","dsfadsfgadsf"], range: NSRange.init(location: 5, length: 4))
      //  label.sizeToFit()


        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

