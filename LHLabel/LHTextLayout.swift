//
//  LHTextLayout.swift
//  LHLabel
//
//  Created by luhai on 16/11/12.
//  Copyright © 2016年 luhai. All rights reserved.
//

import UIKit

class LHTextContainer : NSObject {

    var size = CGSize()
    var insets = UIEdgeInsets()
    var path = UIBezierPath()
    var exclusionPaths: [UIBezierPath] = []
    var pathLineWidth: CGFloat = 0
    var maximumNumberOfRows: Int = 1
    

    
    public override init() {
        super.init()
    }
    
    class  func container(size: CGSize) -> LHTextContainer {
        return self.container(size: size, insets: UIEdgeInsets())
    }
   
    class  func container(size: CGSize, insets: UIEdgeInsets) -> LHTextContainer {
        let container = LHTextContainer.init()
        container.size = size
        container.insets = insets
        return container
    }
}

class LHTextLayout: NSObject {

    private var _textContainer = LHTextContainer()
    private var _attributedText = NSAttributedString()
    private var _range = NSRange()
    private var _bounds = CGRect()
    private var _textRect = CGRect()
    private var _textInsets = UIEdgeInsets()
    private var _frame: CTFrame?
    private var _framesetter: CTFramesetter?
    
    var textContainer: LHTextContainer {
        return _textContainer
    }
    
    var attributedText: NSAttributedString {
        return _attributedText
    }
    
    var range: NSRange {
        return _range
    }
    
    var bounds: CGRect {
        return _bounds
    }
    
    var textRect: CGRect {
        return _textRect
    }
    
    var textInsets: UIEdgeInsets{
        return _textInsets
    }
    
    var frame: CTFrame?{
        return _frame
    }
    
    var framesetter:CTFramesetter?{
        return _framesetter
    }
    

    var numberOfLines: UInt = 0
    
    class  func layout(size: CGSize, text: NSAttributedString) -> LHTextLayout {
        let container = LHTextContainer.container(size: size)
        return self.layout(container: container, text: text, range: NSMakeRange(0, text.length))
    }
    
    class  func layout(container: LHTextContainer, text: NSAttributedString) -> LHTextLayout {
      return self.layout(container: container, text: text, range: NSMakeRange(0, text.length))
    }

    class  func layout(container: LHTextContainer, text: NSAttributedString, range: NSRange) -> LHTextLayout {
        
        
        let layout = LHTextLayout.init()
        layout._attributedText = text
        layout._textContainer = container
        layout._range = range
        
        var rect = CGRect.init(origin: CGPoint(), size: container.size)
        rect = UIEdgeInsetsInsetRect(rect, container.insets)
        rect =  rect.standardized
        
        rect = rect.applying(CGAffineTransform.init(scaleX: 1, y: -1))
        let cgPath = CGPath.init(rect: rect, transform: nil)
        
        let att = NSMutableDictionary()
        att[kCTFrameProgressionAttributeName] = (CTFrameProgression.rightToLeft.hashValue)
        att[kCTFramePathWidthAttributeName] = (0n)
        att[kCTFramePathFillRuleAttributeName] = (CTFramePathFillRule.windingNumber.hashValue)
        
        layout._framesetter = CTFramesetterCreateWithAttributedString(text as CFAttributedString)
       
        layout._frame = CTFramesetterCreateFrame(layout._framesetter!, CFRangeMake(0, CFIndex(text.length)), cgPath, att)
        
    
        return layout
    }
    
    
    public override init(){
        super.init()
    }

//
//    func framesetter(attributed: NSAttributedString) -> CTFramesetter {
//
//        let cfattributed = attributed as CFAttributedString
//        let framesetter =  CTFramesetterCreateWithAttributedString(cfattributed);
//
//        return framesetter
//    }

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

