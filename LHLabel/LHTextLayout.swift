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


    override func copy() -> Any {

        let container = LHTextContainer.init()

        container.size = size
        container.insets = insets
        container.path = path
        container.exclusionPaths = exclusionPaths
        container.pathLineWidth = pathLineWidth
        container.maximumNumberOfRows = maximumNumberOfRows

        return container
    }
}

class LHTextLayout: NSObject {

    private var _textContainer = LHTextContainer()
    private var _attributedText = NSAttributedString()
    private var _range = NSRange()
    private var _textSize = CGSize()
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

    var textSize: CGSize {
        return _textSize
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

        var rect = CGRect.zero
        var cgPath:CGPath?
        var cgPathBox = CGRect.zero
        let frameAttrs = NSMutableDictionary()
        var ctSetter:CTFramesetter?
        var ctFrame: CTFrame?
        var ctLines: CFArray?
        var lineOrigins: UnsafeMutablePointer<CGPoint>?
        var lineCount = Int(0)
        var lines = NSMutableArray()
        var maximumNumberOfRows: Int = 0

        let text = text.copy() as! NSAttributedString
        let container = container.copy() as! LHTextContainer

        if range.length + range.location > text.length { return LHTextLayout() }

        let layout = LHTextLayout.init()
        layout._attributedText = text
        layout._textContainer = container
        layout._range = range

        rect = CGRect.init(origin: CGPoint(), size: container.size)
        rect = UIEdgeInsetsInsetRect(rect, container.insets)
        rect =  rect.standardized
        cgPathBox = rect;
        rect = rect.applying(CGAffineTransform.init(scaleX: 1, y: -1))
        cgPath = CGPath.init(rect: rect, transform: nil)


        //        frameAttrs[kCTFrameProgressionAttributeName] = (CTFrameProgression.rightToLeft.hashValue)
        //        frameAttrs[kCTFramePathWidthAttributeName] = (0)
        //        frameAttrs[kCTFramePathFillRuleAttributeName] = (CTFramePathFillRule.windingNumber.hashValue)

        ctSetter = CTFramesetterCreateWithAttributedString(text as CFAttributedString)

        ctFrame = CTFramesetterCreateFrame(ctSetter!, CFRangeMake(0, CFIndex(text.length)), cgPath!, frameAttrs)

        ctLines = CTFrameGetLines(ctFrame!)
        lineCount = CFArrayGetCount(ctLines!)
        if lineCount > 0 {
            lineOrigins = UnsafeMutablePointer<CGPoint>.allocate(capacity: lineCount)
            CTFrameGetLineOrigins(ctFrame!, CFRange.init(), lineOrigins)
        }

        var textBoundingRect = CGRect.zero
        var textBoundingSize = CGSize.zero
        var rowIdx: Int = -1
        var rowCount: uint = 0
        var lastRect = CGRect.init(x: 0, y: -Int.max, width: 0, height: 0)
        var lastPosition = CGPoint.init(x: 0, y: -Int.max)
        var lineCurrentIdx: uint = 0

        for i in 0 ..< lineCount {
            let ctLine = Unmanaged<AnyObject>.fromOpaque(CFArrayGetValueAtIndex(ctLines, i)).takeUnretainedValue() as! CTLine
            let ctRuns = CTLineGetGlyphRuns(ctLine)
            if  CFArrayGetCount(ctRuns) == 0 { continue }

            let ctLineOrigin = lineOrigins![i]
            var position = CGPoint.zero

            position.x =  cgPathBox.origin.x + ctLineOrigin.x
            position.y = cgPathBox.size.height + cgPathBox.origin.y - ctLineOrigin.y

            let lhLine = LHTextLine.line(ctLine: ctLine, position: position, vertical: false)
            ///
            var ascent: CGFloat = 0
            var descent: CGFloat = 0
            var leading: CGFloat = 0

            let width =  CTLineGetTypographicBounds(ctLine, &ascent, &descent, &leading)
            let rect = CGRect.init(origin: position, size: CGSize.init(width: CGFloat(width), height: ascent+descent))




            var newRow = true
            if (rect.size.height > lastRect.size.height) {
                if (rect.origin.y < lastPosition.y && lastPosition.y < rect.origin.y + rect.size.height){
                    newRow = false
                }
            } else {
                if (lastRect.origin.y < position.y && position.y < lastRect.origin.y + lastRect.size.height){
                    newRow = false
                }
            }

            if (newRow){
                rowIdx += 1
            }
            lastRect = rect;
            lastPosition = position;
            rowCount += 1
            lineCurrentIdx += 1
            if (i == 0){
                textBoundingRect = rect
            }else {
                if (maximumNumberOfRows == 0 || rowIdx < maximumNumberOfRows) {
                    textBoundingRect = rect.union(textBoundingRect)
                }
            }
        }

        textBoundingSize = textBoundingRect.size
        layout._framesetter = ctSetter
        layout._frame = ctFrame
        layout._textRect = textBoundingRect
        layout._textSize = textBoundingSize
        if lineOrigins != nil {
            free(lineOrigins)
        }

        return layout
    }


    public override init(){
        super.init()
    }

    func draw(context: CGContext, rect: CGRect, point:CGPoint) {

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
