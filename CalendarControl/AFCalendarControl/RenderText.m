//
//  RenderText.m
//  gcc
//
//  Created by alantseng on 13/7/10.
//  Copyright (c) 2013 GeoVision. All rights reserved.
//
#import "RenderText.h"

@implementation RenderText

+ (void) renderTextInFrame:(NSString*)text \
font:(NSFont*)font \
fontColor:(NSColor*)fontColor \
frame:(NSRect)frame
{
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, \
                                NSFontAttributeName, \
                                fontColor, \
                                NSForegroundColorAttributeName, \
                                nil];
    
    NSAttributedString* currentText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    [RenderText renderTextInFrameWithAttributes:currentText frame:frame];
    
    [currentText release];
}

+ (void) renderTextInFrameWithAttributes:(NSAttributedString*)attribute frame:(NSRect)frame
{
    NSPoint textPos = NSMakePoint(frame.origin.x + (frame.size.width * 0.5f), frame.origin.y + (frame.size.height * 0.5f));
    NSSize attrSize = [attribute size];
    textPos.x -= (attrSize.width * 0.5f);
    textPos.y -= (attrSize.height * 0.5f);
    [attribute drawAtPoint:textPos];
}

@end
