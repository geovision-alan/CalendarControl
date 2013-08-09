//
//  RenderText.m
//
//  Created by alantseng on 13/7/10.
//  Copyright (c) 2013. All rights reserved.
//
#import "RenderText.h"

@implementation RenderText

+ (void) renderTextInFrame:(NSString*)text \
                      font:(NSFont*)font \
                      fontColor:(NSColor*)fontColor \
                      frame:(NSRect)frame
{
    //[[NSColor greenColor] set];
    //NSRectFill(frame);
    NSDictionary* attributes = \
        [NSDictionary dictionaryWithObjectsAndKeys:font, \
                                                   NSFontAttributeName, \
                                                   fontColor, \
                                                   NSForegroundColorAttributeName, \
                                                   nil];

    NSAttributedString* currentText = \
        [[NSAttributedString alloc] initWithString:text attributes:attributes];

    NSPoint textPos = NSMakePoint(frame.origin.x + (frame.size.width * 0.5f), \
                                  frame.origin.y);
    NSSize attrSize = [currentText size];
    textPos.x -= (attrSize.width * 0.5f);
    //textPos.y -= (attrSize.height * 0.5f);
    [currentText drawAtPoint:textPos];
    
    [currentText release];
}

@end
