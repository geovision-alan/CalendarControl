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
        self.calendar.enableAction = YES;
    }
    
    [self syncSelectedDateInfo];
    
    [self randomEventsDate];
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

- (void) randomEventsDate
{
    if (!self.calendar)
    {
        return;
    }
    
    [self.calendar clearEventsDate];
    
    NSDate* currentMonth = [self.calendar currentMonth];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* currentComponent = [calendar components:(NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:currentMonth];
    NSInteger year = [currentComponent year];
    NSInteger month = [currentComponent month];
    
    NSRange monthRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:currentMonth];
    NSMutableArray* dateComponents = [[NSMutableArray alloc] init];
    NSInteger randomCount = rand() % monthRange.length;
    for (NSInteger i = 0; i < randomCount; ++i)
    {
        NSInteger day = (rand() % monthRange.length) + monthRange.location;
        NSDateComponents* component = [[NSDateComponents alloc] init];
        
        [component setYear:year];
        [component setMonth:month];
        [component setDay:day];
        
        [dateComponents addObject:component];
        
        [component release];
    }
    
    [self.calendar setEventsDate:dateComponents];
    [dateComponents release];
}

- (IBAction) pressRandomEvents:(id)sender
{
    [self randomEventsDate];
}

@end
