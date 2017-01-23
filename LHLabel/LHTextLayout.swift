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

    var truncationTokenLine: LHTextLine?

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

    var bounds: CGRect {

        let rect = CGRect.init(x: 0, y: 0, width: textBoundingRect.width + _textInsets.left + _textInsets.right, height: textBoundingRect.height + _textInsets.top + _textInsets.bottom)

        return rect
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

    override func copy() -> Any {
        let copy = LHTextLayout.init()
        copy._attributedText = _attributedText
        copy._frame = _frame
        copy._framesetter = _framesetter
        copy._isTruncation = isTruncation
        copy._lines = lines
        copy._range = _range
        copy._textBoundingRect = _textBoundingRect
        copy._textContainer = _textContainer
        copy._textInsets = _textInsets
        copy.maximumNumberOfRows = maximumNumberOfRows
        copy.truncationTokenLine = truncationTokenLine
        return copy
    }

    //MARK: textLayout
    class  func layout(size: CGSize, text: NSAttributedString) -> LHTextLayout {
        let container = LHTextContainer.container(size: size)
        return self.layout(container: container, text: text)
    }

    class  func layout(container: LHTextContainer, text: NSAttributedString) -> LHTextLayout {

        return self.layout(container: container, text: text, range: NSRange.init(location: 0, length: text.length))
    }

    //    func update(attributedText: NSAttributedString) {
    //        let text = attributedText.copy() as? NSAttributedString
    //        if text != nil {
    //            _attributedText = text!
    //            self.layout(container: self.textContainer, text: _attributedText, range: NSRange.init(location: 0, length: _attributedText.length))
    //        }
    //    }
    //    func updateLayout(container: LHTextContainer){
    //        self.layout(container: container, text: _attributedText, range: NSRange.init(location: 0, length: _attributedText.length))
    //    }


    class func layout(container: LHTextContainer, text: NSAttributedString, range: NSRange) -> LHTextLayout {
        if text.length == 0 {
            return LHTextLayout()
        }
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
        var TruncationTokenLine: LHTextLine?

        let vertical = container.verticalForm

        let maximumNumberOfRows: Int = container.maximumNumberOfRows

        let text = text.copy() as! NSAttributedString
        let container = container.copy() as! LHTextContainer
        let layout = LHTextLayout()


        if range.length + range.location > text.length {
            return LHTextLayout()
        }

        rect = CGRect.init(origin: CGPoint(), size: container.size)
        rect = UIEdgeInsetsInsetRect(rect, container.insets)
        rect.origin.x = 0;
        rect.origin.y = 0;
        if container.exclusionPaths.count == 0{

            rect =  rect.standardized
            cgPathBox = rect;
            rect = rect.applying(CGAffineTransform.init(scaleX: 1, y: -1))
            cgPath = CGPath.init(rect: rect, transform: nil)

        }else{
            // var mpath: CGMutablePath?
            let rectPath = CGPath.init(rect: rect, transform: nil)
            var mpath = rectPath.mutableCopy()

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
            lhLine.index = i
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

                    let truncationToken = NSMutableAttributedString.init(string: LHTextTruncationToken)
                    truncationToken.lh_font = att?.lh_font(index: att!.length - 1)
                    truncationToken.lh_color = att?.lh_color(index: att!.length - 1)
                    let truncationTokenLine = CTLineCreateWithAttributedString(truncationToken as CFAttributedString)

                   // att?.append(NSAttributedString.init(string:LHTextTruncationToken))
                    att?.replaceCharacters(in: NSRange.init(location: att!.length - 1, length: 1), with: LHTextTruncationToken)
                    let ctLastLineExtend = CTLineCreateWithAttributedString(att! as CFAttributedString)
                    var truncatedWidth = lastLine.bounds.width
                    var cgPathRect = CGRect.zero
                    if cgPath!.isRect(&cgPathRect) {
                        if vertical {
                            truncatedWidth = cgPathRect.size.height;
                        } else {
                            truncatedWidth = cgPathRect.size.width;
                        }
                    }

                    let line = CTLineCreateTruncatedLine(ctLastLineExtend, Double(truncatedWidth), .end, truncationTokenLine)

                    if line != nil {
                        TruncationTokenLine = LHTextLine.line(ctLine: line!, position: lastLine.position, vertical: vertical)
                        TruncationTokenLine!.row = lastLine.row;
                        TruncationTokenLine!.index = lastLine.index
                        TruncationTokenLine!.lineAttributeText = att
                       
                    }
                }
            }
        }

        if vertical {
            let rotateCharset = layout.VerticalFormRotateCharacterSet()
            let rotateMoveCharset = layout.VerticalFormRotateAndMoveCharacterSet()


            let lineClosure:(LHTextLine) ->Void = { (line) -> Void in
                if line.ctLine == nil {
                    return
                }
                var lineRunRanges = Array<Array<LHTextRotateRange>>()
                let ctRuns = CTLineGetGlyphRuns(line.ctLine!)
                let runCount = CFArrayGetCount(ctRuns)
                if rowCount == 0 {
                    return
                }

                for i in 0 ..< runCount {

                    let runRawPointer = CFArrayGetValueAtIndex(ctRuns, i)
                    let run = Unmanaged<AnyObject>.fromOpaque(runRawPointer!).takeUnretainedValue() as! CTRun
                    let glyphCount = CTRunGetGlyphCount(run)
//                    let attrs =  CTRunGetAttributes(run) as NSDictionary
//                    print(attrs)
                    if glyphCount <= 0 {
                        continue
                    }
                    let runStrIdx = UnsafeMutablePointer<CFIndex>.allocate(capacity: glyphCount+1)
                    CTRunGetStringIndices(run, CFRangeMake(0, 0), runStrIdx);
                    let runStrRange = CTRunGetStringRange(run);
                    runStrIdx[glyphCount] = runStrRange.location + runStrRange.length;
                    let runAttrs = CTRunGetAttributes(run) as NSDictionary
                    let font = runAttrs[kCTFontAttributeName] as! CTFont
                    let isColorGlyph: Bool = (CTFontGetSymbolicTraits(font).rawValue & CTFontSymbolicTraits.colorGlyphsTrait.rawValue) != 0
                    var prevIdx: Int = 0
                    var runRanges = Array<LHTextRotateRange>()

                    var layoutStr = text.string as NSString
                    if line.lineAttributeText != nil {
                        layoutStr = line.lineAttributeText!.string as NSString
                    }
                    for g in 0 ..< glyphCount {

                        var glyphRotate = false
                        var glyphRotateMove = false
                        let runStrLen: CFIndex = runStrIdx[g + 1] - runStrIdx[g]
                        if isColorGlyph {
                            glyphRotate = true

                        }else if runStrLen == 1 {
                            let c: unichar = layoutStr.character(at: runStrIdx[g])
                            glyphRotate = rotateCharset.characterIsMember(c)
                            if glyphRotate {
                                glyphRotateMove = rotateMoveCharset.characterIsMember(c)
                            }
                        }else if runStrLen > 1 {
                            let glyphStr: NSString = layoutStr.substring(with: NSRange.init(location: runStrIdx[g], length: runStrLen)) as NSString
                            let glyphRotate: Bool = glyphStr.rangeOfCharacter(from: rotateCharset as CharacterSet).location != NSNotFound

                            if glyphRotate {
                                glyphRotateMove = glyphStr.rangeOfCharacter(from: rotateMoveCharset as CharacterSet).location != NSNotFound
                            }
                        }
                        if g == 0 {

                        }

                        prevIdx = g

                        let range = NSRange.init(location: runStrIdx[g], length:runStrLen)
                        let RotateRange = LHTextRotateRange()
                        RotateRange.range = range
                        RotateRange.vertical = glyphRotate

                        runRanges.append(RotateRange)
                    }

                    lineRunRanges.append(runRanges)
                    line.runRanges = lineRunRanges
                    runStrIdx.deallocate(capacity: glyphCount + 1)
                }
            }

            for line in lines {
                lineClosure(line)
            }
            if TruncationTokenLine != nil {
                lineClosure(TruncationTokenLine!)
            }
        }


        layout._attributedText = text
        layout._textContainer = container
        layout._range = range
        layout._framesetter = ctSetter
        layout._frame = ctFrame
        layout._textBoundingRect = textBoundingRect
        layout._lines = lines
        layout._isTruncation = isTruncation
        layout._textInsets = container.insets
        layout.truncationTokenLine = TruncationTokenLine

        if lineOrigins != nil {
            free(lineOrigins)
        }

        return layout
    }



    public override init(){
        super.init()
    }

    func draw(context: CGContext, rect: CGRect, point:CGPoint, targetView: UIView, targetLayer: CALayer) {
      
        autoreleasepool {
            var cPoint = point
            cPoint.x += _textInsets.left
            cPoint.y += _textInsets.top

            drawTextDecoracotion(layout: self, context: context, size: rect.size, point: cPoint)
            drawText(layout: self, context: context, size: rect.size, point: cPoint)
            drawAttachment(layout: self, context: context, size: rect.size, point: cPoint, targetView: targetView, targetLayer: targetLayer)
        }

    }

    func drawTextDecoracotion(layout: LHTextLayout, context: CGContext, size: CGSize, point: CGPoint) {

        let lines = layout.lines
        context.saveGState()
        context.translateBy(x: point.x, y: point.y)

        let isVertical = layout.textContainer.verticalForm
        //context.translateBy(x: <#T##CGFloat#>, y: <#T##CGFloat#>)
        for i in 0 ..< lines.count {
            var line = lines[i]
            if layout.truncationTokenLine != nil {
                if layout.truncationTokenLine!.index == line.index {
                    line = layout.truncationTokenLine!
                }
            }
            let runs = CTLineGetGlyphRuns(line.ctLine!)
            for r in 0 ..< CFArrayGetCount(runs) {
                let runRawPointer = CFArrayGetValueAtIndex(runs, r)
                let run = Unmanaged<AnyObject>.fromOpaque(runRawPointer!).takeUnretainedValue() as! CTRun
                let glyphCount = CTRunGetGlyphCount(run)
                if glyphCount == 0 {
                    continue
                }
                let attrs: NSDictionary = CTRunGetAttributes(run) as NSDictionary
                let underline = attrs[LHTextUnderlineStyleAttributeName] as? LHTextDecoration
                if underline == nil {
                    continue
                }

                var underlineStart = CGPoint.zero
                var length: CGFloat = 0

                if isVertical {
                    underlineStart.x = line.position.x - line.descent + size.width
                    length = line.bounds.size.height
                }else {
                    underlineStart.y = line.position.y + line.descent
                    underlineStart.x = point.x
                    length = line.bounds.size.width
                }
               drawLineStyle(context: context, length: length, lineWidth: underline!.width, style: underline!.style, position: underlineStart, color: underline!.color.cgColor, isVertical: isVertical)
            }
        }
         context.restoreGState()
    }


    func drawLineStyle(context: CGContext, length: CGFloat, lineWidth: CGFloat, style:LHTextUnderlineStyle, position: CGPoint, color: CGColor, isVertical: Bool) {
        context.saveGState()
        if isVertical {
            let toPoint = CGPoint.init(x: position.x, y: position.y + length)

            var w: CGFloat = lineWidth
            if style == .styleThick {
                w *= 2
            }

            context.setStrokeColor(color)
            context.setLineWidth(w)
            if style == .styleSingle {
                context.move(to: position)
                context.addLine(to: toPoint)
                context.strokePath()
            }else if style == .styleThick {
                context.move(to: position)
                context.addLine(to: toPoint)
                context.strokePath()
            }else if style == .styleDouble {
                context.move(to: position)
                context.addLine(to: toPoint)
                context.strokePath()

                context.move(to: CGPoint.init(x: position.x - 2, y: position.y))
                context.addLine(to: CGPoint.init(x: position.x - 2, y: position.y + length))
                context.strokePath()
            }

        }else{
            let toPoint = CGPoint.init(x: position.x + length, y: position.y)

            var w: CGFloat = lineWidth
            if style == .styleThick {
                w *= 2
            }

            context.setStrokeColor(color)
            context.setLineWidth(w)
            if style == .styleSingle {
                context.move(to: position)
                context.addLine(to: toPoint)
                context.strokePath()
            }else if style == .styleThick {
                context.move(to: position)
                context.addLine(to: toPoint)
                context.strokePath()
            }else if style == .styleDouble {
                context.move(to: position)
                context.addLine(to: toPoint)
                context.strokePath()

                context.move(to: CGPoint.init(x: position.x, y: position.y + 2))
                context.addLine(to: CGPoint.init(x: position.x + length, y: position.y + 2))
                context.strokePath()
            }

        }
        context.restoreGState()
    }





    func drawText(layout: LHTextLayout, context: CGContext, size: CGSize, point: CGPoint) {
        context.saveGState()

        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -size.height)
        context.textPosition = point

        let lines = layout.lines
        for i in 0 ..< layout.lines.count {
            var line = lines[i]
            if  line == layout.lines.last && truncationTokenLine != nil{
                line = truncationTokenLine!
            }
            let posX = line.position.x + point.x
            let posY = (size.height - line.position.y - point.y)

            let ctRuns = CTLineGetGlyphRuns(line.ctLine!)
            for k in 0 ..< CFArrayGetCount(ctRuns) {
                let runRawPointer = CFArrayGetValueAtIndex(ctRuns, k)
                let run = Unmanaged<AnyObject>.fromOpaque(runRawPointer!).takeUnretainedValue() as! CTRun
                context.textMatrix = CGAffineTransform.identity
                context.textPosition = CGPoint.init(x: posX, y: posY)
                var runRanges = Array<LHTextRotateRange>()
                if self.textContainer.verticalForm {
                   runRanges = line.runRanges[k]
                }
                self.drawRun(context: context, line: line, run: run, runRanges: runRanges, size: size, isVertical: layout.textContainer.verticalForm)

            }

        }

        context.restoreGState()
    }

    func drawRun(context: CGContext, line: LHTextLine, run: CTRun, runRanges: Array<LHTextRotateRange>, size: CGSize, isVertical: Bool) {

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

                let cfRange = CTRunGetStringRange(run)
                for i in 0 ..< CTRunGetGlyphCount(run) {
                    context.saveGState()
                    context.textMatrix = CGAffineTransform.identity
                    var CJK = false
                    for oneRange in runRanges {
                        let range = oneRange.range
                        if NSLocationInRange(i + cfRange.location, range) {
                            CJK = oneRange.vertical;
                            break
                        }
                    }

                    if  !CJK{
                        context.rotate(by:CGFloat(-90 * M_PI / 180))
                        let x = line.position.y - size.height + glyphPositions[i].x
                        let y = line.position.x -  glyphPositions[i].y + size.width
                        context.textPosition = CGPoint.init(x: x, y: y)

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

                if ment.content == nil {
                    continue
                }
                let content = ment.content!
                var rect = line.attachmentRects[i]
                if layout.textContainer.verticalForm {
                    rect.origin.x += size.width
                }

                rect = UIEdgeInsetsInsetRect(rect, ment.contentInsets)
                rect = rect.standardized
                rect.origin.x += point.x
                rect.origin.y += point.y


                if content.isKind(of: UIImage.classForCoder()) {
                    let cgImage = (content as! UIImage).cgImage
                    if cgImage != nil {
                        context.saveGState()
                        context.translateBy(x: 0, y: rect.maxY + rect.minY)
                        context.scaleBy(x: 1, y: -1)
                        context.draw(cgImage!, in: rect)
                        context.restoreGState()
                    }
                }else if content.isKind(of: UIView.classForCoder()){
                    let view  = content as! UIView
                    view.frame = rect
                    DispatchQueue.main.async {
                        targetView.addSubview(view)
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

extension LHTextLayout {
    func glyphIndex(at point: CGPoint) -> Int {
        var point = point
        
        point.y -= self.textInsets.top
        if textContainer.verticalForm {
            point.x -= self.textInsets.right
        }else{
            point.x -= self.textInsets.left
        }
        
        for line in self.lines {
            
            if line.bounds.contains(point) {
                return line.glyphIndex(at: point)
            }
        }
        return NSNotFound
    }
}
