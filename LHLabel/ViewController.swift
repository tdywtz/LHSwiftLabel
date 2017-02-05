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


        let mm = MMLabel.init(frame: CGRect.init(x: 10, y: 100, width: 200, height: 400))
        mm.backgroundColor = UIColor.init(colorLiteralRed: 0.1, green: 0.5, blue: 0.8, alpha: 0.8)
<<<<<<< HEAD
      //  mm.insets = UIEdgeInsets.init(top: 10, left: 10, bottom: 30, right: 40)
        mm.verticalForm = true
          // mm.exclusionPaths = [self.buffer(frame: CGRect.init(x: 60, y: 50, width: 40, height: 40))]
=======
       // mm.insets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
      //  mm.verticalForm = true
        //   mm.exclusionPaths = [self.buffer(frame: CGRect.init(x: 20, y: 20, width: 40, height: 40))]
>>>>>>> edee20476cc1548de5aab47cf0f2dec4783092fb
        self.view.addSubview(mm)
       //mm.maximumNumberOfRows = 2;
      //  let p = self.buffer(frame: CGRect.init(x: 20, y: 20, width: 30, height: 30))
      //  mm.exclusionPaths = [p]
var text = "my Hart is go on 沧海月明珠有泪，蓝田日暖玉生烟，此情可待成追忆，只是当时已惘然，The designated initializer. If you subclass UIViewController, you must call the super implementation of this method, even if you aren't using a NIB.  (As a convenience, the default ini t method will do this for you,and specify nil for both of this methods arguments.) In the specified NIB, the File's Owner proxy should"
       // text = "帝高阳之苗裔兮，朕皇考曰伯庸。摄提贞于孟陬兮，惟庚寅吾以降。皇览揆余初度兮，肇锡余以嘉名：名余曰正则兮，字余曰灵均。纷吾既有此内美兮，又重之以修能。扈江离与辟芷兮，纫秋兰以为佩。汨余若将不及兮，恐年岁之不吾与。朝搴阰之木兰兮，夕揽洲之宿莽。日月忽其不淹兮，春与秋其代序。唯草木之零落兮，恐美人之迟暮。不抚壮而弃秽兮，何不改乎此度？乘骐骥以驰骋兮，来吾道夫先路！昔三后之纯粹兮，固众芳之所在。杂申椒与菌桂兮，岂惟纫夫蕙茞！彼尧、舜之耿介兮，既遵道而得路。何桀纣之昌披兮，夫惟捷径以窘步。惟夫党人之偷乐兮，"
        let att = NSMutableAttributedString.init(string: text)
        att.lh_font = UIFont.systemFont(ofSize: 15)
        att.lh_color = UIColor.white
        att.lh_lineSpacing = 5
<<<<<<< HEAD
        att.lh_textDecoration = LHTextDecoration.decoration(style: .styleDouble, width: 0.2, color: UIColor.red)
=======
        att.lh_textDecoration = LHTextDecoration.init()
>>>>>>> edee20476cc1548de5aab47cf0f2dec4783092fb
        // att.insert(image: UIImage.init(named: "buffer"), frame: CGRect.init(x: 0, y: 0, width: 60, height: 30), index: 3)


        let hi = LHTextHighlight()
        hi.tapAction = { (a,b,c) in
         print(a)
        }
        att.lh_set(textHighlight: hi, range: NSRange.init(location: 0, length: 5))
        mm.attributedText = att
//        mm.sizeToFit()
 
        UIFont.asynchronouslySetFontName(UIFont.fontNameSTXingkai_SC_Bold()) { (name) in
            att.lh_font = UIFont.init(name: name!, size: 17)
            mm.attributedText = att
           // mm.sizeToFit()
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