    func textFrame(framesetter: CTFramesetter, rect: CGRect, range: CFRange) -> CTFrame? {
        let path = CGMutablePath.init()
        path.addRect(rect)
     


    
        let rotateCharset = self.VerticalFormRotateCharacterSet()
        let rotateMoveCharset = self.VerticalFormRotateAndMoveCharacterSet()


        //        let lines =  CTFrameGetLines(frame)
        //        for i in 0..<CFArrayGetCount(lines) {
        //
        //           let lineSafeRawPointer = CFArrayGetValueAtIndex(lines, i)
        //           let line: CTLine =  Unmanaged<AnyObject>.fromOpaque(lineSafeRawPointer!).takeUnretainedValue() as! CTLine
        //            let runs = CTLineGetGlyphRuns(line)
        //            for j in 0..<CFArrayGetCount(runs) {
        //                let runSafeRawPointer = CFArrayGetValueAtIndex(runs, j)
        //                let run: CTRun =  Unmanaged<AnyObject>.fromOpaque(runSafeRawPointer!).takeUnretainedValue() as! CTRun
        //
        //                let  glyphCount = CTRunGetGlyphCount(run)
        //                if glyphCount == 0 {
        //                    continue
        //                }
        //
        //                let runStrIdx = UnsafeMutablePointer<CFIndex>.allocate(capacity: glyphCount + 1)
        //            CTRunGetStringIndices(run, CFRangeMake(0, 0), runStrIdx)
        //                let  runStrRange =  CTRunGetStringRange(run)
        //                runStrIdx[glyphCount] =  runStrRange.location + runStrRange.length
        //            let runAttrs = CTRunGetAttributes(run)
        //            var keyPointer = kCTFontAttributeName
        //                let layoutStr: NSString = self.attributedText!.string as! NSString
        //
        //
        //                for g in 0..<glyphCount {
        //                    var glyphRotate = false
        //                    var glyphRotateMove = false
        //                    let runStrLen = runStrIdx[g + 1] - runStrIdx[g]
        //                    if runStrLen == 1 {
        //                        let c: unichar = layoutStr.character(at: runStrIdx[g])
        //                        glyphRotate = rotateCharset.characterIsMember(c)
        //                        if glyphRotate == true {
        //                            glyphRotateMove = rotateMoveCharset.characterIsMember(c)
        //                        }
        //                    }else if (runStrLen > 1){
        //                        let glyphStr = layoutStr.substring(with: NSMakeRange(runStrIdx[g], runStrLen))
        //                       let ra = glyphStr.rangeOfCharacter(from: rotateCharset as CharacterSet)
        //                       // glyphRotate = ra.
        //
        //                    }
        //
        //                }
        //            }
        //
        //        }
        //
        //        self.attributedText?.enumerateAttributes(in: NSMakeRange(0, self.attributedText!.length), options: .longestEffectiveRangeNotRequired, using: { (_: [String : Any],_: NSRange, _: UnsafeMutablePointer<ObjCBool>) in
        //
        //        })
        return nil
    }

    func draw(context: CGContext, size: CGSize, point:CGPoint) {
        
        CTFrameDraw(self.frame!, context)
    }
    
    func draw(context: CGContext, run: CTRun) {

    }


    func VerticalFormRotateCharacterSet() -> NSCharacterSet {
        let set = NSMutableCharacterSet.init()
        set.addCharacters(in: NSMakeRange(0x1100, 256))// Hangul Jamo
        set.addCharacters(in: NSMakeRange(0x2460, 160))// Enclosed Alphanumerics
        set.addCharacters(in: NSMakeRange(0x2600, 256))// Miscellaneous Symbols
        set.addCharacters(in: NSMakeRange(0x2700, 192))// Dingbats
        set.addCharacters(in: NSMakeRange(0x2E80, 128))// CJK Radicals Supplement
        set.addCharacters(in: NSMakeRange(0x2F00, 224))// Kangxi Radicals
        set.addCharacters(in: NSMakeRange(0x2FF0, 16))// Ideographic Description Characters
        set.addCharacters(in: NSMakeRange(0x3000, 64))// CJK Symbols and Punctuation
        set.addCharacters(in: NSMakeRange(0x3008, 10))
        set.addCharacters(in: NSMakeRange(0x3014, 12))
        set.addCharacters(in: NSMakeRange(0x3040, 96))// Hiragana
        set.addCharacters(in: NSMakeRange(0x30A0, 96))// Katakana
        set.addCharacters(in: NSMakeRange(0x3100, 48))// Bopomofo
        set.addCharacters(in: NSMakeRange(0x3130, 96))// Hangul Compatibility Jamo
        set.addCharacters(in: NSMakeRange(0x3190, 16))// Kanbun
        set.addCharacters(in: NSMakeRange(0x31A0, 32))// Bopomofo Extended
        set.addCharacters(in: NSMakeRange(0x31C0, 48))// CJK Strokes
        set.addCharacters(in: NSMakeRange(0x31F0, 16))// Katakana Phonetic Extensions
        set.addCharacters(in: NSMakeRange(0x3200, 256))// Enclosed CJK Letters and Months
        set.addCharacters(in: NSMakeRange(0x3300, 256))// CJK Compatibility
        set.addCharacters(in: NSMakeRange(0x3400, 2582))// CJK Unified Ideographs Extension A
        set.addCharacters(in: NSMakeRange(0x4E00, 20941))// CJK Unified Ideographs
        set.addCharacters(in: NSMakeRange(0xAC00, 11172))// Hangul Syllables
        set.addCharacters(in: NSMakeRange(0xD7B0, 80))// Hangul Jamo Extended-B
        set.addCharacters(in: "")// U+F8FF (Private Use Area)
        set.addCharacters(in: NSMakeRange(0xF900, 512))// CJK Compatibility Ideographs
        set.addCharacters(in: NSMakeRange(0xFE10, 16))// Vertical Forms
        set.addCharacters(in: NSMakeRange(0xFF00, 240))// Halfwidth and Fullwidth Forms
        set.addCharacters(in: NSMakeRange(0x1F200, 256))// Enclosed Ideographic Supplement
        set.addCharacters(in: NSMakeRange(0x1F300, 768))// Enclosed Ideographic Supplement
        
        set.addCharacters(in: NSMakeRange(0x1F600, 80))// Emoticons (Emoji)
        set.addCharacters(in: NSMakeRange(0x1F680, 128))// Transport and Map Symbols
        // See http://unicode-table.com/ for more information.
        return set
        
    }
    
    func VerticalFormRotateAndMoveCharacterSet() -> NSCharacterSet {
        let set = NSMutableCharacterSet.init()
        set.addCharacters(in: "，。、")
        return set
    }
}
