//
//  AFCalendarControlCell.m
//  AFCalendarControl
//
//  Created by Keith Duncan on 02/09/2007.
//  Copyright 2007 thirty-three. All rights reserved.
//

#import "AFCalendarControlCell.h"

//#import "AmberKit/AmberKit+Additions.h"
#import "AFGeometry.h"
#import "NSBezierPath+Additions.h"

#import "AFConfiguration.h"
#import "RenderText.h"

@interface AFCalendarControlCell (PrivateDrawing)
- (NSColor *)_textColor;
- (NSColor *)_shadowColor;
- (void)_drawBezelWithFrame:(NSRect)frame inView:(NSView *)view;
@end

@implementation AFCalendarControlCell

@synthesize today=_today, selected=_selected;
@synthesize hasEvent = _hasEvent;

- (id)init {
	self = [super init];
	
    NSFont* font = [NSFont fontWithName:kDefaultCalendarMonthDayFontName \
                                   size:kDefaultCalendarMonthDayFontSize];
	[self setFont:font];
    
    _hasEvent = NO;
	
	return self;
}

- (NSRect)titleRectForBounds:(NSRect)bounds {
	NSRect drawingRect;
	
	drawingRect = [self drawingRectForBounds:bounds];
	drawingRect = NSInsetRect(drawingRect, 0.0, NSHeight(drawingRect)/5.0);
	
	return drawingRect;
}

- (void)drawWithFrame:(NSRect)frame inView:(NSView *)view {
	[self _drawBezelWithFrame:frame inView:view];
	[super drawWithFrame:frame inView:view];
}

- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)view {
	[NSGraphicsContext saveGraphicsState];
	
	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowColor:[self _shadowColor]];
	[shadow setShadowOffset:NSMakeSize(kDefaultCalendarGridShadowOffset[0], \
                                       kDefaultCalendarGridShadowOffset[1])];
	[shadow setShadowBlurRadius:kDefaultCalendarGridShadowBlurRadius];
	[shadow set];
	
	NSRect textBounds = [self titleRectForBounds:frame];
    // shift for vertically center text
    textBounds.origin.y += textBounds.size.height * 0.2f;
    textBounds.size.height -= textBounds.size.height * 0.2f;
	//[[self _textColor] set];
	//AKDrawStringAlignedInFrame([self stringValue], [self font], NSCenterTextAlignment, textBounds);
    [RenderText renderTextInFrame:[self stringValue] \
                             font:[self font] \
                             fontColor:[self _textColor] \
                             frame:textBounds];
	
	if ([self isHighlighted]) {
        
                
		NSRect dotRect = frame;
		dotRect.size.height = NSMinY(textBounds) - NSMinY(frame);
		CGRect cgdotRect = AFRectCenteredSquare(NSRectToCGRect(dotRect), NSHeight(dotRect) * (1.5/3.0));
        dotRect.origin.x = cgdotRect.origin.x;
        dotRect.origin.y = cgdotRect.origin.y;
        dotRect.size.width = cgdotRect.size.width;
        dotRect.size.height = cgdotRect.size.height; 
		[[self _textColor] set];
		[[NSBezierPath bezierPathWithOvalInRect:dotRect] fill];
        
      
	}
	
	[shadow release];
	
	[NSGraphicsContext restoreGraphicsState];
}

@end

@implementation AFCalendarControlCell (PrivateDrawing)

- (NSColor *)_textColor {
    if ([self isSelected])
    {
        return [NSColor colorWithCalibratedRed:kDefaultCalendarSelectGridTextColor[0] \
                                         green:kDefaultCalendarSelectGridTextColor[1] \
                                         blue:kDefaultCalendarSelectGridTextColor[2] \
                                         alpha:kDefaultCalendarSelectGridTextColor[3]];
    }
    else if ([self isToday])
    {
        return [NSColor colorWithCalibratedRed:kDefaultCalendarTodayGridTextColor[0] \
                                         green:kDefaultCalendarTodayGridTextColor[1] \
                                         blue:kDefaultCalendarTodayGridTextColor[2] \
                                         alpha:kDefaultCalendarTodayGridTextColor[3]];
    }
    else if ([self isEnabled])
    {
        return [NSColor colorWithCalibratedRed:kDefaultCalendarEnableGridTextColor[0] \
                                         green:kDefaultCalendarEnableGridTextColor[1] \
                                         blue:kDefaultCalendarEnableGridTextColor[2] \
                                         alpha:kDefaultCalendarEnableGridTextColor[3]];
    }
	else
    {
        return [NSColor colorWithCalibratedRed:kDefaultCalendarDisableGridTextColor[0] \
                                         green:kDefaultCalendarDisableGridTextColor[1] \
                                         blue:kDefaultCalendarDisableGridTextColor[2] \
                                         alpha:kDefaultCalendarDisableGridTextColor[3]];
    }
}

