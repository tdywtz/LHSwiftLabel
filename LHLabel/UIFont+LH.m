//
//  UIFont+LH.m
//  chezhiwang
//
//  Created by bangong on 16/6/22.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "UIFont+LH.h"
#import <CoreText/CoreText.h>
#import "LHLabel-Swift.h"

@implementation UIFont (LH)
+ (UIColor *)HexColor:(NSString *)colorString
{
    unsigned long colorLong = strtoul(colorString.UTF8String, 0, 16);

    //通过位与方法获取三色值
    int R = (colorLong & 0xFF0000) >> 16;
    int G = (colorLong & 0x00FF00) >> 8;
    int B = colorLong & 0x0000FF;
    return [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:1.f];
}

+ (NSString *)fontNameSTXingkai_SC_Bold{
    return @"STXingkai-SC-Bold";
}

+ (void)asynchronouslySetFontName:(NSString *)fontName success:(void(^)(NSString *name))success
{

    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"我自横刀向天笑，去留肝胆两昆仑"];
    att.lh_font = [UIFont systemFontOfSize:15];
    att.lh_color = [UIColor redColor];

  

    UIFont* aFont = [UIFont fontWithName:fontName size:24];
    // If the font is already downloaded
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        // Go ahead and display the sample text.
        success(fontName);
        return;
    }

    // Create a dictionary with the font's PostScript name.
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    
    // Create a new font descriptor reference from the attributes dictionary.
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);
    
    __block BOOL errorDuringDownload = NO;
    
    // Start processing the font descriptor..
    // This function returns immediately, but can potentially take long time to process.
    // The progress is notified via the callback block of CTFontDescriptorProgressHandler type.
    // See CTFontDescriptor.h for the list of progress states and keys for progressParameter dictionary.
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        
        //NSLog( @"state %d - %@", state, progressParameter);
        
        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        
        if (state == kCTFontDescriptorMatchingDidBegin) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Show an activity indicator
                NSLog(@"Begin Matching");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinish) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Remove the activity indicator
                
                // Display the sample text for the newly downloaded font
                
                success(fontName);
                
                // Log the font URL in the console
                CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, 0., NULL);
                CFStringRef fontURL = CTFontCopyAttribute(fontRef, kCTFontURLAttribute);
                // NSLog(@"%@", (__bridge NSURL*)(fontURL));
                CFRelease(fontURL);
                CFRelease(fontRef);
                
                if (!errorDuringDownload) {
                    NSLog(@"%@ downloaded", fontName);
                }
            });
        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Show a progress bar
                
                NSLog(@"Begin Downloading");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Remove the progress bar
                
                NSLog(@"Finish downloading");
            });
        } else if (state == kCTFontDescriptorMatchingDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Use the progress bar to indicate the progress of the downloading
                NSLog(@"Downloading %.0f%% complete", progressValue);
            });
        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
            // An error has occurred.
            // Get the error message
            NSString *_errorMessage = nil;
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            if (error != nil) {
                _errorMessage = [error description];
            } else {
                _errorMessage = @"ERROR MESSAGE IS NOT AVAILABLE!";
            }
            // Set our flag
            errorDuringDownload = YES;
            
            dispatch_async( dispatch_get_main_queue(), ^ {
                NSLog(@"Download error: %@", _errorMessage);
            });
        }
        return (bool)YES;
    });
}

+ (NSString *)YYTextTruncationToken{
    return @"\u2026";
}

@end
