//
//  AFCalendarControl.m
//  AFCalendarControl
//
//  Created by Keith Duncan on 12/08/2007.
//  Copyright 2007 thirty-three. All rights reserved.
//

#import "AFCalendarControl.h"
#import "AFGeometry.h"
#import "AFKeyValueBinding.h"

#import "AFCalendarControlCell.h"
#import "AFCalendarButton.h"

#import "NSBezierPath+Additions.h"
#import "NSDate+Additions.h"
#import "NSArray+Additions.h"
#import "NSString+Additions.h"
#import "AFMacro.h"

#import "AFConfiguration.h"
#import "RenderText.h"

NSString *const AFContentDatesBinding = @"contentDate";
NSString *const AFDateHighlightedBinding = @"highlightedDays";

NSSTRING_CONTEXT(AFCalendarControlCurrentMonthObservationContext);
NSSTRING_CONTEXT(AFCalendarControlContentObservationContext);
NSSTRING_CONTEXT(AFCalendarControlContentPropertyObservationContext);
NSSTRING_CONTEXT(AFCalendarControlSelectionObservationContext);

#define AFCALENDAR_MONTH_FORMAT    @"MMMM y"

@interface AFCalendarControl ()
@property (retain) NSMutableDictionary *bindingInfo;

@property (assign) NSUInteger selectedDay;
@end

@interface AFCalendarControl (Private)
+ (NSArray *)_dayNames;

- (void)_changeMonth:(id)sender;
- (void)_setSelectedDate:(NSDate *)date;
- (void)_setEdgeDateComponents:(NSDate *)date index:(NSUInteger)index;
@end

@interface AFCalendarControl (PrivateDrawing)
- (NSColor *)_textColor;
- (void)_drawTitleRect:(NSRect)titleRect;
- (void)_drawCalendarRect:(NSRect)calendarRect;
@end

@implementation AFCalendarControl

@synthesize bindingInfo=_bindingInfo;

@synthesize doubleAction=_doubleAction;

@synthesize enableAction = _enableAction;
@synthesize selectedDay=_selectedDay;
@synthesize highlightedDays=_highlightedDays;

+ (void)initialize {
	[self exposeBinding:AFCurrentMonthBinding];
	
	[self exposeBinding:NSContentBinding];
	[self exposeBinding:AFContentDatesBinding];
	
	[self exposeBinding:NSSelectedIndexBinding];
	[self exposeBinding:AFDateHighlightedBinding];
}

+ (Class)cellClass {
	return [AFCalendarControlCell class];
}

void _AFCalendarControlBoundsRects(NSRect bounds, NSRect *titleRect, NSRect *calendarRect) {
	NSDivideRect(bounds, titleRect, calendarRect, NSHeight(bounds)/4.8, NSMaxYEdge);
}

void _AFCalendarControlTitleFrames(NSRect titleBounds, NSRect *monthTitleFrame, NSRect *buttonFrames, NSRect *dayTitlesFrame) {
	NSDivideRect(titleBounds, monthTitleFrame, dayTitlesFrame, NSHeight(titleBounds)*(3.4/5.0), NSMaxYEdge);
	
	*monthTitleFrame = NSInsetRect(*monthTitleFrame, NSWidth(*monthTitleFrame)/14.0, NSHeight(*monthTitleFrame)/3.8);
	(*dayTitlesFrame).origin.y = NSMinY(titleBounds) + (NSHeight(titleBounds)/20.0);
	
	if (buttonFrames != NULL) {
		buttonFrames[0] = *monthTitleFrame;
		buttonFrames[0].size.width = NSMinX(*monthTitleFrame) - NSMinX(titleBounds);
		buttonFrames[0].origin.x = NSMinX(titleBounds) + ((1.0/2.0) * NSWidth(buttonFrames[0]));
		
		buttonFrames[1] = *monthTitleFrame;
		buttonFrames[1].size.width = NSMaxX(titleBounds) - NSMaxX(*monthTitleFrame);
		buttonFrames[1].origin.x = NSMaxX(*monthTitleFrame) - ((1.0/2.0) * NSWidth(buttonFrames[1]));
	}
}

