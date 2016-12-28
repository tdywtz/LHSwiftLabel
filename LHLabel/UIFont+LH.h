//
//  UIFont+LH.h
//  chezhiwang
//
//  Created by bangong on 16/6/22.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (LH)
//行楷
+ (NSString *)fontNameSTXingkai_SC_Bold;
+ (void)asynchronouslySetFontName:(NSString *)fontName success:(void(^)(NSString *name))success;

@end
