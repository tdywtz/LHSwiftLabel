
//
//  LHTextLine.swift
//  LHLabel
//
//  Created by bangong on 16/12/21.
//  Copyright © 2016年 luhai. All rights reserved.
//

import UIKit






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
    
}







class LHTextLine: NSObject {

    class func line(ctLine: CTLine, position: CGPoint, vertical: Bool) -> LHTextLine {
        let line = LHTextLine.init()
        line._ctLine = ctLine
        line._position = position
        line._vertical = vertical
        line.setting(line: ctLine)

        return line
    }
    

    private var _firstGlyphPos: CGFloat = 0
    private var _ctLine: CTLine?
    private var _vertical = false
    private var _bounds = CGRect.zero
    private var _range = NSRange()
    private var _position = CGPoint.zero
    private var _ascent: CGFloat = 0
    private var _descent: CGFloat = 0
    private var _leading: CGFloat = 0
    private var _lineWidth: CGFloat = 0
    private var _attachments = Array<LHTextAttachment>()
    private var _attachmentRanges = Array<NSRange>()
    private var _attachmentRects = Array<CGRect>()
    
    var row: Int = 0

    var ctLine: CTLine? {
        return _ctLine
    }

    var vertical: Bool {
        return _vertical
    }

    var bounds: CGRect {
        return _bounds
    }

    var range: NSRange {
        return _range
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

    var attachments: Array<LHTextAttachment> {
        return _attachments
    }

    var attachmentRanges: Array<NSRange> {
        return _attachmentRanges
    }

    var attachmentRects: Array<CGRect> {
        return _attachmentRects
    }

 
    func setting(line: CTLine) {
       let width = CTLineGetTypographicBounds(line, &_ascent, &_descent, &_leading)
        _lineWidth = CGFloat(width)

        let range = CTLineGetStringRange(line)
        _range = NSRange.init(location: range.location, length: range.length)

        let ctRuns = CTLineGetGlyphRuns(line)

        if CTLineGetGlyphCount(line) > 0 {
            let runRawPointer = CFArrayGetValueAtIndex(ctRuns, 0)
            let run = Unmanaged<AnyObject>.fromOpaque(runRawPointer!).takeUnretainedValue() as! CTRun
            var runPosition = CGPoint.zero
            CTRunGetPositions(run, CFRangeMake(0, 1), &runPosition)
            _firstGlyphPos = runPosition.x
        }
       reloadBounds()
    }
    
    
    func reloadBounds() {
        if vertical {
            _bounds = CGRect.init(x: _position.x - _descent, y: _position.y, width: _ascent + _descent, height: _lineWidth)
        }else {
            _bounds = CGRect.init(x: _position.x, y: _position.y - ascent, width: lineWidth, height: _ascent + _descent)
            _bounds.origin.x += _firstGlyphPos
        }
       
        
        let ctRuns = CTLineGetGlyphRuns(self.ctLine!)

        var attachments = Array<LHTextAttachment>()
        var attachmentRanges = Array<NSRange>()
        var attachmentRects = Array<CGRect>()

        for k in 0 ..< CFArrayGetCount(ctRuns) {
            let runRawPointer = CFArrayGetValueAtIndex(ctRuns, k)
            let run = Unmanaged<AnyObject>.fromOpaque(runRawPointer!).takeUnretainedValue() as! CTRun

            let glyphCount = CTRunGetGlyphCount(run)
            if glyphCount == 0 {
                continue
            }
    
            let attrs =  CTRunGetAttributes(run) as NSDictionary
            let attachment = attrs[LHTextAttachmentAttributeName] as? LHTextAttachment
           
            if attachment != nil {

                var runPosition = CGPoint.zero
                CTRunGetPositions(run, CFRangeMake(0, 1), &runPosition)
                var ascent: CGFloat = 0
                var descent: CGFloat = 0
                var leading: CGFloat = 0
                var runTypoBounds = CGRect()
                
                let width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading)
                
                if vertical {
                    runPosition.y = runPosition.x
                    runPosition.x = _position.y + runPosition.y
                    runTypoBounds = CGRect.init(x: _position.x + runPosition.x - descent, y: runPosition.y, width: ascent + descent, height: CGFloat(width))
                    
                }else {
                    runPosition.x += _position.x;
                    runPosition.y = _position.y - runPosition.y;
                    runTypoBounds = CGRect.init(x: runPosition.x, y: runPosition.y - ascent, width: CGFloat(width), height: ascent + descent)
                }
                let range =  CTRunGetStringRange(run)
                let runRange = NSRange.init(location: range.length, length: range.length)

                attachments.append(attachment!);
                attachmentRanges.append(runRange)
                attachmentRects.append(runTypoBounds)
            }
          
        }
        _attachments = attachments
        _attachmentRanges = attachmentRanges
        _attachmentRects = attachmentRects
    }

}
