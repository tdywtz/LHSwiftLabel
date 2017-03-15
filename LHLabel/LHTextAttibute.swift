//
//  LHTextAttibute.swift
//  LHLabel
//
//  Created by bangong on 16/12/28.
//  Copyright © 2016年 luhai. All rights reserved.
//

import UIKit

func getRunDelegate(attachment: LHTextAttachment, font: UIFont) -> CTRunDelegate {

    var cbs = CTRunDelegateCallbacks(version: kCTRunDelegateCurrentVersion, dealloc: { (refCon) -> Void in
        refCon.deallocate(bytes: 0, alignedTo: 0)
    }, getAscent: { (refCon) -> CGFloat in

        let a = refCon.assumingMemoryBound(to: LHTextAttachment.self)
        let r = a.pointee
        return r.ascent

    }, getDescent: { (refCon) -> CGFloat in
        let a = refCon.assumingMemoryBound(to: LHTextAttachment.self)
        let r = a.pointee
        return r.descent
    },getWidth: { (refCon) -> CGFloat in
        let a = refCon.assumingMemoryBound(to: LHTextAttachment.self)
        let r = a.pointee
        return r.width
    })

    let one = UnsafeMutableRawPointer.allocate(bytes: 0, alignedTo: 0)
    one.initializeMemory(as: LHTextAttachment.self, to: attachment)
    //a.deallocate(bytes: 0, alignedTo: 0)
    return CTRunDelegateCreate(&cbs, one)!
}

typealias LHTextAction = (UIView, NSDictionary, NSRange)->Void

class LHTextAttachment: NSObject {
    class func attchment(content: AnyObject?) -> LHTextAttachment {
        let attchment = LHTextAttachment.init()
        attchment.content = content
        return attchment
    }

    var content: AnyObject?
    var contentMode: UIViewContentMode = .scaleToFill
    var contentInsets = UIEdgeInsets.zero
    var userInfo = NSDictionary()
    var bounds = CGRect()


    var ascent: CGFloat {

        return bounds.height - bounds.origin.y
    }

    var descent: CGFloat {
        return bounds.origin.y;
    }

    var width: CGFloat {
        return bounds.width

    }
    
    override func copy() -> Any {
        let one = LHTextAttachment()
        one.content = content
        one.contentMode = contentMode
        one.contentInsets = contentInsets
        one.userInfo = userInfo
        one.bounds = bounds
        return one
    }
    
}

//MARK: LHTextHighlight
class LHTextHighlight: NSObject {
    var tapAction: LHTextAction?
    var highlightColor = UIColor.red
    var textColor = UIColor.blue

}

class LHTextAttibute: NSObject {

}

class LHTextDecoration: NSObject {
    var style = LHTextUnderlineStyle.styleNone
    var width: CGFloat = 1
    var color = UIColor.red

    class func decoration(style: LHTextUnderlineStyle, width:CGFloat, color: UIColor) -> LHTextDecoration {
        let one = LHTextDecoration.init()
        one.style = style
        one.width = width
        one.color = color
        return one
    }

    override init() {
      super.init()
        style = .styleSingle
        width = 1
        color = .red
    }

    override func copy() -> Any {
        let one = LHTextDecoration.init()
        one.style = style
        one.width = width
        one.color = color
        return one
    }
}

enum LHTextUnderlineStyle {

    case styleNone

    case styleSingle

   // @available(iOS 7.0, *)
    case styleThick

   // @available(iOS 7.0, *)
    case styleDouble
}

