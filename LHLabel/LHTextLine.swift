
//
//  LHTextLine.swift
//  LHLabel
//
//  Created by bangong on 16/12/21.
//  Copyright © 2016年 luhai. All rights reserved.
//

import UIKit

class LHTextLine: NSObject {

    class func line(ctLine: CTLine, position: CGPoint, vertical: Bool) -> LHTextLine {
        let line = LHTextLine.init()
        line._ctLine = ctLine
        line._position = position
        line._vertical = vertical
        line.setting(line: ctLine)
        return line
    }


    private var _ctLine: CTLine?
    private var _vertical = false
    private var _bounds = CGRect.zero

    private var _position = CGPoint.zero
    private var _ascent: CGFloat = 0
    private var _descent: CGFloat = 0
    private var _leading: CGFloat = 0
    private var _lineWidth: CGFloat = 0

    var ctLine: CTLine? {
        return _ctLine
    }

    var vertical: Bool {
        return _vertical
    }

    var bounds: CGRect {
        return _bounds
    }

    var position: CGPoint {
        return _position
    }

    var ascent: CGFloat {
        return _ascent
    }

    var descent: CGFloat {
        return _descent
    }

    var leading: CGFloat {
        return _leading
    }

    var lineWidth: CGFloat {
        return _lineWidth
    }
 
    func setting(line: CTLine) {
       let width = CTLineGetTypographicBounds(line, &_ascent, &_descent, &_leading)
        _lineWidth = CGFloat(width)

        let ctRuns = CTLineGetGlyphRuns(line)
        if  CFArrayGetCount(ctRuns) == 0 { continue }

        for k in 0 ..< CFArrayGetCount(ctRuns) {
            let runRawPointer = CFArrayGetValueAtIndex(ctRuns, k)
            let run = Unmanaged<AnyObject>.fromOpaque(runRawPointer!).takeUnretainedValue() as! CTRun
            let cfAtts =  CTRunGetAttributes(run)

            var runPosition = CGPoint.zero
            CTRunGetPositions(run, CFRangeMake(0, 1), &runPosition)

            var ascent: CGFloat = 0
            var descent: CGFloat = 0
            var leading: CGFloat = 0


            let width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading)

            attchmentRect.origin = runPosition
            attchmentRect.size.width = CGFloat(width)
            attchmentRect.size.height = ascent + descent

            let atts = cfAtts as NSDictionary
            let attchment = atts["NSAttachment"]
            if attchment != nil {
                attchmentRect.size = (attchment as! NSTextAttachment).bounds.size
                if ascent < attchmentRect.height {
                    rect.size.height = attchmentRect.height
                }
            }
        }
    }

}
