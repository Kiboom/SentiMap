//
//  SMTouchDownGestureRecognizer.m
//  SentiMap
//
//  Created by 김기범 on 2016. 4. 20..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import "SMTouchDownGestureRecognizer.h"

@implementation SMTouchDownGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action {
    if(self = [super initWithTarget:target action:action]) {
        self.delegate = target;
        self.action = action;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if(touches.count > 1) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    _touch = [touches anyObject];
    UIView *touchedView = ([_touch.view isMemberOfClass:[UIButton class]]) ? _touch.view.superview : _touch.view;   // to make '_touch.view' always be 'wheel container view".
    _currentAngle = [self getTouchAngle:[_touch locationInView:touchedView] fromView:touchedView] * 180/M_PI;
    if([self.delegate respondsToSelector:self.action]) {
        [self.delegate performSelector:self.action withObject:self];
    }
}

- (float)getTouchAngle:(CGPoint)touch fromView:(UIView *)touchedView {
    // translate to coordinate whose starting point is center of 'wheel container' view.
    float x = touch.x - touchedView.frame.size.width/2;
    float y = -(touch.y - touchedView.frame.size.width/2);
    
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