NS_INLINE NSRect _AFDayRectForRowRect(NSRect rowRect, NSUInteger column, NSUInteger count) {
	NSRect dayRect = rowRect;
	dayRect.size.width = NSWidth(rowRect)/count;
	dayRect.origin.x = NSMinX(rowRect) + (NSWidth(dayRect) * column);
	return dayRect;
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
	if (self == nil) return nil;
	
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
	self.selectedDay = [components day];
	self.highlightedDays = [NSMutableIndexSet indexSet];
	
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	NSDateComponents *dateComponents = [calendar components:(NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
	[dateComponents setDay:self.selectedDay];
	[self setValue:[calendar dateFromComponents:dateComponents] forBinding:AFCurrentMonthBinding];
	
	NSRect titleFrame, calendarFrame;
	_AFCalendarControlBoundsRects([self bounds], &titleFrame, &calendarFrame);
	
	NSRect monthTitleRect, dayTitlesRect, buttonFrames[2];
	_AFCalendarControlTitleFrames(titleFrame, &monthTitleRect, buttonFrames, &dayTitlesRect);
	
	NSUInteger buttonAutoresizeMask = NSViewNotSizable;
	
	_directionButtons[0] = [[AFCalendarButton alloc] initWithFrame:NSIntegralRect(buttonFrames[0])];
	[_directionButtons[0] setAutoresizingMask:(buttonAutoresizeMask | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin | NSViewHeightSizable)];
	[[_directionButtons[0] cell] setDirection:AFCalendarButtonDirectionLeft];
	
	_directionButtons[1] = [[AFCalendarButton alloc] initWithFrame:NSIntegralRect(buttonFrames[1])];
	[_directionButtons[1] setAutoresizingMask:(buttonAutoresizeMask | NSViewMinXMargin | NSViewMinYMargin | NSViewMaxYMargin | NSViewHeightSizable)];
	[[_directionButtons[1] cell] setDirection:AFCalendarButtonDirectionRight];
	
	for (NSUInteger index = 0; index < 2; index++) {
		[_directionButtons[index] setTarget:self];
		[_directionButtons[index] setAction:@selector(_changeMonth:)];
		[self addSubview:_directionButtons[index]];
	}
	
    _monthFormatter = [[NSDateFormatter alloc] init];
    [_monthFormatter setLocale:[NSLocale currentLocale]];
    [_monthFormatter setCalendar:[NSCalendar currentCalendar]];
    [_monthFormatter setDateFormat:AFCALENDAR_MONTH_FORMAT];
    
    // Time/Locale change notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(systemClockDidChange:)
                                                 name:NSSystemClockDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(systemClockDidChange:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
    
    
    _selectAction = nil;
    _selectTarget = nil;
    
    _eventsDateComponents = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	for (NSString *currentBinding in self.bindingInfo) [self unbind:currentBinding];
	self.bindingInfo = nil;
    
	[_directionButtons[0] release];
	[_directionButtons[1] release];
	
	self.highlightedDays = nil;
	[_monthFormatter dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_eventsDateComponents)
    {
        [_eventsDateComponents release];
        _eventsDateComponents = nil;
    }

	[super dealloc];
}

- (void)systemClockDidChange:(NSNotification *)notification
{
    // The locale or day/time has changed
    // Update the calendar
    [self updateCalendar];
    

}


- (void)viewWillMoveToSuperview:(NSView *)view {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResignKeyNotification object:[[self superview] window]];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidBecomeKeyNotification object:[[self superview] window]];
	
	[super viewWillMoveToSuperview:view];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(display) name:NSWindowDidResignKeyNotification object:[view window]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(display) name:NSWindowDidBecomeKeyNotification object:[view window]];
}

- (NSDate *)selectedDate {
	NSArray *contentArray = [self valueForBinding:NSContentBinding];
	NSArray *selectedObjects = [contentArray objectsAtIndexes:[self valueForBinding:NSSelectedIndexBinding]];
	
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	
	if (AFArrayContainsIndex(selectedObjects, 0)) {
		id selectedObject = [selectedObjects objectAtIndex:0];
		
		id selectedDate = [selectedObject valueForKeyPath:[[self keyPathForBinding:AFContentDatesBinding] stringByRemovingKeyPathComponentAtIndex:0]];
		if (selectedDate != nil) return selectedDate;
		
		NSDateComponents *currentMonthDateComponents = [calendar components:(NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:self.currentMonth];
		[currentMonthDateComponents setDay:self.selectedDay];
		
		return [calendar dateFromComponents:currentMonthDateComponents];
	}
	
	return nil;
}

- (void)setSelectedDate:(NSDate *)date {
	[self setCurrentMonth:date];
	
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
	
	NSUInteger selectedDay = [dateComponents day];
	
	NSArray *contentArray = [self valueForBinding:NSContentBinding];
	NSString *contentDateKeyPath = [[self keyPathForBinding:AFContentDatesBinding] stringByRemovingKeyPathComponentAtIndex:0];
	
	if (contentArray != nil) for (id currentObject in contentArray) {
		NSDate *currentDate = [currentObject valueForKeyPath:contentDateKeyPath];
		
		NSDateComponents *currentDateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:currentDate];
		if (![currentDateComponents components:(NSMonthCalendarUnit | NSYearCalendarUnit) match:dateComponents]) continue;
		
		if ([currentDateComponents day] == selectedDay) {
			[self setValue:[NSNumber numberWithUnsignedInteger:[contentArray indexOfObject:currentObject]] forBinding:NSSelectedIndexBinding];
			break;
		}
	} else self.selectedDay = selectedDay;
}

- (NSDate *)currentMonth {
	return [self valueForBinding:AFCurrentMonthBinding];
}

