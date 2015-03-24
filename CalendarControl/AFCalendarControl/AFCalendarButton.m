//
//  AFCalendarButton.m
//  AFCalendarControl
//
//  Created by Keith Duncan on 30/06/2007.
//  Copyright 2007 thirty-three. All rights reserved.
//
#import "AFGeometry.h"
#import "AFCalendarButton.h"

@implementation AFCalendarButton

+ (Class)cellClass {
	return [KDCalendarButtonCell class];
}

@end

@implementation KDCalendarButtonCell

@synthesize direction=_direction;

- (void)drawWithFrame:(NSRect)frame inView:(NSView *)view {
	if (self.direction == AFCalendarButtonDirectionLeft) {
		NSAffineTransform *flip = [NSAffineTransform transform];
		[flip translateXBy:NSWidth(frame) yBy:0.0];
		[flip scaleXBy:-1.0 yBy:1.0];
		[flip concat];
	}
	
	CGFloat squareSize = MIN(NSWidth(frame), NSHeight(frame)), delta = squareSize/5.0;
    
	CGRect cgArrowRect= AFRectCenteredSquare(NSRectToCGRect(frame), squareSize);
	NSRect arrowRect;
    arrowRect.origin.x = cgArrowRect.origin.x;
    arrowRect.origin.y = cgArrowRect.origin.y;
    arrowRect.size.width = cgArrowRect.size.width;
    arrowRect.size.height = cgArrowRect.size.height; 
    arrowRect = NSIntegralRect( NSInsetRect(arrowRect, delta, (delta*1.1)) );
    //float round = 5.0f;
    float lineWidth = 2.0f;
	NSBezierPath *arrowPath = [NSBezierPath bezierPath];
    [arrowPath moveToPoint:NSMakePoint(NSMinX(arrowRect), NSMinY(arrowRect))];
    [arrowPath lineToPoint:NSMakePoint(NSMaxX(arrowRect), NSMidY(arrowRect))];
    [arrowPath lineToPoint:NSMakePoint(NSMinX(arrowRect), NSMaxY(arrowRect))];
    [arrowPath setLineWidth:lineWidth];
    [arrowPath setLineJoinStyle:NSRoundLineJoinStyle];
    [arrowPath setLineCapStyle:NSRoundLineCapStyle];
//	[arrowPath moveToPoint:NSMakePoint(NSMinX(arrowRect), NSMinY(arrowRect))];
//	[arrowPath lineToPoint:NSMakePoint(NSMinX(arrowRect), NSMaxY(arrowRect))];
//	[arrowPath lineToPoint:NSMakePoint(NSMinX(arrowRect)+(NSWidth(arrowRect)*0.85), NSMidY(arrowRect))];
//	[arrowPath closePath];
	
	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowColor:[NSColor whiteColor]];
	[shadow setShadowOffset:NSMakeSize(0, -1)];
	
    
    float color[4] = {0.1215f, 0.1215f, 0.1215f, 1.0f};
	NSColor *arrowColor = [NSColor colorWithDeviceRed:color[0] green:color[1] blue:color[2] alpha:color[3]];
	if ([self isHighlighted]) arrowColor = [arrowColor blendedColorWithFraction:0.3 ofColor:[NSColor blackColor]];
	
	[NSGraphicsContext saveGraphicsState];
	
	[shadow set];
	[arrowColor set];
	[arrowPath stroke];
	
	[NSGraphicsContext restoreGraphicsState];
	[shadow release];
}

@end
