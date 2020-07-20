#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>
#include <stdlib.h>

@interface AutoControl : NSObject
@end

@implementation AutoControl {
}

// A random number between these two will be used as interval
static int const MIN_INTERVAL = 10 * 60;
static int const MAX_INTERVAL = 17 * 60;

-(id)init {
    printf("Starting AutoControl\n");
    while(true) {
        // TODO use random.
        [NSThread sleepForTimeInterval:1.0]; // 1 sec 
        pressControl();
    }
}

void pressControl() {
    CGEventRef a = CGEventCreateKeyboardEvent(NULL, 0x3B, true);
    CGEventRef b = CGEventCreateKeyboardEvent(NULL, 0x3B, false);
    CGEventPost(kCGHIDEventTap, a);
    CGEventPost(kCGHIDEventTap, b);
    CFRelease(a);
    CFRelease(b);
}


@end


int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
    // int x = [args integerForKey:@"x"];
    // int y = [args integerForKey:@"y"];
    AutoControl *autoControl = [[AutoControl alloc] init];
    
    [pool release];
    return 0;
}

