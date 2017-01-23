
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

    var index: Int = 0
    var row: Int = 0
    var runRanges = Array<Array<LHTextRotateRange>>()
    var lineAttributeText: NSAttributedString?


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
                    runTypoBounds = CGRect.init(x: _position.x - descent, y: runPosition.y, width: ascent + descent, height: CGFloat(width))

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

    func glyphIndex(at position: CGPoint) -> Int {
        if ctLine == nil {
            return NSNotFound
        }
        let ctRuns = CTLineGetGlyphRuns(ctLine!)
        var glyphIndex = NSNotFound

        for i in 0 ..< CFArrayGetCount(ctRuns){

            let runRawPointer = CFArrayGetValueAtIndex(ctRuns, i)
            let run = Unmanaged<AnyObject>.fromOpaque(runRawPointer!).takeUnretainedValue() as! CTRun
            let glyphCount = CTRunGetGlyphCount(run)
            if glyphCount <= 0 {
                continue
            }

            let glyphs = UnsafeMutablePointer<CGGlyph>.allocate(capacity: glyphCount)
            let glyphPositions = UnsafeMutablePointer<CGPoint>.allocate(capacity: glyphCount)

            CTRunGetGlyphs(run, CFRangeMake(0, 0), glyphs)
            CTRunGetPositions(run, CFRangeMake(0, 0), glyphPositions)

            let runStrIdx = UnsafeMutablePointer<CFIndex>.allocate(capacity: glyphCount + 1)

            CTRunGetStringIndices(run, CFRangeMake(0, 0), runStrIdx)
            let runStrRange = CTRunGetStringRange(run)
            runStrIdx[glyphCount] = runStrRange.location + runStrRange.length

            let glyphAdvances = UnsafeMutablePointer<CGSize>.allocate(capacity: glyphCount)
            CTRunGetAdvances(run, CFRangeMake(0, 0), glyphAdvances)

            var runPosition = CGPoint.zero
            CTRunGetPositions(run, CFRangeMake(0, 1), &runPosition)
            var ascent: CGFloat = 0
            var descent: CGFloat = 0
            var leading: CGFloat = 0
            let width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading)

            let attrs =  CTRunGetAttributes(run) as NSDictionary
            let attachment = attrs[LHTextAttachmentAttributeName] as? LHTextAttachment
            if attachment != nil {
                var runTypoBounds = CGRect.zero

                if vertical {
                    runPosition.y = runPosition.x
                    runPosition.x = _position.y + runPosition.y
                    runTypoBounds = CGRect.init(x: _position.x - descent, y: runPosition.y, width: ascent + descent, height: CGFloat(width))
                    runTypoBounds = runTypoBounds.standardized

                }else {
                    runPosition.x += _position.x;
                    runPosition.y = _position.y - runPosition.y;
                    runTypoBounds = CGRect.init(x: runPosition.x, y: runPosition.y - ascent, width: CGFloat(width), height: ascent + descent)
                }
                runTypoBounds = UIEdgeInsetsInsetRect(runTypoBounds, attachment!.contentInsets)
                if runTypoBounds.contains(position) {

                   glyphIndex = CTRunGetStringRange(run).location
                   break
                }
                continue
            }
         //else
            let range = CTRunGetStringRange(run)
            let runRanges = self.runRanges[i]
            for k in 0 ..<  range.length{

                var point = CGPoint.zero
                var size = CGSize.zero

                if vertical {

                    var CJK = false
                    for sRange in runRanges {

                        if NSLocationInRange(sRange.range.location + i, sRange.range) {
                             CJK = sRange.vertical
                            break
                        }
                    }
                         // CJK glyph, need rotated
                    if CJK {
                        let ofs = (ascent - descent) * 0.5
                        let w = glyphAdvances[k].width * 0.5
                        let x = self.position.x + glyphPositions[k].y - (descent)/2 + size.width
                        let y = -self.position.y  + size.height - glyphPositions[k].x - (ofs + w) + ascent - descent
                        point = CGPoint.init(x: x, y: -y)
                        size = CGSize.init(width: ascent + descent, height: glyphAdvances[i].width)
                    }else {
                       point.y = self.position.y - size.height + glyphPositions[k].x + descent - descent
                       point.x = self.position.x -  glyphPositions[k].y + size.width
                       size = CGSize.init(width: ascent + descent, height: glyphAdvances[k].width)
                    }
                }else {
                    point.x = self.position.x + glyphPositions[k].x
                    point.y = self.position.y  - ascent + descent
                    size = CGSize.init(width: glyphAdvances[i].width, height: ascent + descent)
                }

                let rect = CGRect.init(origin: point, size: size)

                if rect.contains(position) {
                    glyphIndex = range.location + k
                    break
                }
            }

            runStrIdx.deallocate(capacity: glyphCount + 1)
            glyphs.deallocate(capacity: glyphCount)
            glyphPositions.deallocate(capacity: glyphCount)
            glyphAdvances.deallocate(capacity: glyphCount)
        }
   
        return glyphIndex
    }
}
//MARK: LHTextRotateRange
class LHTextRotateRange: NSObject {
    var range = NSRange()
    var vertical = false
}
