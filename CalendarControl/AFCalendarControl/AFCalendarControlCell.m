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

- (id)init {
	self = [super init];
	
    NSFont* font = [NSFont fontWithName:k_default_calendar_month_day_font_name \
                                   size:k_default_calendar_month_day_font_size];
	[self setFont:font];
	
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
	[shadow setShadowOffset:NSMakeSize(k_default_calendar_grid_shadow_offset[0], \
                                       k_default_calendar_grid_shadow_offset[1])];
	[shadow setShadowBlurRadius:k_default_calendar_grid_shadow_blur_radius];
	[shadow set];
	
	NSRect textBounds = [self titleRectForBounds:frame];
	
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
        return [NSColor colorWithCalibratedRed:k_default_calendar_select_grid_text_color[0] \
                                         green:k_default_calendar_select_grid_text_color[1] \
                                         blue:k_default_calendar_select_grid_text_color[2] \
                                         alpha:k_default_calendar_select_grid_text_color[3]];
    }
    else if ([self isToday])
    {
        return [NSColor colorWithCalibratedRed:k_default_calendar_today_grid_text_color[0] \
                                         green:k_default_calendar_today_grid_text_color[1] \
                                         blue:k_default_calendar_today_grid_text_color[2] \
                                         alpha:k_default_calendar_today_grid_text_color[3]];
    }
    else if ([self isEnabled])
    {
        return [NSColor colorWithCalibratedRed:k_default_calendar_enable_grid_text_color[0] \
                                         green:k_default_calendar_enable_grid_text_color[1] \
                                         blue:k_default_calendar_enable_grid_text_color[2] \
                                         alpha:k_default_calendar_enable_grid_text_color[3]];
    }
	else
    {
        return [NSColor colorWithCalibratedRed:k_default_calendar_disable_grid_text_color[0] \
                                         green:k_default_calendar_disable_grid_text_color[1] \
                                         blue:k_default_calendar_disable_grid_text_color[2] \
                                         alpha:k_default_calendar_disable_grid_text_color[3]];
    }
}

- (NSColor *)_shadowColor {
    if ([self isSelected])
    {
        return [NSColor colorWithCalibratedRed:k_default_calendar_select_grid_shadow_color[0] \
                                         green:k_default_calendar_select_grid_shadow_color[1] \
                                         blue:k_default_calendar_select_grid_shadow_color[2] \
                                         alpha:k_default_calendar_select_grid_shadow_color[3]];
    }
    else if ([self isToday])
    {
        return [NSColor colorWithCalibratedRed:k_default_calendar_today_grid_shadow_color[0] \
                                         green:k_default_calendar_today_grid_shadow_color[1] \
                                         blue:k_default_calendar_today_grid_shadow_color[2] \
                                         alpha:k_default_calendar_today_grid_shadow_color[3]];
    }
    else if ([self isEnabled])
    {
        return [NSColor colorWithCalibratedRed:k_default_calendar_enable_grid_shadow_color[0] \
                                         green:k_default_calendar_enable_grid_shadow_color[1] \
                                         blue:k_default_calendar_enable_grid_shadow_color[2] \
                                         alpha:k_default_calendar_enable_grid_shadow_color[3]];
    }
	else
    {
        return [NSColor colorWithCalibratedRed:k_default_calendar_disable_grid_shadow_color[0] \
                                         green:k_default_calendar_disable_grid_shadow_color[1] \
                                         blue:k_default_calendar_disable_grid_shadow_color[2] \
                                         alpha:k_default_calendar_disable_grid_shadow_color[3]];
    }
}

