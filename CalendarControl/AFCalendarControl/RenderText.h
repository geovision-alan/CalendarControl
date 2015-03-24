//
//  RenderText.h
//  gcc
//
//  Created by alantseng on 13/7/10.
//  Copyright (c) 2013 GeoVision. All rights reserved.
//

#import <Foundation/Foundation.h>

// the NSAttributedString texture rendering utility to render text in a frame rect
@interface RenderText : NSObject

+ (void) renderTextInFrame:(NSString*)text \
font:(NSFont*)font \
fontColor:(NSColor*)fontColor \
frame:(NSRect)frame;

+ (void) renderTextInFrameWithAttributes:(NSAttributedString*)attribute \
frame:(NSRect)frame;

@end
