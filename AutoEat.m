#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>
#import <Cocoa/Cocoa.h>
#include <stdlib.h>

@interface AutoEat : NSObject
@end

@implementation AutoEat {
}

// A random number between these two will be used as interval
static int const MIN_INTERVAL = 10 * 60;
static int const MAX_INTERVAL = 17 * 60;

static int const VIRTUALBOX_SCREEN_SIZE_X = 400;
static int const VIRTUALBOX_SCREEN_SIZE_Y = 300;

/* These are based on a 800x600 screen so they need to be converted using the above props of the actual windows screen size */
static int const INVENTORY_FIRST_ROW_Y = 194    * VIRTUALBOX_SCREEN_SIZE_X / 800;
static int const INVENTORY_SECOND_ROW_Y = 224   * VIRTUALBOX_SCREEN_SIZE_Y / 600;
static int const INVENTORY_FIRST_COL_X = 612    * VIRTUALBOX_SCREEN_SIZE_X / 800;
static int const INVENTORY_SECOND_COL_X = 644   * VIRTUALBOX_SCREEN_SIZE_Y / 600;

static int const MAIN_WINDOW_START_X = 20   * VIRTUALBOX_SCREEN_SIZE_X / 800;
static int const MAIN_WINDOW_END_X = 540    * VIRTUALBOX_SCREEN_SIZE_X / 800;
static int const MAIN_WINDOW_START_Y = 150  * VIRTUALBOX_SCREEN_SIZE_Y / 600;
static int const MAIN_WINDOW_END_Y = 560    * VIRTUALBOX_SCREEN_SIZE_Y / 600;

static int virtualBoxScreenStartX;
static int virtualBoxScreenStartY;


+(void)initialize {
    NSRect rect = [[NSScreen mainScreen] visibleFrame];
    int screenWidth = (int) rect.size.width;
    int screenHeight = (int) rect.size.height;
    int menuBarHeight = [NSStatusBar systemStatusBar].thickness;

    // The visibleFrame returns the application's widnows size (without the menun bar and the dock) so we need to then include the menuBarHeight.
    virtualBoxScreenStartX = (screenWidth - VIRTUALBOX_SCREEN_SIZE_X) / 2;
    virtualBoxScreenStartY = (screenHeight - VIRTUALBOX_SCREEN_SIZE_Y) / 2 + menuBarHeight;
}


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
    singleClick(virtualBoxScreenStartX + randomX, virtualBoxScreenStartY + randomY);
}

-(void)eatAndDrink {
    printf("Eating and drinking!\n");
    // Random offset to avoid clicking at the same place every time...
    int xRandomOffset = arc4random_uniform(8) - 4;
    int yRandomOffset = arc4random_uniform(8) - 4;
    [NSThread sleepForTimeInterval:2.0]; // 2s sleep

    // Comida: 1 columna, 1 fila
    doubleClick(virtualBoxScreenStartX + INVENTORY_FIRST_COL_X  + xRandomOffset, virtualBoxScreenStartY + INVENTORY_FIRST_ROW_Y  + yRandomOffset);
    [NSThread sleepForTimeInterval:2.0]; // 2s sleep

    // Comida: 2 columna, 1 fila
    doubleClick(virtualBoxScreenStartX + INVENTORY_SECOND_COL_X + xRandomOffset, virtualBoxScreenStartY + INVENTORY_FIRST_ROW_Y  + yRandomOffset);
    [NSThread sleepForTimeInterval:2.0]; // 2s sleep

    // Pota roja: 1 columna, 2 fila
    doubleClick(virtualBoxScreenStartX + INVENTORY_FIRST_COL_X  + xRandomOffset, virtualBoxScreenStartY + INVENTORY_SECOND_ROW_Y + yRandomOffset);
}

void singleClick(int x, int y) {
    printf("Single clicking at X: %d, Y:%d \n", x, y);
    click(CGPointMake(x, y), 1);
    [NSThread sleepForTimeInterval:0.01];
}

void doubleClick(int x, int y) {
    printf("Double clicking at X: %d, Y:%d \n", x, y);
    click(CGPointMake(x, y), 2);
    [NSThread sleepForTimeInterval:0.01];
}

void click(CGPoint pt, int clickCount) {
    CGEventRef theEvent = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDown, pt, kCGMouseButtonLeft);
    CGEventPost(kCGHIDEventTap, theEvent);
    CGEventSetType(theEvent, kCGEventLeftMouseUp);
    CGEventPost(kCGHIDEventTap, theEvent);
    if (clickCount == 2) {
        [NSThread sleepForTimeInterval:0.05];
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