- (void)setCurrentMonth:(NSDate *)month {
	[self setValue:month forBinding:AFCurrentMonthBinding];
}

- (void)setBoundaryDate:(NSDate *)date forEdge:(NSRectEdge)edge {
	if (edge == NSMinYEdge) {
		[self _setEdgeDateComponents:date index:0];
	} else if (edge == NSMaxYEdge) {
		[self _setEdgeDateComponents:date index:1];
	} else [NSException raise:NSInvalidArgumentException format:@"%s, %@, %@ valid values are NSMinYEdge and NSMaxYEdge.", __PRETTY_FUNCTION__, NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
}

- (void) setSelectAction:(id)target action:(SEL)action
{
    _selectAction = action;
    _selectTarget = target;
}

- (void) updateCalendar
{
    [_monthFormatter setLocale:[NSLocale currentLocale]];
    [_monthFormatter setCalendar:[NSCalendar currentCalendar]];
    [_monthFormatter setDateFormat:AFCALENDAR_MONTH_FORMAT];
    
    self.currentMonth = self.currentMonth;
}

- (void) clearEventsDate
{
    if (!_eventsDateComponents)
    {
        return;
    }
    
    [_eventsDateComponents removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void) setEventsDate:(NSArray*)eventsDate
{
    if (!_eventsDateComponents || !eventsDate)
    {
        return;
    }
    
    [_eventsDateComponents addObjectsFromArray:eventsDate];
    
    [self setNeedsDisplay];
}

NS_INLINE NSRectArray _AFCalendarControlCreateCalendarRowRects(NSRect calendarRect, NSUInteger rows) {
	CGFloat rowHeight = NSHeight(calendarRect)/rows;
	NSRect currentRowRect = NSMakeRect(NSMinX(calendarRect), NSMaxY(calendarRect) - rowHeight, NSWidth(calendarRect), rowHeight);
	
	NSRectArray rowRects = (NSRectArray)calloc(rows, sizeof(NSRect));
	
	for (NSUInteger index = 0; index < rows; index++) {
		rowRects[index] = currentRowRect;
		currentRowRect.origin.y -= rowHeight;
	}
	
	return rowRects;
}

- (void)drawRect:(NSRect)frame {
    //NSLog(@"Dibujando...");
    
	NSRect titleRect, calendarRect;
	_AFCalendarControlBoundsRects([self bounds], &titleRect, &calendarRect);
	
	NSBezierPath *backgroundPath = [NSBezierPath bezierPathWithRect:[self bounds]];
	
	BOOL drawKey = [[self window] isKeyWindow];
	
	NSGradient *titleGradient = nil;
	if (drawKey) {
        NSColor* beginColor = \
            [NSColor colorWithCalibratedRed:kDefaultCalendarKeyTitleBackgroundColorBegin[0] \
                                      green:kDefaultCalendarKeyTitleBackgroundColorBegin[1] \
                                      blue:kDefaultCalendarKeyTitleBackgroundColorBegin[2] \
                                      alpha:kDefaultCalendarKeyTitleBackgroundColorBegin[3]];
        NSColor* middleColor = \
            [NSColor colorWithCalibratedRed:kDefaultCalendarKeyTitleBackgroundColorMiddle[0] \
                                      green:kDefaultCalendarKeyTitleBackgroundColorMiddle[1] \
                                      blue:kDefaultCalendarKeyTitleBackgroundColorMiddle[2] \
                                      alpha:kDefaultCalendarKeyTitleBackgroundColorMiddle[3]];
        NSColor* endColor = \
            [NSColor colorWithCalibratedRed:kDefaultCalendarKeyTitleBackgroundColorEnd[0] \
                                      green:kDefaultCalendarKeyTitleBackgroundColorEnd[1] \
                                      blue:kDefaultCalendarKeyTitleBackgroundColorEnd[2] \
                                      alpha:kDefaultCalendarKeyTitleBackgroundColorEnd[3]];
		titleGradient = [[NSGradient alloc] initWithColorsAndLocations:
						 beginColor, 0.0,
						 middleColor, (NSHeight(titleRect)/NSHeight([self bounds])),
						 endColor, 1.0,
						 nil];
	} else {
        NSColor* beginColor = \
            [NSColor colorWithCalibratedRed:kDefaultCalendarNonKeyTitleBackgroundColorBegin[0] \
                                      green:kDefaultCalendarNonKeyTitleBackgroundColorBegin[1] \
                                      blue:kDefaultCalendarNonKeyTitleBackgroundColorBegin[2] \
                                      alpha:kDefaultCalendarNonKeyTitleBackgroundColorBegin[3]];
        NSColor* endColor = \
            [NSColor colorWithCalibratedRed:kDefaultCalendarNonKeyTitleBackgroundColorEnd[0] \
                                      green:kDefaultCalendarNonKeyTitleBackgroundColorEnd[1] \
                                      blue:kDefaultCalendarNonKeyTitleBackgroundColorEnd[2] \
                                      alpha:kDefaultCalendarNonKeyTitleBackgroundColorEnd[3]];
		titleGradient = [[NSGradient alloc] initWithStartingColor:beginColor endingColor:endColor];
	}
	[titleGradient drawInBezierPath:backgroundPath angle:kDefaultCalendarTitleBackgroundColorAngle];
	[titleGradient release];
	
	NSShadow *shadow = [[NSShadow alloc] init];
    NSColor* shadowColor = \
        [NSColor colorWithCalibratedRed:kDefaultCalendarTitleShadowColor[0] \
                                  green:kDefaultCalendarTitleShadowColor[1] \
                                  blue:kDefaultCalendarTitleShadowColor[2] \
                                  alpha:kDefaultCalendarTitleShadowColor[3]];
	[shadow setShadowColor:shadowColor];
	[shadow setShadowOffset:NSMakeSize(kDefaultCalendarTitleShadowOffset[0], \
                                       kDefaultCalendarTitleShadowOffset[1])];
	[shadow setShadowBlurRadius:kDefaultCalendarTitleShadowBlurRadius];
	
	[NSGraphicsContext saveGraphicsState];
	
	[shadow set];
	[shadow release];
	
	[self _drawTitleRect:titleRect];
	[NSGraphicsContext restoreGraphicsState];
	
	[self _drawCalendarRect:calendarRect];
    
    NSColor* pathColor = \
    [NSColor colorWithCalibratedRed:kDefaultCalendarBackgroundPathColor[0] \
                              green:kDefaultCalendarBackgroundPathColor[1] \
                              blue:kDefaultCalendarBackgroundPathColor[2] \
                              alpha:kDefaultCalendarBackgroundPathColor[3]];
    [pathColor set];
    [backgroundPath setLineWidth:kDefaultCalendarBackgroundPathWidth];
    [backgroundPath setLineCapStyle:NSRoundLineCapStyle];
    [backgroundPath setLineJoinStyle:NSRoundLineJoinStyle];

	[backgroundPath stroke];
}

- (void)resetCursorRects {
	NSRect titleRect, calendarRect;
	_AFCalendarControlBoundsRects([self bounds], &titleRect, &calendarRect);
	
	[self addCursorRect:calendarRect cursor:[NSCursor pointingHandCursor]];
}

- (void)mouseDown:(NSEvent *)event {
    if (!self.enableAction)
    {
        return;
    }
    
	NSPoint clickPoint = [self convertPoint:[event locationInWindow] fromView:nil];
	
	NSRect titleRect, calendarRect;
	_AFCalendarControlBoundsRects([self bounds], &titleRect, &calendarRect);
	
	if (!NSMouseInRect(clickPoint, calendarRect, [self isFlipped])) return;
	
	
	NSRectArray rowRects = _AFCalendarControlCreateCalendarRowRects(calendarRect, kDefaultCalenderShowWeekPerMonth);
	
	NSUInteger currentDay = 1;
	NSRange *currentRange = &(_calendarInfo.monthRanges[1]);
	if (_calendarInfo.firstWeekday != SUNDAY) {
		currentDay = _calendarInfo.monthRanges[0].length - _calendarInfo.firstWeekday + 2;
		currentRange = &(_calendarInfo.monthRanges[0]);
	}
	
	BOOL dayFound = NO;
	for (NSUInteger currentRow = 0; currentRow < kDefaultCalenderShowWeekPerMonth; currentRow++) {
		NSRect currentRowRect = rowRects[currentRow];
		
		for (NSUInteger currentColumn = 0; currentColumn < 7; currentColumn++, currentDay++) {
			NSRect dayRect = _AFDayRectForRowRect(currentRowRect, currentColumn, 7);
			if (NSMouseInRect(clickPoint, dayRect, [self isFlipped])) {
				dayFound = YES;
				break;
			}
			
			if (currentDay == (*currentRange).length) {
				currentDay = 0;
				currentRange++;
			}
		} if (dayFound) break;
	}
	
	free(rowRects);
	
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	NSInteger monthDifference = -(intptr_t)(&_calendarInfo.monthRanges[1] - currentRange);
	
	NSDate *currentMonthDate = [[self valueForBinding:AFCurrentMonthBinding] dateByAddingMonths:monthDifference];
	NSDateComponents *currentMonthDateComponents = [calendar components:(NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:currentMonthDate];
	[currentMonthDateComponents setDay:currentDay];
	
	[self _setSelectedDate:[calendar dateFromComponents:currentMonthDateComponents]];
    
    //NSLog(@"click, %d/%d/%d", [currentMonthDateComponents month], [currentMonthDateComponents day], [currentMonthDateComponents year]);
    if (_selectTarget && [_selectTarget respondsToSelector:_selectAction])
    {
        //[[NSApplication sharedApplication] sendAction:_selectAction to:_selectTarget from:self];
        [_selectTarget performSelector:_selectAction withObject:nil];
    }
    
	if (monthDifference != 0) return;
	
	if (self.doubleAction != NULL && [event clickCount] >= 2) {
		[[NSApplication sharedApplication] sendAction:self.doubleAction to:self.target from:self];
	}
}

- (void)keyDown:(NSEvent *)event {
    if (!self.enableAction)
    {
        return;
    }
	if ([event modifierFlags] & NSNumericPadKeyMask && [event modifierFlags] & NSCommandKeyMask) {
		NSInteger monthDelta = 0;
		switch ([event keyCode]) {
			case NSLeftArrowFunctionKey:
				monthDelta = -1;
				break;
			case NSRightArrowFunctionKey:
				monthDelta = 1;
				break;
		}
		
		[self setCurrentMonth:[[self valueForBinding:AFCurrentMonthBinding] dateByAddingMonths:monthDelta]];
	} else [super keyDown:event];
}

- (id)infoForBinding:(NSString *)binding {
	NSDictionary *bindingInfo = [_bindingInfo valueForKey:binding];
	return (bindingInfo != nil) ? bindingInfo : [super infoForBinding:binding];
}

- (void)setInfo:(id)info forBinding:(NSString *)binding {
	if (self.bindingInfo == nil)
		self.bindingInfo = [NSMutableDictionary dictionary];
	
	[self.bindingInfo setValue:info forKey:binding];
}

- (void *)contextForBinding:(NSString *)binding {
    
	if ([binding isEqualToString:AFCurrentMonthBinding]) return &AFCalendarControlCurrentMonthObservationContext;
	else if ([binding isEqualToString:NSContentBinding]) return &AFCalendarControlContentObservationContext;
	else if ([binding isEqualToString:AFContentDatesBinding]) return &AFCalendarControlContentPropertyObservationContext;
	else if ([binding isEqualToString:AFDateHighlightedBinding]) return &AFCalendarControlContentPropertyObservationContext;
	else if ([binding isEqualToString:NSSelectedIndexBinding]) return &AFCalendarControlSelectionObservationContext;
	else
        return nil;
}

- (Class)valueClassForBinding:(NSString *)binding {
	if ([binding isEqualToString:AFCurrentMonthBinding]) return [NSDate class];
	else if ([binding isEqualToString:NSContentBinding]) return [NSArray class];
	else if ([binding isEqualToString:AFContentDatesBinding]) return [NSString class];
	else if ([binding isEqualToString:AFDateHighlightedBinding]) return [NSString class];
	else if ([binding isEqualToString:NSSelectedIndexBinding]) return [NSNumber class];
	else return [super valueClassForBinding:binding];
}

- (void)bind:(NSString *)binding toObject:(id)observable withKeyPath:(NSString *)keyPath options:(NSDictionary *)options {
	if ([self infoForBinding:binding] != nil) [self unbind:binding];
	
	void *context = [self contextForBinding:binding];
	NSDictionary *bindingInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                 observable, NSObservedObjectKey,
                                 [[keyPath copy] autorelease], NSObservedKeyPathKey,
                                 [[options copy] autorelease], NSOptionsKey, nil];
	
	if ([binding isEqualToString:AFCurrentMonthBinding]) {
		[self setInfo:bindingInfo forBinding:binding];
		[observable addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:context];
	} else if ([binding isEqualToString:NSContentBinding]) {
		[self setInfo:bindingInfo forBinding:binding];
		[observable addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionNew) context:context];
	} else if ([binding isEqualToString:AFContentDatesBinding]) {
		[self setInfo:bindingInfo forBinding:binding];
		[observable addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:context];
	} else if ([binding isEqualToString:AFDateHighlightedBinding]) {
		[self setInfo:bindingInfo forBinding:binding];
		[observable addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:context];
	} else if ([binding isEqualToString:NSSelectedIndexBinding]) {
		[self setInfo:bindingInfo forBinding:binding];
		[observable addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:context];
	} else [super bind:binding toObject:observable withKeyPath:keyPath options:options];
	
	[self setNeedsDisplay:YES];
}

- (void)unbind:(NSString *)binding {
	id controller = [self controllerForBinding:binding];
	NSString *keyPath = [self keyPathForBinding:binding];
	
	if ([binding isEqualToString:AFCurrentMonthBinding]) {
		[controller removeObserver:self forKeyPath:keyPath];
		[self setInfo:nil forBinding:binding];
	} else if ([binding isEqualToString:NSContentBinding]) {
		[controller removeObserver:self forKeyPath:keyPath];
		[self setInfo:nil forBinding:binding];
	} else if ([binding isEqualToString:AFContentDatesBinding]) {
		[controller removeObserver:self forKeyPath:keyPath];
		[self setInfo:nil forBinding:binding];
	} else if ([binding isEqualToString:AFDateHighlightedBinding]) {
		[controller removeObserver:self forKeyPath:keyPath];
		[self setInfo:nil forBinding:binding];
	} else if ([binding isEqualToString:NSSelectedIndexBinding]) {
		[controller removeObserver:self forKeyPath:keyPath];
		[self setInfo:nil forBinding:binding];
	} else [super unbind:binding];
	
	[self setNeedsDisplay:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	NSDate *currentMonth = [self valueForBinding:AFCurrentMonthBinding];
	NSString *dateKeyPath = [[self keyPathForBinding:AFContentDatesBinding] stringByRemovingKeyPathComponentAtIndex:0];
	
    NSInteger calendarFirstWeekDay = [[NSCalendar currentCalendar] firstWeekday];
    
	if (context == &AFCalendarControlCurrentMonthObservationContext) {
		NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
		
		
		_calendarInfo.monthRanges[1] = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:currentMonth];
		NSDateComponents *currentMonthComponents = [calendar components:(NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:currentMonth];
		
		[currentMonthComponents setDay:_calendarInfo.monthRanges[1].location];
		_calendarInfo.firstWeekday = [[calendar components:NSWeekdayCalendarUnit fromDate:[calendar dateFromComponents:currentMonthComponents]] weekday];
		// offset to display later
        NSInteger weekPosition = _calendarInfo.firstWeekday - calendarFirstWeekDay ;
        if (weekPosition < 0 )
            weekPosition+=7;
        
        
        _calendarInfo.firstWeekday=weekPosition+1;
		[currentMonthComponents setDay:_calendarInfo.monthRanges[1].length];
		_calendarInfo.lastWeekday = [[calendar components:NSWeekdayCalendarUnit fromDate:[calendar dateFromComponents:currentMonthComponents]] weekday];
        weekPosition = _calendarInfo.lastWeekday - calendarFirstWeekDay ;
        if (weekPosition < 0 )
            weekPosition+=7;
        _calendarInfo.lastWeekday=weekPosition+1;

		
		
		NSDate *previousMonth = [currentMonth dateByAddingMonths:-1];
		_calendarInfo.monthRanges[0] = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:previousMonth];
		NSDate *nextMonth = [currentMonth dateByAddingMonths:1];
		_calendarInfo.monthRanges[2] = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:nextMonth];
        
	}
	
	if (context == &AFCalendarControlCurrentMonthObservationContext || context == &AFCalendarControlContentObservationContext || context == &AFCalendarControlContentPropertyObservationContext) {
		[self.highlightedDays removeAllIndexes];
		
		NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
		NSDateComponents *currentMonthComponents = [calendar components:(NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:currentMonth];
		NSString *dateHighlightedKeyPath = [[self keyPathForBinding:AFDateHighlightedBinding] stringByRemovingKeyPathComponentAtIndex:0];
		
		for (id currentObject in [self valueForBinding:NSContentBinding]) {
			NSDateComponents *currentDateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[currentObject valueForKeyPath:dateKeyPath]];
			
			[currentMonthComponents setDay:[currentDateComponents day]];
			if (![currentDateComponents isEqual:currentMonthComponents]) continue;
			
			if ([[currentObject valueForKeyPath:dateHighlightedKeyPath] boolValue]) [self.highlightedDays addIndex:[currentDateComponents day]];
		}
	} else if (context == &AFCalendarControlSelectionObservationContext) {
		id selectionIndex = [self valueForBinding:NSSelectedIndexBinding];
		NSUInteger index = [selectionIndex unsignedIntegerValue];
		
		id selectedObject = [[self valueForBinding:NSContentBinding] objectAtIndex:index];
		
		NSString *contentDateKeyPath = [[self keyPathForBinding:AFContentDatesBinding] stringByRemovingKeyPathComponentAtIndex:0];
		NSDate *selectedObjectDate = [selectedObject valueForKeyPath:contentDateKeyPath];
		
		NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
		NSDateComponents *selectedDateComponents = [calendar components:NSDayCalendarUnit fromDate:selectedObjectDate];
		self.selectedDay = [selectedDateComponents day];
	} else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	
	[self setNeedsDisplay:YES];
}

