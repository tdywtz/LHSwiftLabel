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
    var maximumNumberOfRows: Int = 0
    var verticalForm = false
    
    
    
//    public override init() {
//        super.init()
//    }
    
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
        container.verticalForm = verticalForm
        return container
    }
}

class LHTextLayout: NSObject {
    
    private var _textContainer = LHTextContainer()
    private var _attributedText = NSAttributedString()
    private var _range = NSRange()
    private var _textBoundingRect = CGRect()
    private var _textInsets = UIEdgeInsets()
    private var _frame: CTFrame?
    private var _framesetter: CTFramesetter?
    private var _lines = Array<LHTextLine>()
    private var _isTruncation = false
    private var maximumNumberOfRows: Int = 0
    
    var textContainer: LHTextContainer {
        return _textContainer
    }
    
    var attributedText: NSAttributedString {
        return _attributedText
    }
    
    var range: NSRange {
        return _range
    }
    
    var textBoundingRect: CGRect {
        return _textBoundingRect
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
    
    var lines: Array<LHTextLine> {
        return _lines
    }
    
    var isTruncation: Bool {
        return _isTruncation
    }

    func update(attributedText: NSAttributedString) {
        let text = attributedText.copy() as? NSAttributedString
        if text != nil {
                _attributedText = text!
               self.layout(container: self.textContainer, text: _attributedText, range: NSRange.init(location: 0, length: _attributedText.length))
        }
    }


    //MARK: textLayout
    class  func layout(size: CGSize, text: NSAttributedString) -> LHTextLayout {
        let container = LHTextContainer.container(size: size)
        return self.layout(container: container, text: text)
    }
    
    class  func layout(container: LHTextContainer, text: NSAttributedString) -> LHTextLayout {
        let layout = LHTextLayout.init()
         layout.layout(container: container, text: text, range: NSMakeRange(0, text.length))

        return layout
    }
    
    func layout(container: LHTextContainer, text: NSAttributedString, range: NSRange) {
        
        var rect = CGRect.zero
        var cgPath:CGPath?
        var cgPathBox = CGRect.zero
        let frameAttrs = NSMutableDictionary()
        var ctSetter:CTFramesetter?
        var ctFrame: CTFrame?
        var ctLines: CFArray?
        var lineOrigins: UnsafeMutablePointer<CGPoint>?
        var lineCount = Int(0)
        var lines = Array<LHTextLine>()
        var isTruncation = false
        let vertical = container.verticalForm
        
        let maximumNumberOfRows: Int = container.maximumNumberOfRows
        
        let text = text.copy() as! NSAttributedString
        let container = container.copy() as! LHTextContainer
        
        if range.length + range.location > text.length {
            return
        }
        
        
        if container.exclusionPaths.count == 0{
            rect = CGRect.init(origin: CGPoint(), size: container.size)
            rect = UIEdgeInsetsInsetRect(rect, container.insets)
            rect =  rect.standardized
            cgPathBox = rect;
            rect = rect.applying(CGAffineTransform.init(scaleX: 1, y: -1))
            cgPath = CGPath.init(rect: rect, transform: nil)
            
        }else{
            var mpath: CGMutablePath?
            rect = CGRect.init(origin: CGPoint(), size: container.size)
            rect = UIEdgeInsetsInsetRect(rect, container.insets)
            let rectPath = CGPath.init(rect: rect, transform: nil)
            
            mpath = rectPath.mutableCopy()
            
            
            if mpath != nil {
                for bezierPath in container.exclusionPaths {
                    mpath!.addPath(bezierPath.cgPath)
                }
                cgPathBox = mpath!.boundingBox
                let trans = CGAffineTransform.init(scaleX: 1, y: -1)
                let transPath = CGMutablePath.init()
                transPath.addPath(mpath!, transform: trans)
                mpath = transPath
                
            }
            cgPath = mpath
        }
        
        
        if container.verticalForm {
            frameAttrs[kCTFrameProgressionAttributeName] = (CTFrameProgression.rightToLeft.hashValue)
        }
        
               // frameAttrs[kCTFramePathWidthAttributeName] = (0)
               // frameAttrs[kCTFramePathFillRuleAttributeName] = (CTFramePathFillRule.windingNumber.hashValue)
        
        ctSetter = CTFramesetterCreateWithAttributedString(text as CFAttributedString)
        
        ctFrame = CTFramesetterCreateFrame(ctSetter!, CFRangeMake(0, CFIndex(text.length)), cgPath!, frameAttrs)
        
        ctLines = CTFrameGetLines(ctFrame!)
        lineCount = CFArrayGetCount(ctLines!)
        if lineCount > 0 {
            lineOrigins = UnsafeMutablePointer<CGPoint>.allocate(capacity: lineCount)
            CTFrameGetLineOrigins(ctFrame!, CFRange.init(), lineOrigins)
        }
        
        var textBoundingRect = CGRect.zero
        var rowIdx: Int = -1
        var rowCount: Int = 0
        var lastRect = CGRect.init(x: 0, y: -Int.max, width: 0, height: 0)
        var lastPosition = CGPoint.init(x: 0, y: -Int.max)
        var lineCurrentIdx: uint = 0
        if vertical {
            lastRect = CGRect.init(x: Int.max, y: 0, width: 0, height: 0)
            lastPosition = CGPoint.init(x: Int.max, y: 0)
        }
        for i in 0 ..< lineCount {
            let ctLine = Unmanaged<AnyObject>.fromOpaque(CFArrayGetValueAtIndex(ctLines, i)).takeUnretainedValue() as! CTLine
            let ctRuns = CTLineGetGlyphRuns(ctLine)
            if  CFArrayGetCount(ctRuns) == 0 { continue }
            
            let ctLineOrigin = lineOrigins![i]
            var position = CGPoint.zero
            
            position.x =  cgPathBox.origin.x + ctLineOrigin.x
            position.y = cgPathBox.height - ctLineOrigin.y

            if vertical {
                position.x = -cgPathBox.maxX + cgPathBox.origin.x + ctLineOrigin.x
            }

            let lhLine = LHTextLine.line(ctLine: ctLine, position: position, vertical: vertical)
            lines.append(lhLine)

            let rect = lhLine.bounds

            if vertical {
                
            }else {
                
            }
            var newRow = true
            if vertical {
                if (rect.size.width > lastRect.size.width) {
                    if (rect.origin.x < lastPosition.x && lastPosition.x < rect.origin.x - rect.size.width){
                        newRow = false
                    }
                } else {
                    if (lastRect.origin.x < position.x && position.x < lastRect.origin.x - lastRect.size.width){
                        newRow = false
                    }
                }
            }else {
                if (rect.size.height > lastRect.size.height) {
                    if (rect.origin.y < lastPosition.y && lastPosition.y < rect.origin.y + rect.size.height){
                        newRow = false
                    }
                } else {
                    if (lastRect.origin.y < position.y && position.y < lastRect.origin.y + lastRect.size.height){
                        newRow = false
                    }
                }
            }
         
            
            if (newRow){
                rowIdx += 1
            }
            lastRect = rect;
            lastPosition = position;
            
            lhLine.row = rowIdx
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
     
        if rowCount > 0 {
            if maximumNumberOfRows > 0 {
                if rowCount > maximumNumberOfRows {
                    while (true) {
                         let line = lines.last
                        if line == nil {
                            break
                        }
                         if line!.row < maximumNumberOfRows {
                            break
                        }
                        lines.removeLast()
                    }
                }
            }
        }

        if lines.last != nil {
            let lastLine = lines.last!

            if lastLine.range.location + lastLine.range.length < text.length {
                isTruncation = true
                let att = text.attributedSubstring(from: lastLine.range).mutableCopy() as? NSMutableAttributedString

                if att != nil {

                    att?.replaceCharacters(in: NSRange.init(location: att!.length - 1, length: 1), with: LHTextTruncationToken)

                    let line = CTLineCreateWithAttributedString(att as! CFAttributedString)
                    lines[lines.count - 1] = LHTextLine.line(ctLine: line, position: lastLine.position, vertical: false)
                }
            }
        }

        

        self._attributedText = text
        self._textContainer = container
        self._range = range
        self._framesetter = ctSetter
        self._frame = ctFrame
        self._textBoundingRect = textBoundingRect
        self._lines = lines
        self._isTruncation = isTruncation
        
        if lineOrigins != nil {
            free(lineOrigins)
        }
    }


    func updateLayout(container: LHTextContainer) {

    }
    
    
    public override init(){
        super.init()
    }
    
    func draw(context: CGContext, rect: CGRect, point:CGPoint, targetView: UIView, targetLayer: CALayer) {
      // self.attributedText .draw(in: CGRect.init(x: 0, y: 0, width: 200, height: 200))
        self.drawText(layout: self, context: context, size: rect.size, point: point)
        self.drawAttachment(layout: self, context: context, size: rect.size, point: point, targetView: targetView, targetLayer: targetLayer)
    }
    
    func drawText(layout: LHTextLayout, context: CGContext, size: CGSize, point: CGPoint) {
        context.saveGState()
        
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -size.height)
        context.textPosition = point

        let lines = layout.lines
        for i in 0 ..< lines.count {
            let line = lines[i]
            let posX = line.position.x
            let posY = (size.height - line.position.y - point.y)
            
            let ctRuns = CTLineGetGlyphRuns(line.ctLine!)
            for k in 0 ..< CFArrayGetCount(ctRuns) {
                let runRawPointer = CFArrayGetValueAtIndex(ctRuns, k)
                let run = Unmanaged<AnyObject>.fromOpaque(runRawPointer!).takeUnretainedValue() as! CTRun
                context.textMatrix = CGAffineTransform.identity
                context.textPosition = CGPoint.init(x: posX, y: posY)
                
                self.drawRun(context: context, line: line, run: run, size: size, isVertical: layout.textContainer.verticalForm)

            }
            
        }
        
        context.restoreGState()
    }
    
    func drawRun(context: CGContext, line: LHTextLine, run: CTRun, size: CGSize, isVertical: Bool) {
        
                let runTextMatrix = CTRunGetTextMatrix(run)
                let runTextMatrixIsID = runTextMatrix.isIdentity
        
                let attrs =  CTRunGetAttributes(run) as NSDictionary

        if !isVertical {
                if !runTextMatrixIsID {
                    context.saveGState()
                    context.textMatrix = context.textMatrix.concatenating(runTextMatrix)
                }
                CTRunDraw(run, context, CFRangeMake(0, 0))
                if  !runTextMatrixIsID {
                    context.restoreGState()
                }
        }else {
            if attrs[kCTFontAttributeName] == nil {
                return
            }
            let runFont = attrs[kCTFontAttributeName] as! CTFont
            let glyphCount = CTRunGetGlyphCount(run)
            if glyphCount <= 0 {
                return
            }
            let glyphs = UnsafeMutablePointer<CGGlyph>.allocate(capacity: glyphCount)
            let glyphPositions = UnsafeMutablePointer<CGPoint>.allocate(capacity: glyphCount)
            
            CTRunGetGlyphs(run, CFRangeMake(0, 0), glyphs)
            CTRunGetPositions(run, CFRangeMake(0, 0), glyphPositions)

            var fillColor = UIColor.orange.cgColor
            if attrs[NSForegroundColorAttributeName] != nil {
                fillColor = (attrs[NSForegroundColorAttributeName] as! UIColor).cgColor
            }

            let strokeWidth = attrs[kCTStrokeWidthAttributeName] as? NSNumber


            context.saveGState()
            context.setFillColor(fillColor)
            if strokeWidth == nil {
                context.setTextDrawingMode(.fill)
                
            }else {
//                let strokeColor = UIColor.black.cgColor
//                context.setStrokeColor(strokeColor)
//                let lineWidth = CTFontGetSize(runFont) * CGFloat(fabs(strokeWidth.floatValue * 0.01))
//                
//                context.setLineWidth(lineWidth)
//                if strokeWidth.floatValue > 0 {
//                    context.setTextDrawingMode(.stroke)
//                }else{
//                    context.setTextDrawingMode(.fillStroke)
//                }
            }
            if isVertical {
                let runStrIdx = UnsafeMutablePointer<CFIndex>.allocate(capacity: glyphCount + 1)
               
                CTRunGetStringIndices(run, CFRangeMake(0, 0), runStrIdx)
                let runStrRange = CTRunGetStringRange(run)
                runStrIdx[glyphCount] = runStrRange.location + runStrRange.length
               
                let glyphAdvances = UnsafeMutablePointer<CGSize>.allocate(capacity: glyphCount)
                CTRunGetAdvances(run, CFRangeMake(0, 0), glyphAdvances)
                
                let ascent = CTFontGetAscent(runFont)
                let descent = CTFontGetDescent(runFont)
              //  let glyphTransform = glyphTransformValue.cag

                let range = CTRunGetStringRange(run)

                for i in 0 ..< range.length {

                  context.saveGState()
                   
                    context.textMatrix = CGAffineTransform.identity

                    if false {
                         context.rotate(by:CGFloat(-90 * M_PI / 180))
                         context.textPosition = CGPoint.init(x: line.position.y - size.height + glyphPositions[i].x, y: line.position.x + 0 + glyphPositions[i].y)
                    }else {
                        // CJK glyph, need rotated
                        let ofs = (ascent - descent) * 0.5
                        let w = glyphAdvances[i].width * 0.5
                        let x = line.position.x + glyphPositions[i].y - (descent)/2 + size.width
                        let y = -line.position.y  + size.height - glyphPositions[i].x - (ofs + w)

                        context.textPosition = CGPoint.init(x: x, y: y)
                    }

                        let cgFont = CTFontCopyGraphicsFont(runFont, nil)
                        context.setFont(cgFont)
                        context.setFontSize(CTFontGetSize(runFont))
                        context.showGlyphs([glyphs[i]], at: [CGPoint.zero])

                    context.restoreGState()
                  

                }
            }
            
            context.restoreGState()
            
        }
    }
    
    func drawAttachment(layout: LHTextLayout, context: CGContext, size: CGSize, point: CGPoint, targetView: UIView, targetLayer: CALayer)  {
        for line in layout.lines {
            for i in 0 ..< line.attachments.count {
                let ment = line.attachments[i]
                let content = ment.content
                if content == nil {
                    continue
                }
                
                var rect = line.attachmentRects[i]
                rect = UIEdgeInsetsInsetRect(rect, ment.contentInsets)
                rect = rect.standardized
                rect.origin.x += point.x
                rect.origin.y += point.y
                
                if content!.isKind(of: UIImage.classForCoder()) {
                    let cgImage = (ment.content as! UIImage).cgImage
                    if cgImage != nil {
                        context.saveGState()
                        context.translateBy(x: 0, y: rect.maxY + rect.minY)
                        context.scaleBy(x: 1, y: -1)
                        context.draw(cgImage!, in: rect)
                        context.restoreGState()
                    }
                }
            }
        }
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
