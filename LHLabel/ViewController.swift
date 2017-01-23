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


        let mm = MMLabel.init(frame: CGRect.init(x: 100, y: 100, width: 200, height: 200))
        mm.backgroundColor = UIColor.init(colorLiteralRed: 0.1, green: 0.5, blue: 0.8, alpha: 0.8)
       // mm.insets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
     //   mm.verticalForm = true
        self.view.addSubview(mm)
       // mm.maximumNumberOfRows = 1;

//        let p = self.buffer(frame: CGRect.init(x: 20, y: 20, width: 30, height: 30))
//        mm.exclusionPaths = [p]
var text = "my Hart is go on 沧海月明珠有泪，蓝田日暖玉生烟，此情可待成追忆，只是当时已惘然，The designated initializer. If you subclass UIViewController, you must call the super implementation of this method, even if you aren't using a NIB.  (As a convenience, the default ini t method will do this for you,and specify nil for both of this methods arguments.) In the specified NIB, the File's Owner proxy should"
        text = "帝高阳之苗裔兮，朕皇考曰伯庸。摄提贞于孟陬兮，惟庚寅吾以降。皇览揆余初度兮，肇锡余以嘉名：名余曰正则兮，字余曰灵均。纷吾既有此内美兮，又重之以修能。扈江离与辟芷兮，纫秋兰以为佩。汨余若将不及兮，恐年岁之不吾与。朝搴阰之木兰兮，夕揽洲之宿莽。日月忽其不淹兮，春与秋其代序。唯草木之零落兮，恐美人之迟暮。不抚壮而弃秽兮，何不改乎此度？乘骐骥以驰骋兮，来吾道夫先路！昔三后之纯粹兮，固众芳之所在。杂申椒与菌桂兮，岂惟纫夫蕙茞！彼尧、舜之耿介兮，既遵道而得路。何桀纣之昌披兮，夫惟捷径以窘步。惟夫党人之偷乐兮，路幽昧以险隘。岂余身之殚殃兮，恐皇舆之败绩！忽奔走以先后兮，及前王之踵武。荃不查余之中情兮，反信谗而齌怒。余固知謇謇之为患兮，忍而不能舍也。指九天以为正兮，夫惟灵修之故也。曰黄昏以为期兮，羌中道而改路！初既与余成言兮，后悔遁而有他。余既不难夫离别兮，伤灵修之数化。余既滋兰之九畹兮，又树蕙之百亩。畦留夷与揭车兮，杂杜衡与芳芷。冀枝叶之峻茂兮，愿俟时乎吾将刈。虽萎绝其亦何伤兮，哀众芳之芜秽。众皆竞进以贪婪兮，凭不厌乎求索。羌内恕己以量人兮，各兴心而嫉妒。忽驰骛以追逐兮，非余心之所急。"
        let att = NSMutableAttributedString.init(string: text)
        att.lh_font = UIFont.systemFont(ofSize: 15)
        att.lh_color = UIColor.white
        att.lh_lineSpacing = 5
        att.lh_textDecoration = LHTextDecoration.decoration(style: .styleThick, width: 0.1, color: UIColor.blue)
       // att.insert(image: UIImage.init(named: "buffer"), frame: CGRect.init(x: 0, y: 0, width: 60, height: 30), index: 3)


        let hi = LHTextHighlight()
        hi.tapAction = { (a,b,c) in
           
        }
        att.lh_set(textHighlight: hi, range: NSRange.init(location: 0, length: 5))
        mm.attributedText = att
      //  mm.sizeToFit()
 
        UIFont.asynchronouslySetFontName(UIFont.fontNameSTXingkai_SC_Bold()) { (name) in
            att.lh_setFont(font: UIFont.init(name: name!, size: 28), range: NSRange.init(location: 0, length: 6))
            mm.attributedText = att
          //  mm.sizeToFit()
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