- (void)_applyTodayShadow:(NSBezierPath *)bezel {
	NSShadow *interiorShadow = [[NSShadow alloc] init];
    NSColor* shadowColor = [NSColor colorWithCalibratedRed:k_default_calendar_today_grid_interior_shadow_color[0] \
                                                     green:k_default_calendar_today_grid_interior_shadow_color[1] \
                                                     blue:k_default_calendar_today_grid_interior_shadow_color[2] \
                                                     alpha:k_default_calendar_today_grid_interior_shadow_color[3]];
	[interiorShadow setShadowColor:shadowColor];
	[interiorShadow setShadowBlurRadius:k_default_calendar_today_grid_interior_shadow_radius];
	
	// Bottom and left sides
	[interiorShadow setShadowOffset:NSMakeSize(NSWidth([bezel bounds])/k_default_calendar_today_grid_interior_shadow_offset[0], \
                                               NSHeight([bezel bounds])/k_default_calendar_today_grid_interior_shadow_offset[1])];
	[bezel applyInnerShadow:interiorShadow];
	
	// Top and right sides
	[interiorShadow setShadowOffset:NSMakeSize(-NSWidth([bezel bounds])/k_default_calendar_today_grid_interior_shadow_offset[2], \
                                               -NSHeight([bezel bounds])/k_default_calendar_today_grid_interior_shadow_offset[3])];
	[bezel applyInnerShadow:interiorShadow];
	
	[interiorShadow release];
}