@end

@implementation AFCalendarControl (Private)

+ (NSArray *)_dayNames {
	static NSArray *_dayNames = nil;
	if (_dayNames != nil) return _dayNames;
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]]; 
	_dayNames = [[formatter shortWeekdaySymbols] copy];
	[formatter release];
	
	return _dayNames;
}

- (void)_changeMonth:(id)sender {
	[self _setSelectedDate:[[self valueForBinding:AFCurrentMonthBinding] dateByAddingMonths:[[sender cell] direction]]];
}

- (void)_setSelectedDate:(NSDate *)date {
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	NSDateComponents *dateComponents = [calendar components:(NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
	
	for (NSUInteger index = 0; index < 2; index++) {
		if (_edgeDateComponents[index] == nil) continue;
		
		BOOL edgeMonth = ([dateComponents year] == [_edgeDateComponents[index] year] && [dateComponents month] == [_edgeDateComponents[index] month]);
		[_directionButtons[index] setEnabled:!edgeMonth];
	}
	
	self.selectedDate = date;
}

- (void)_setEdgeDateComponents:(NSDate *)date index:(NSUInteger)index {
	[_edgeDateComponents[index] release];
	_edgeDateComponents[index] = [[[NSCalendar autoupdatingCurrentCalendar] components:(NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date] retain];
}

- (BOOL) checkHasEventDateComponents:(NSDateComponents*)date checkComponents:(NSUInteger)checkComponents
{
    if (!_eventsDateComponents)
    {
        return NO;
    }
    
    for (NSDateComponents* eventDate in _eventsDateComponents)
    {
        if ([eventDate components:checkComponents match:date])
        {
            return YES;
        }
    }
    
    return NO;
}

@end

@implementation AFCalendarControl (PrivateDrawing)

- (NSColor *)_textColor {
    return [NSColor colorWithCalibratedRed:kDefaultCalendarTitleTextColor[0] \
                                     green:kDefaultCalendarTitleTextColor[1] \
                                     blue:kDefaultCalendarTitleTextColor[2] \
                                     alpha:kDefaultCalendarTitleTextColor[3]];
}

- (void)_drawTitleRect:(NSRect)titleRect {
	// Draw contents
	NSRect monthTitleRect, dayTitlesRect;
	_AFCalendarControlTitleFrames(titleRect, &monthTitleRect, NULL, &dayTitlesRect);
  NSDate *currentMonth = [self valueForBinding:AFCurrentMonthBinding];
	
	//[[self _textColor] set];
    /* // descriptionWithCalendarFormat is deprecated.
	AKDrawStringAlignedInFrame([currentMonth descriptionWithCalendarFormat:@"%B %Y" timeZone:nil locale:[NSLocale currentLocale] ], [NSFont fontWithName:@"Helvetica Bold" size:1], NSCenterTextAlignment, NSIntegralRect(monthTitleRect));
     */

    
    // month year
	NSString *strMonth  =[[_monthFormatter stringFromDate:currentMonth] capitalizedString];
    NSFont* monYearFont = [NSFont fontWithName:kDefaultCalendarMonthYearFontName \
                                          size:kDefaultCalendarMonthYearFontSize];
    //AKDrawStringAlignedInFrame(strMonth, monYearFont, NSCenterTextAlignment, NSIntegralRect(monthTitleRect));
    [RenderText renderTextInFrame:strMonth \
                             font:monYearFont \
                             fontColor:[self _textColor] \
                             frame:NSIntegralRect(monthTitleRect)];
	
//	NSShadow *selectedTextShadow = [[NSShadow alloc] init];
//	[selectedTextShadow setShadowOffset:NSMakeSize(0, -2)];
//	[selectedTextShadow setShadowBlurRadius:3.0];
	
	NSArray *dayNames = [[self class] _dayNames];

    // day, monday to sunday
    NSFont* weekDayFont = [NSFont fontWithName:kDefaultCalendarWeekDayFontName \
                                          size:kDefaultCalendarWeekDayFontSize];
    NSUInteger firstDay = [[NSCalendar currentCalendar] firstWeekday];
    
    NSDate *now = [NSDate date];
    NSUInteger components = (NSWeekdayCalendarUnit);
    NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:components fromDate:now];
    NSInteger currentWeekDay = [nowComponents weekday];
    
    for (NSUInteger currentDay = 0; currentDay < [dayNames count]; currentDay++) {
        
        NSInteger dayIndex = currentDay + firstDay -1;
        if( dayIndex >=7)
            dayIndex -= 7;
		NSRect dayRect = _AFDayRectForRowRect(dayTitlesRect, currentDay, [dayNames count]);
		
		[NSGraphicsContext saveGraphicsState];
		
		//[[self _textColor] set];
		NSString *string = [[dayNames objectAtIndex:dayIndex] uppercaseString];
		
		//AKDrawStringAlignedInFrame(string, weekDayFont, NSCenterTextAlignment, dayRect);
        [RenderText renderTextInFrame:string \
                    font:weekDayFont \
                    fontColor:[self _textColor] \
                    frame:dayRect];
        
        if (currentWeekDay == (dayIndex+1))
        {
            NSColor* color = [NSColor colorWithDeviceRed:kDefaultCalendarWeekDayMarkColor[0] \
                                                   green:kDefaultCalendarWeekDayMarkColor[1] \
                                                    blue:kDefaultCalendarWeekDayMarkColor[2] \
                                                    alpha:kDefaultCalendarWeekDayMarkColor[3]];
            [color set];
            
            NSBezierPath* path = [NSBezierPath bezierPath];
            [path moveToPoint:NSMakePoint(NSMinX(dayRect) + kDefaultCalendarWeekDayMarkPadding, NSMinY(dayRect))];
            [path lineToPoint:NSMakePoint(NSMaxX(dayRect) - kDefaultCalendarWeekDayMarkPadding, NSMinY(dayRect))];
            
            [path setLineWidth:kDefaultCalendarWeekDayMarkLineWidth];
            [path setLineCapStyle:NSRoundLineCapStyle];
            [path setLineJoinStyle:NSRoundLineJoinStyle];
            [path stroke];
        }
		[NSGraphicsContext restoreGraphicsState];
	}
	
	//[selectedTextShadow release];
}

- (void)_drawCalendarRect:(NSRect)calendarRect {
    
                                                
	NSSize daySize = NSMakeSize(NSWidth(calendarRect)/7.0, NSHeight(calendarRect)/kDefaultCalenderShowWeekPerMonth);
	
	// Draw the calendar
	NSUInteger currentDay = 1;
	NSRange *currentRange = &(_calendarInfo.monthRanges[1]);
	if (_calendarInfo.firstWeekday != SUNDAY) {
		currentDay = _calendarInfo.monthRanges[0].length - _calendarInfo.firstWeekday + 2;
		currentRange = &(_calendarInfo.monthRanges[0]);
	}
	
	NSDate *now = [NSDate date];
	NSUInteger components = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
	
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	
	NSDateComponents *nowComponents = [calendar components:components fromDate:now];
	NSDateComponents *currentMonthComponents = [calendar components:components fromDate:[self currentMonth]];
	
	NSRectArray rowRects = _AFCalendarControlCreateCalendarRowRects(calendarRect, kDefaultCalenderShowWeekPerMonth);
	
    NSBezierPath* path = [NSBezierPath bezierPath];
	for (NSUInteger currentRow = 0; currentRow < kDefaultCalenderShowWeekPerMonth; currentRow++) {
		NSRect currentRowRect = rowRects[currentRow];
		
		CGRect dayRects[7];
		AFRectDivideEqually(NSRectToCGRect(currentRowRect), CGRectMinXEdge, 7, dayRects);
		
        BOOL drawLine = NO;
		for (NSUInteger currentColumn = SUNDAY-1; currentColumn < SATURDAY; currentColumn++, currentDay++) {
			NSRect currentDayRect = NSRectFromCGRect(dayRects[currentColumn]);
			BOOL inRange = (currentRange == &(_calendarInfo.monthRanges[1]));
			
			AFCalendarControlCell *cell = (AFCalendarControlCell *)[self cell];
			[currentMonthComponents setDay:currentDay];
			[cell setToday:(inRange && [currentMonthComponents components:components match:nowComponents])];
			
			[cell setEnabled:inRange];
			[cell setSelected:(inRange && currentDay == self.selectedDay)];
            [cell setHasEvent:[self checkHasEventDateComponents:currentMonthComponents checkComponents:components]];
			[cell setHighlighted:(inRange && [self.highlightedDays containsIndex:currentDay])];
			
			[cell setStringValue:[NSString stringWithFormat:@"%d", currentDay]];
			
			[cell drawWithFrame:currentDayRect inView:self];
            
            if (inRange)
            {
                if (drawLine)
                {
                    [path lineToPoint:NSMakePoint(NSMaxX(currentDayRect)-kDefaultCalendarKeyGridPathPadding, NSMinY(currentDayRect))];
                }
                else
                {
                    [path moveToPoint:NSMakePoint(NSMinX(currentDayRect)+kDefaultCalendarKeyGridPathPadding, NSMinY(currentDayRect))];
                    [path lineToPoint:NSMakePoint(NSMaxX(currentDayRect)-kDefaultCalendarKeyGridPathPadding, NSMinY(currentDayRect))];
                    drawLine = YES;
                }
            }
			
			if (currentDay == (*currentRange).length) {
				currentDay = 0;
				currentRange++;
			}
		}
	}
	
	free(rowRects);
	
	// Draw the grid
	{
		[NSGraphicsContext saveGraphicsState];
		
        NSColor* pathColor = nil;
		if ([[self window] isKeyWindow])
        {
            pathColor = [NSColor colorWithCalibratedRed:kDefaultCalendarKeyGridPathColor[0] \
                                                  green:kDefaultCalendarKeyGridPathColor[1] \
                                                   blue:kDefaultCalendarKeyGridPathColor[2] \
                                                  alpha:kDefaultCalendarKeyGridPathColor[3]];
        }
		else
        {
			pathColor = [NSColor colorWithCalibratedRed:kDefaultCalendarNonKeyGridPathColor[0] \
                                                  green:kDefaultCalendarNonKeyGridPathColor[1] \
                                                   blue:kDefaultCalendarNonKeyGridPathColor[2] \
                                                  alpha:kDefaultCalendarNonKeyGridPathColor[3]];
        }
    
        [path setLineWidth:kDefaultCalendarKeyGridPathWidth];
		[pathColor set];
        
        [path setLineCapStyle:NSRoundLineCapStyle];
        [path setLineJoinStyle:NSRoundLineJoinStyle];
		[path stroke];
		
		[NSGraphicsContext restoreGraphicsState];
	}
}

@end
