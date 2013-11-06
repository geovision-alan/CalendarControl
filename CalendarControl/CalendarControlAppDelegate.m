//
//  CalendarControlAppDelegate.m
//  CalendarControl
//
//

#import "CalendarControlAppDelegate.h"
#import "AFCalendarControl.h"

@implementation CalendarControlAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    if (self.calendar)
    {
        [self.calendar setSelectAction:self action:@selector(syncSelectedDateInfo)];
    }
    
    [self syncSelectedDateInfo];
}

- (void) syncSelectedDateInfo
{
    if (!self.calendar || !self.selectedDate)
    {
        return;
    }
    
    NSDate* selectedDate = [self.calendar currentMonth];
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [timeZone secondsFromGMTForDate:selectedDate];
    NSDate* local = [NSDate dateWithTimeInterval:seconds sinceDate:selectedDate];
    
    [self.selectedDate setStringValue:[local description]];
}

@end
