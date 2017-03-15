//
//  UIFont+LH.h
//  chezhiwang
//
//  Created by bangong on 16/6/22.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCGL.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue &0xFF00) >>8))/255.0 blue:((float)(rgbValue &0xFF))/255.0 alpha:1.0]

@interface UIFont (LH)
+ (UIColor *)HexColor:(NSString *)colorString;
//行楷
+ (NSString *)fontNameSTXingkai_SC_Bold;
+ (void)asynchronouslySetFontName:(NSString *)fontName success:(void(^)(NSString *name))success;
+ (NSString *)YYTextTruncationToken;
@end