- (NSColor *)_shadowColor {
    if ([self isSelected])
    {
        return [NSColor colorWithCalibratedRed:kDefaultCalendarSelectGridShadowColor[0] \
                                         green:kDefaultCalendarSelectGridShadowColor[1] \
                                         blue:kDefaultCalendarSelectGridShadowColor[2] \
                                         alpha:kDefaultCalendarSelectGridShadowColor[3]];
    }
    else if ([self isToday])
    {
        return [NSColor colorWithCalibratedRed:kDefaultCalendarTodayGridShadowColor[0] \
                                         green:kDefaultCalendarTodayGridShadowColor[1] \
                                         blue:kDefaultCalendarTodayGridShadowColor[2] \
                                         alpha:kDefaultCalendarTodayGridShadowColor[3]];
    }
    else if ([self isEnabled])
    {
        return [NSColor colorWithCalibratedRed:kDefaultCalendarEnableGridShadowColor[0] \
                                         green:kDefaultCalendarEnableGridShadowColor[1] \
                                         blue:kDefaultCalendarEnableGridShadowColor[2] \
                                         alpha:kDefaultCalendarEnableGridShadowColor[3]];
    }
	else
    {
        return [NSColor colorWithCalibratedRed:kDefaultCalendarDisableGridShadowColor[0] \
                                         green:kDefaultCalendarDisableGridShadowColor[1] \
                                         blue:kDefaultCalendarDisableGridShadowColor[2] \
                                         alpha:kDefaultCalendarDisableGridShadowColor[3]];
    }
}

- (void)_applyTodayShadow:(NSBezierPath *)bezel {
	NSShadow *interiorShadow = [[NSShadow alloc] init];
    NSColor* shadowColor = [NSColor colorWithCalibratedRed:kDefaultCalendarTodayGridInteriorShadowColor[0] \
                                                     green:kDefaultCalendarTodayGridInteriorShadowColor[1] \
                                                     blue:kDefaultCalendarTodayGridInteriorShadowColor[2] \
                                                     alpha:kDefaultCalendarTodayGridInteriorShadowColor[3]];
	[interiorShadow setShadowColor:shadowColor];
	[interiorShadow setShadowBlurRadius:kDefaultCalendarTodayGridInteriorShadowRadius];
	
	// Bottom and left sides
	[interiorShadow setShadowOffset:NSMakeSize(NSWidth([bezel bounds])/kDefaultCalendarTodayGridInteriorShadowOffset[0], \
                                               NSHeight([bezel bounds])/kDefaultCalendarTodayGridInteriorShadowOffset[1])];
	[bezel applyInnerShadow:interiorShadow];
	
	// Top and right sides
	[interiorShadow setShadowOffset:NSMakeSize(-NSWidth([bezel bounds])/kDefaultCalendarTodayGridInteriorShadowOffset[2], \
                                               -NSHeight([bezel bounds])/kDefaultCalendarTodayGridInteriorShadowOffset[3])];
	[bezel applyInnerShadow:interiorShadow];
	
	[interiorShadow release];
}

