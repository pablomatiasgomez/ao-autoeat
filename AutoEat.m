#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>
#include <stdlib.h>

@interface AutoEat : NSObject
@end

@implementation AutoEat {
}

static int const INTERVAL = 14 * 60;
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
    while(true) {
        [NSThread sleepForTimeInterval:10.0]; // Count every ten seconds..
        remainingSecs = INTERVAL - (time(NULL) - startedSecs);
        printf("Remaining: %ld seconds\n", remainingSecs);

        // once in 20th times (200s), click on a random place in the map.
        int random = arc4random_uniform(20);
        if (random == 0) {
            [self clickOnRandomPlace];
        }

        if (remainingSecs < 0) {
            [self eatAndDrink];
            startedSecs = time(NULL);
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
    CGPoint pt;
    pt.x = x;
    pt.y = y;
    click(pt);
}

void doubleClick(int x, int y) {
    printf("Double clicking at X: %d, Y:%d \n", x, y);
    CGPoint pt;
    pt.x = x;
    pt.y = y;
    click(pt);
    [NSThread sleepForTimeInterval:0.05]; // 50ms sleep
    click(pt);
}

void click(CGPoint pt) {
    CGPostMouseEvent(pt, 1, 1, 1);
    CGPostMouseEvent(pt, 1, 1, 0);
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
