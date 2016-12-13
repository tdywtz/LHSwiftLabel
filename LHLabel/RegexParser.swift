//
//  RegexParser.swift
//  LHLabel
//
//  Created by bangong on 16/11/30.
//  Copyright © 2016年 luhai. All rights reserved.
//

import UIKit

let urlPattern = "(^|[\\s.:;?\\-\\]<\\(])" + "((https?://|www\\.|pic\\.)[-\\w;/?:@&=+$\\|\\_.!~*\\|'()\\[\\]%#,☺]+[\\w/#](\\(\\))?)" + "(?=$|[\\s',\\|\\(\\).:;?\\-\\[\\]>\\)])"

let emailPattern =  "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"




class RegexParser: NSObject {

    class func urlResults(text: String) -> [NSTextCheckingResult]? {

        let regular =  try? NSRegularExpression(pattern: urlPattern, options: [.caseInsensitive])
        let urlResults = regular?.matches(in: text, options: [], range: NSRange.init(location: 0, length: text.characters.count))

        return urlResults
    }

    class func emaileResult(text: String) -> Bool {
      return result(pattern: emailPattern, at: text)
    }

    class func result(pattern: String,at text: String) -> Bool {
         let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: text)
    }
}