- (void)_drawBezelWithFrame:(NSRect)frame inView:(NSView *)view {
	if (![self isEnabled]) return;
	
	BOOL drawKey = [[view window] isKeyWindow];
	
    NSRect markFrame = frame;
    CGFloat radius = MIN(markFrame.size.width, markFrame.size.height);
    markFrame.size.width  = radius * kDefaultCalendarMarkerOvalScaleFactor;
    markFrame.size.height = radius * kDefaultCalendarMarkerOvalScaleFactor;
    markFrame.origin.x = frame.origin.x + (frame.size.width - markFrame.size.width) * 0.5f;
    markFrame.origin.y = frame.origin.y + (frame.size.height - markFrame.size.height) * 0.5f;
    
    if ([self isSelected]) {
        
        NSBezierPath* bezel = [NSBezierPath bezierPathWithOvalInRect:markFrame];
        
        if (drawKey) {
            NSColor* color = [NSColor colorWithCalibratedRed:kDefaultCalendarKeySelectedGridColor[0] \
                                                       green:kDefaultCalendarKeySelectedGridColor[1] \
                                                        blue:kDefaultCalendarKeySelectedGridColor[2] \
                                                       alpha:kDefaultCalendarKeySelectedGridColor[3]];
            [color set];
        } else {
            NSColor* color = [NSColor colorWithCalibratedRed:kDefaultCalendarNonKeySelectedGridColor[0] \
                                                       green:kDefaultCalendarNonKeySelectedGridColor[1] \
                                                        blue:kDefaultCalendarNonKeySelectedGridColor[2] \
                                                       alpha:kDefaultCalendarNonKeySelectedGridColor[3]];
            [color set];
        }
        
        [bezel fill];
    }
    
    if ([self isToday]) {
        if (drawKey) {
            NSColor* color = [NSColor colorWithCalibratedRed:kDefaultCalendarKeyTodayGridColor[0] \
                                                       green:kDefaultCalendarKeyTodayGridColor[1] \
                                                        blue:kDefaultCalendarKeyTodayGridColor[2] \
                                                       alpha:kDefaultCalendarKeyTodayGridColor[3]];
            [color set];
        } else {
            NSColor* color = [NSColor colorWithCalibratedRed:kDefaultCalendarNonKeyTodayGridColor[0] \
                                                       green:kDefaultCalendarNonKeyTodayGridColor[1] \
                                                        blue:kDefaultCalendarNonKeyTodayGridColor[2] \
                                                       alpha:kDefaultCalendarNonKeyTodayGridColor[3]];
            [color set];
        }
        
        NSPoint start = NSMakePoint(NSMinX(frame), NSMinY(frame) + kDefaultCalendarKeyTodayMarkLineWidth);
        NSPoint end = NSMakePoint(NSMaxX(frame), NSMinY(frame) + kDefaultCalendarKeyTodayMarkLineWidth);
        
        NSBezierPath* path = [NSBezierPath bezierPath];
        [path moveToPoint:start];
        [path lineToPoint:end];
        [path setLineWidth:kDefaultCalendarKeyTodayMarkLineWidth];
        [path setLineCapStyle:NSRoundLineCapStyle];
        [path setLineJoinStyle:NSRoundLineJoinStyle];
        [path stroke];
    }
    
    if (![self isToday] && ![self isSelected]) { /* the cell is enabled */
        
		if (drawKey) {
            NSColor* color = [NSColor colorWithCalibratedRed:kDefaultCalendarKeyGridColor[0] \
                                                       green:kDefaultCalendarKeyGridColor[1] \
                                                       blue:kDefaultCalendarKeyGridColor[2] \
                                                       alpha:kDefaultCalendarKeyGridColor[3]];
            [color set];
		} else {
			NSColor* color = [NSColor colorWithCalibratedRed:kDefaultCalendarNonKeyGridColor[0] \
                                                       green:kDefaultCalendarNonKeyGridColor[1] \
                                                       blue:kDefaultCalendarNonKeyGridColor[2] \
                                                       alpha:kDefaultCalendarNonKeyGridColor[3]];
            [color set];
		}
	}
    
    if (_hasEvent)
    {
        NSRect eventMarkFrame;
        eventMarkFrame.size.width  = radius * kDefaultCalendarEventMarkerOvalScaleFactor;
        eventMarkFrame.size.height = radius * kDefaultCalendarEventMarkerOvalScaleFactor;
        eventMarkFrame.origin.x = frame.origin.x + (frame.size.width - eventMarkFrame.size.width) * 0.5f;
        eventMarkFrame.origin.y = frame.origin.y + (frame.size.height - eventMarkFrame.size.height) * 0.5f;
        NSBezierPath* eventBezel = [NSBezierPath bezierPathWithOvalInRect:eventMarkFrame];
        
        NSColor* eventMakrColor = [NSColor colorWithCalibratedRed:kDefaultCalendarEventGridMarkColor[0] \
                                                            green:kDefaultCalendarEventGridMarkColor[1] \
                                                             blue:kDefaultCalendarEventGridMarkColor[2] \
                                                             alpha:kDefaultCalendarEventGridMarkColor[3]];
        [eventMakrColor set];
        [eventBezel setLineWidth:kDefaultCalendarEventGridMarkLineWidth];
        [eventBezel stroke];
    }
}

@end
