#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>
#include <stdlib.h>

@interface AutoEat : NSObject
@end

@implementation AutoEat {
}

// A random number between these two will be used as interval
static int const MIN_INTERVAL = 10 * 60;
static int const MAX_INTERVAL = 17 * 60;
/*
// These are the normal parameters if the virtual box windows is 1:1 (800x600)
static int const VIRTUALBOX_X_OFFSET = 440;
static int const VIRTUALBOX_Y_OFFSET = 200;
static int const INVENTORY_FIRST_ROW_Y = 180;
static int const INVENTORY_SECOND_ROW_Y = 210;
static int const INVENTORY_FIRST_COL_X = 610;
static int const INVENTORY_SECOND_COL_X = 640;
static int const MAIN_WINDOW_START_X = 20;
static int const MAIN_WINDOW_END_X = 540;
static int const MAIN_WINDOW_START_Y = 150;
static int const MAIN_WINDOW_END_Y = 560;
*/
// These are the offsets given that the virtual box window is 1:0.5 (400x300)
static int const VIRTUALBOX_X_OFFSET = 440 + (400/2);
static int const VIRTUALBOX_Y_OFFSET = 200 + (300/2);
static int const INVENTORY_FIRST_ROW_Y = 180 / 2;
static int const INVENTORY_SECOND_ROW_Y = 210 / 2;
static int const INVENTORY_FIRST_COL_X = 610 / 2;
static int const INVENTORY_SECOND_COL_X = 640 / 2;
static int const MAIN_WINDOW_START_X = 20 / 2;
static int const MAIN_WINDOW_END_X = 540 / 2;
static int const MAIN_WINDOW_START_Y = 150 / 2;
static int const MAIN_WINDOW_END_Y = 560 / 2;


-(id)init {
    printf("Starting AutoEat\n");

    long startedSecs = time(NULL);
    long remainingSecs;
    long interval = arc4random_uniform(MAX_INTERVAL - MIN_INTERVAL) + MIN_INTERVAL;
    while(true) {
        [NSThread sleepForTimeInterval:10.0]; // Count every ten seconds..
        remainingSecs = interval - (time(NULL) - startedSecs);
        printf("Remaining: %ld seconds\n", remainingSecs);

        // once in 20th times (200s), click on a random place in the map.
        int random = arc4random_uniform(20);
        if (random == 0) {
            [self clickOnRandomPlace];
        }

        if (remainingSecs < 0) {
            [self eatAndDrink];
            startedSecs = time(NULL);
            // Redefine interval
            interval = arc4random_uniform(MAX_INTERVAL - MIN_INTERVAL) + MIN_INTERVAL;
        }
    }
}

-(void)clickOnRandomPlace {
    int randomX = arc4random_uniform(MAIN_WINDOW_END_X - MAIN_WINDOW_START_X) + MAIN_WINDOW_START_X;
    int randomY = arc4random_uniform(MAIN_WINDOW_END_Y - MAIN_WINDOW_START_Y) + MAIN_WINDOW_START_Y;
    printf("Clicking on random place at x: %d y: %d !\n", randomX, randomY);
    [NSThread sleepForTimeInterval:2.0]; // 2s sleep
    singleClick(VIRTUALBOX_X_OFFSET + randomX, VIRTUALBOX_Y_OFFSET + randomY);
}

-(void)eatAndDrink {
    printf("Eating and drinking!\n");
    [NSThread sleepForTimeInterval:2.0]; // 2s sleep
    doubleClick(VIRTUALBOX_X_OFFSET + INVENTORY_FIRST_COL_X, VIRTUALBOX_Y_OFFSET + INVENTORY_FIRST_ROW_Y); // Comida: 1 columna, 1 fila
    [NSThread sleepForTimeInterval:2.0]; // 2s sleep
    doubleClick(VIRTUALBOX_X_OFFSET + INVENTORY_SECOND_COL_X, VIRTUALBOX_Y_OFFSET + INVENTORY_FIRST_ROW_Y); // Comida: 2 columna, 1 fila
    // Tomamos una pota roja.
    [NSThread sleepForTimeInterval:2.0]; // 2s sleep
    doubleClick(VIRTUALBOX_X_OFFSET + INVENTORY_FIRST_COL_X, VIRTUALBOX_Y_OFFSET + INVENTORY_SECOND_ROW_Y); // Pota roja: 1 columna, 2 fila
}

void singleClick(int x, int y) {
    printf("Single clicking at X: %d, Y:%d \n", x, y);
    click(CGPointMake(x, y), 1);
}

void doubleClick(int x, int y) {
    printf("Double clicking at X: %d, Y:%d \n", x, y);
    click(CGPointMake(x, y), 2);
}

void click(CGPoint pt, int clickCount) {
    CGEventRef theEvent = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDown, pt, kCGMouseButtonLeft);
    CGEventPost(kCGHIDEventTap, theEvent);
    CGEventSetType(theEvent, kCGEventLeftMouseUp);
    CGEventPost(kCGHIDEventTap, theEvent);
    if (clickCount == 2) {
        [NSThread sleepForTimeInterval:0.03];
        CGEventSetIntegerValueField(theEvent, kCGMouseEventClickState, 2);
        CGEventSetType(theEvent, kCGEventLeftMouseDown);
        CGEventPost(kCGHIDEventTap, theEvent);
        CGEventSetType(theEvent, kCGEventLeftMouseUp);
        CGEventPost(kCGHIDEventTap, theEvent);
    }
    CFRelease(theEvent);
}

@end


int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
    // int x = [args integerForKey:@"x"];
    // int y = [args integerForKey:@"y"];
    AutoEat *autoEat = [[AutoEat alloc] init];
    
    [pool release];
    return 0;
}

