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
        label.text = "床前明月光床前明月光床前明月光床前明月光床前明月光床前明月光床前明月光床前明月光"
      //  label.textInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 10, right: 10)
       // label.attributedText = NSAttributedString.init(string: "sdfdfgdf\nfdgjgfidgjhoif")
        label.numberOfLines = 0
        label.lh_top = 122
        label.lh_left = 30
        label.lh_size = CGSize.init(width: 111, height: 111)
        label.sizeToFit()
        
    
        self.view.addSubview(label)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