- (void)_drawBezelWithFrame:(NSRect)frame inView:(NSView *)view {
	if (![self isEnabled]) return;
	
    NSRect markFrame = frame;
    CGFloat radius = MIN(markFrame.size.width, markFrame.size.height);
    markFrame.size.width  = radius * k_default_calendar_marker_oval_scale_factor;
    markFrame.size.height = radius * k_default_calendar_marker_oval_scale_factor;
    markFrame.origin.x = frame.origin.x + (frame.size.width - markFrame.size.width) * 0.5f;
    markFrame.origin.y = frame.origin.y + (frame.size.height - markFrame.size.height) * 0.5f;
	NSBezierPath* bezel = [NSBezierPath bezierPathWithOvalInRect:markFrame];
	
	BOOL drawKey = [[view window] isKeyWindow];
	
	if ([self isToday] && [self isSelected]) {
		if (drawKey) {
			NSColor* color = [NSColor colorWithCalibratedRed:k_default_calendar_key_today_and_selected_grid_color[0] \
                                                       green:k_default_calendar_key_today_and_selected_grid_color[1] \
                                                       blue:k_default_calendar_key_today_and_selected_grid_color[2] \
                                                       alpha:k_default_calendar_key_today_and_selected_grid_color[3]];
            [color set];
		} else {
			NSColor* color = [NSColor colorWithCalibratedRed:k_default_calendar_non_key_today_and_selected_grid_color[0] \
                                                       green:k_default_calendar_non_key_today_and_selected_grid_color[1] \
                                                       blue:k_default_calendar_non_key_today_and_selected_grid_color[2] \
                                                       alpha:k_default_calendar_non_key_today_and_selected_grid_color[3]];
            [color set];
		}
		
		[bezel fill];
		//[self _applyTodayShadow:bezel];
	} else if ([self isToday] && ![self isSelected]){
		if (drawKey) {
			NSColor* color = [NSColor colorWithCalibratedRed:k_default_calendar_key_today_grid_color[0] \
                                                       green:k_default_calendar_key_today_grid_color[1] \
                                                       blue:k_default_calendar_key_today_grid_color[2] \
                                                       alpha:k_default_calendar_key_today_grid_color[3]];
            [color set];
		} else {
			NSColor* color = [NSColor colorWithCalibratedRed:k_default_calendar_non_key_today_grid_color[0] \
                                                       green:k_default_calendar_non_key_today_grid_color[1] \
                                                       blue:k_default_calendar_non_key_today_grid_color[2] \
                                                       alpha:k_default_calendar_non_key_today_grid_color[3]];
            [color set];
		}
		
		[bezel fill];
		//[self _applyTodayShadow:bezel];
	} else if (![self isToday] && [self isSelected]) {
		if (drawKey) {
			
			//
			// The following non-today selected gradient was written by Jonathan Dann
			//
			
			NSColor *baseColor = [NSColor colorWithCalibratedRed:k_default_calendar_key_selected_grid_base_color[0] \
                                                       green:k_default_calendar_key_selected_grid_base_color[1] \
                                                       blue:k_default_calendar_key_selected_grid_base_color[2] \
                                                       alpha:k_default_calendar_key_selected_grid_base_color[3]];
			NSColor *finalHighlightColor = [NSColor colorWithCalibratedRed:k_default_calendar_key_selected_grid_base_highlight_color[0] \
                                                       green:k_default_calendar_key_selected_grid_base_highlight_color[1] \
                                                       blue:k_default_calendar_key_selected_grid_base_highlight_color[2] \
                                                       alpha:k_default_calendar_key_selected_grid_base_highlight_color[3]];
			NSColor *baseHiglightColor = [NSColor colorWithCalibratedRed:k_default_calendar_key_selected_grid_final_highlight_color[0] \
                                                       green:k_default_calendar_key_selected_grid_final_highlight_color[1] \
                                                       blue:k_default_calendar_key_selected_grid_final_highlight_color[2] \
                                                       alpha:k_default_calendar_key_selected_grid_final_highlight_color[3]];
			
			NSGradient *gradient = \
                [[NSGradient alloc] initWithColorsAndLocations:baseColor, \
                                                               k_default_calendar_key_selected_grid_base_color_location, \
                                                               baseHiglightColor, \
                                                               k_default_calendar_key_selected_grid_base_highlight_color_location, \
                                                               finalHighlightColor, \
                                                               k_default_calendar_key_selected_grid_final_highlight_color_location, \
                                                               nil];
			[gradient drawInBezierPath:bezel angle:k_default_calendar_key_selected_grid_color_angle];
			[gradient release];
		} else {
			NSColor *baseColor = [NSColor colorWithCalibratedRed:k_default_calendar_non_key_selected_grid_base_color[0] \
                                                       green:k_default_calendar_non_key_selected_grid_base_color[1] \
                                                       blue:k_default_calendar_non_key_selected_grid_base_color[2] \
                                                       alpha:k_default_calendar_non_key_selected_grid_base_color[3]];
			NSColor *finalHighlightColor = [NSColor colorWithCalibratedRed:k_default_calendar_non_key_selected_grid_base_highlight_color[0] \
                                                       green:k_default_calendar_non_key_selected_grid_base_highlight_color[1] \
                                                       blue:k_default_calendar_non_key_selected_grid_base_highlight_color[2] \
                                                       alpha:k_default_calendar_non_key_selected_grid_base_highlight_color[3]];
			NSColor *baseHiglightColor = [NSColor colorWithCalibratedRed:k_default_calendar_non_key_selected_grid_final_highlight_color[0] \
                                                       green:k_default_calendar_non_key_selected_grid_final_highlight_color[1] \
                                                       blue:k_default_calendar_non_key_selected_grid_final_highlight_color[2] \
                                                       alpha:k_default_calendar_non_key_selected_grid_final_highlight_color[3]];
			
			NSGradient *gradient = \
                [[NSGradient alloc] initWithColorsAndLocations:baseColor, \
                                                               k_default_calendar_non_key_selected_grid_base_color_location, \
                                                               baseHiglightColor, \
                                                               k_default_calendar_non_key_selected_grid_base_highlight_color_location, \
                                                               finalHighlightColor, \
                                                               k_default_calendar_non_key_selected_grid_final_highlight_color_location, \
                                                               nil];
			[gradient drawInBezierPath:bezel angle:k_default_calendar_non_key_selected_grid_color_angle];
			[gradient release];
		}
	} else if (![self isToday] && ![self isSelected]) { /* the cell is enabled */
		if (drawKey) {
            NSColor* color = [NSColor colorWithCalibratedRed:k_default_calendar_key_grid_color[0] \
                                                       green:k_default_calendar_key_grid_color[1] \
                                                       blue:k_default_calendar_key_grid_color[2] \
                                                       alpha:k_default_calendar_key_grid_color[3]];
            [color set];
			[bezel fill];
		} else {
			NSColor* color = [NSColor colorWithCalibratedRed:k_default_calendar_non_key_grid_color[0] \
                                                       green:k_default_calendar_non_key_grid_color[1] \
                                                       blue:k_default_calendar_non_key_grid_color[2] \
                                                       alpha:k_default_calendar_non_key_grid_color[3]];
            [color set];
			[bezel fill];
		}
	}
}

@end
