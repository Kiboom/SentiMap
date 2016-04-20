//
//  SMWheelGestureRecognizer.m
//  SentiMap
//
//  Created by 김기범 on 2016. 4. 20..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import "SMWheelGestureRecognizer.h"

@implementation SMWheelGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action {
    if(self=[super initWithTarget:target action:action]) {
        self.delegate = target;
        self.action = action;
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if(touches.count > 1){
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    self.touch = [touches anyObject];
    
    self.currentAngle = [self getTouchAngle:[self.touch locationInView:self.touch.view]];
    self.previousAngle = [self getTouchAngle:[self.touch previousLocationInView:self.touch.view]];
    
    if([self.delegate respondsToSelector:self.action]) {
        [self.delegate performSelector:self.action withObject:self];
    }
}


- (float)getTouchAngle:(CGPoint)touch {
    // translate to coordinate whose starting point is center of 'wheel container' view.
    float x = touch.x - 150;
    float y = -(touch.y - 150);
    
    // to avoid divide by 0
    if (y == 0) {
        if (x > 0) {
            return M_PI_2;
        }
        return 3 * M_PI_2;
    }
    
    float arctan = atanf(x/y);
    // x,y is in 1st quadrant
    if((x>=0) && (y>0)) {
        return arctan;
    }
    // x,y is in 2nd quadrant
    else if ((x<0) && (y>0)) {
        return arctan + 2 * M_PI;
    }
    // x,y is in 3rd quadrant
    else if ((x<=0) && (y<0)) {
        return arctan + M_PI;
    }
    // x,y is in 4th quadrant
    else if ((x>0) && (y<0)) {
        return arctan + M_PI;
    }
    return -1;
}


@end
