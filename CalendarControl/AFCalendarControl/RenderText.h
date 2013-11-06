//
//  RenderText.h
//
//  Created by alantseng on 13/7/10.
//  Copyright (c) 2013年 Geovision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RenderText : NSObject

+ (void) renderTextInFrame:(NSString*)text \
                      font:(NSFont*)font \
                      fontColor:(NSColor*)fontColor \
                      frame:(NSRect)frame;

@end
