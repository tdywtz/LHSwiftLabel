//
//  LHTextLayout.swift
//  LHLabel
//
//  Created by luhai on 16/11/12.
//  Copyright © 2016年 luhai. All rights reserved.
//

import UIKit

class LHTextLayout: NSObject {

    public init(a: NSInteger) {

    }
}

class LHTextContainer: NSObject {

//    var attributedText: NSAttributedString?
//    var size: CGSize?
//    var textInsets:UIEdgeInsets?
//    var textSize: CGSize?
//    var frame: CTFrame?
//    var preferredMaxLayoutWidth:CGFloat?
//    var numberOfLines:UInt?
//
//
//    public init(attributedText:NSAttributedString) {
//        super.init()
//        self.attributedText = attributedText
//        self.preferredMaxLayoutWidth = 375
//        self.textSize = CGSize.init()
//        self.numberOfLines = 0
//        self.textInsets = UIEdgeInsets.init()
//        setting()
//    }
//
//
//
//    func setting() -> Void {
//        if self.attributedText == nil {
//            return
//        }
//
//        let framesetter = self.framesetter(attributed: self.attributedText!)
//
//        let width = self.preferredMaxLayoutWidth!-(self.textInsets?.left)!-(self.textInsets?.right)!
//        let maxSize = CGSize.init(width: width, height: CGFloat(MAXFLOAT))
//        let textSize = self.suggestFrameSize(attributed: self.attributedText!, size: maxSize, numberOfLines: self.numberOfLines!)
//
//        let rect = CGRect.init(origin: CGPoint.init(), size: textSize)
//        let range = CFRange.init(location: 0, length: CFIndex((self.attributedText?.length)!))
//        let frame = self.textFrame(framesetter: framesetter, rect: rect, range: range)
//
//
//        self.textSize = textSize
//        self.size = CGSize.init(width: (textInsets?.left)!+(textInsets?.right)!+textSize.width, height: textSize.height+(textInsets?.top)!+(textInsets?.bottom)!)
//        self.frame = frame
//    }
//
//    func framesetter(attributed: NSAttributedString) -> CTFramesetter {
//
//        let cfattributed = attributed as CFAttributedString
//        let framesetter =  CTFramesetterCreateWithAttributedString(cfattributed);
//
//        return framesetter
//    }
//
//    func suggestFrameSize(attributed: NSAttributedString, size: CGSize, numberOfLines:UInt) -> CGSize {
//        let cfattributed = attributed as CFAttributedString
//
//        let framesetter =  CTFramesetterCreateWithAttributedString(cfattributed);
//        var rangeToSize = CFRangeMake(0, CFAttributedStringGetLength(cfattributed))
//
//        if numberOfLines > 0 {
//            let rect = CGRect.init(origin: CGPoint.init(), size: size)
//            let range = CFRange.init(location: 0, length: 0)
//            let frame = self.textFrame(framesetter: framesetter, rect: rect, range: range)
//            let lines = CTFrameGetLines(frame)
//
//            if CFArrayGetCount(lines) > 0 {
//                let lastVisibleLineIndex = min(CFIndex(numberOfLines), CFArrayGetCount(lines))
//                let lastVisibleLine = CFArrayGetValueAtIndex(lines, lastVisibleLineIndex-1)
//
//                let line: CTLine =  Unmanaged<AnyObject>.fromOpaque(lastVisibleLine!).takeUnretainedValue() as! CTLine
//
//                let rangeToLayout = CTLineGetStringRange(line)
//                rangeToSize = CFRange.init(location: 0, length: rangeToLayout.location + rangeToLayout.length)
//            }
//
//        }
//        let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, rangeToSize, nil, size, nil)
//        return suggestedSize
//    }
//
//    func textFrame(framesetter: CTFramesetter, rect: CGRect, range: CFRange) -> CTFrame {
//        let path = CGMutablePath.init()
//        path.addRect(rect)
//        let att = NSMutableDictionary()
//        att[kCTFrameProgressionAttributeName] = (CTFrameProgression.rightToLeft.hashValue)
//        att[kCTFramePathWidthAttributeName] = (0)
//        att[kCTFramePathFillRuleAttributeName] = (CTFramePathFillRule.windingNumber.hashValue)
//
//
//        let frame = CTFramesetterCreateFrame(framesetter, range, path, att)
//
//        let rotateCharset = self.VerticalFormRotateCharacterSet()
//        let rotateMoveCharset = self.VerticalFormRotateAndMoveCharacterSet()
//
//
//        //        let lines =  CTFrameGetLines(frame)
//        //        for i in 0..<CFArrayGetCount(lines) {
//        //
//        //           let lineSafeRawPointer = CFArrayGetValueAtIndex(lines, i)
//        //           let line: CTLine =  Unmanaged<AnyObject>.fromOpaque(lineSafeRawPointer!).takeUnretainedValue() as! CTLine
//        //            let runs = CTLineGetGlyphRuns(line)
//        //            for j in 0..<CFArrayGetCount(runs) {
//        //                let runSafeRawPointer = CFArrayGetValueAtIndex(runs, j)
//        //                let run: CTRun =  Unmanaged<AnyObject>.fromOpaque(runSafeRawPointer!).takeUnretainedValue() as! CTRun
//        //
//        //                let  glyphCount = CTRunGetGlyphCount(run)
//        //                if glyphCount == 0 {
//        //                    continue
//        //                }
//        //
//        //                let runStrIdx = UnsafeMutablePointer<CFIndex>.allocate(capacity: glyphCount + 1)
//        //            CTRunGetStringIndices(run, CFRangeMake(0, 0), runStrIdx)
//        //                let  runStrRange =  CTRunGetStringRange(run)
//        //                runStrIdx[glyphCount] =  runStrRange.location + runStrRange.length
//        //            let runAttrs = CTRunGetAttributes(run)
//        //            var keyPointer = kCTFontAttributeName
//        //                let layoutStr: NSString = self.attributedText!.string as! NSString
//        //
//        //
//        //                for g in 0..<glyphCount {
//        //                    var glyphRotate = false
//        //                    var glyphRotateMove = false
//        //                    let runStrLen = runStrIdx[g + 1] - runStrIdx[g]
//        //                    if runStrLen == 1 {
//        //                        let c: unichar = layoutStr.character(at: runStrIdx[g])
//        //                        glyphRotate = rotateCharset.characterIsMember(c)
//        //                        if glyphRotate == true {
//        //                            glyphRotateMove = rotateMoveCharset.characterIsMember(c)
//        //                        }
//        //                    }else if (runStrLen > 1){
//        //                        let glyphStr = layoutStr.substring(with: NSMakeRange(runStrIdx[g], runStrLen))
//        //                       let ra = glyphStr.rangeOfCharacter(from: rotateCharset as CharacterSet)
//        //                       // glyphRotate = ra.
//        //
//        //                    }
//        //
//        //                }
//        //            }
//        //
//        //        }
//        //
//        //        self.attributedText?.enumerateAttributes(in: NSMakeRange(0, self.attributedText!.length), options: .longestEffectiveRangeNotRequired, using: { (_: [String : Any],_: NSRange, _: UnsafeMutablePointer<ObjCBool>) in
//        //
//        //        })
//        return frame
//    }
//
//    func draw(context: CGContext, run: CTRun) {
//
//    }
//
//
//    func VerticalFormRotateCharacterSet() -> NSCharacterSet {
//        let set = NSMutableCharacterSet.init()
//        set.addCharacters(in: NSMakeRange(0x1100, 256))// Hangul Jamo
//        set.addCharacters(in: NSMakeRange(0x2460, 160))// Enclosed Alphanumerics
//        set.addCharacters(in: NSMakeRange(0x2600, 256))// Miscellaneous Symbols
//        set.addCharacters(in: NSMakeRange(0x2700, 192))// Dingbats
//        set.addCharacters(in: NSMakeRange(0x2E80, 128))// CJK Radicals Supplement
//        set.addCharacters(in: NSMakeRange(0x2F00, 224))// Kangxi Radicals
//        set.addCharacters(in: NSMakeRange(0x2FF0, 16))// Ideographic Description Characters
//        set.addCharacters(in: NSMakeRange(0x3000, 64))// CJK Symbols and Punctuation
//        set.addCharacters(in: NSMakeRange(0x3008, 10))
//        set.addCharacters(in: NSMakeRange(0x3014, 12))
//        set.addCharacters(in: NSMakeRange(0x3040, 96))// Hiragana
//        set.addCharacters(in: NSMakeRange(0x30A0, 96))// Katakana
//        set.addCharacters(in: NSMakeRange(0x3100, 48))// Bopomofo
//        set.addCharacters(in: NSMakeRange(0x3130, 96))// Hangul Compatibility Jamo
//        set.addCharacters(in: NSMakeRange(0x3190, 16))// Kanbun
//        set.addCharacters(in: NSMakeRange(0x31A0, 32))// Bopomofo Extended
//        set.addCharacters(in: NSMakeRange(0x31C0, 48))// CJK Strokes
//        set.addCharacters(in: NSMakeRange(0x31F0, 16))// Katakana Phonetic Extensions
//        set.addCharacters(in: NSMakeRange(0x3200, 256))// Enclosed CJK Letters and Months
//        set.addCharacters(in: NSMakeRange(0x3300, 256))// CJK Compatibility
//        set.addCharacters(in: NSMakeRange(0x3400, 2582))// CJK Unified Ideographs Extension A
//        set.addCharacters(in: NSMakeRange(0x4E00, 20941))// CJK Unified Ideographs
//        set.addCharacters(in: NSMakeRange(0xAC00, 11172))// Hangul Syllables
//        set.addCharacters(in: NSMakeRange(0xD7B0, 80))// Hangul Jamo Extended-B
//        set.addCharacters(in: "")// U+F8FF (Private Use Area)
//        set.addCharacters(in: NSMakeRange(0xF900, 512))// CJK Compatibility Ideographs
//        set.addCharacters(in: NSMakeRange(0xFE10, 16))// Vertical Forms
//        set.addCharacters(in: NSMakeRange(0xFF00, 240))// Halfwidth and Fullwidth Forms
//        set.addCharacters(in: NSMakeRange(0x1F200, 256))// Enclosed Ideographic Supplement
//        set.addCharacters(in: NSMakeRange(0x1F300, 768))// Enclosed Ideographic Supplement
//        
//        set.addCharacters(in: NSMakeRange(0x1F600, 80))// Emoticons (Emoji)
//        set.addCharacters(in: NSMakeRange(0x1F680, 128))// Transport and Map Symbols
//        // See http://unicode-table.com/ for more information.
//        return set
//        
//    }
//    
//    func VerticalFormRotateAndMoveCharacterSet() -> NSCharacterSet {
//        let set = NSMutableCharacterSet.init()
//        set.addCharacters(in: "，。、")
//        return set
//    }
}
