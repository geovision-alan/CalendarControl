//
//  CalendarControlAppDelegate.h
//  CalendarControl
//
//

#import <Cocoa/Cocoa.h>

@class AFCalendarControl;

@interface CalendarControlAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet AFCalendarControl* calendar;
@property (assign) IBOutlet NSTextField* selectedDate;

@end
