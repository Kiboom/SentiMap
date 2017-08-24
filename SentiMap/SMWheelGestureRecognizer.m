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
    _touch = [touches anyObject];
    UIView *touchedView = ([_touch.view isMemberOfClass:[UIButton class]]) ? _touch.view.superview : _touch.view;   // to make 'touchedView' always be 'wheel container view".
    CGFloat currentAngle = [self getTouchAngle:[_touch locationInView:touchedView] fromView:touchedView];
    CGFloat previousAngle = [self getTouchAngle:[_touch previousLocationInView:touchedView] fromView:touchedView];
    _rotateDirection = (currentAngle - previousAngle) * 180/M_PI;
    
    if([self.delegate respondsToSelector:self.action]) {
        [self.delegate performSelector:self.action withObject:self];
    }
}


- (float)getTouchAngle:(CGPoint)touch fromView:(UIView *)touchedView {
    float x = touch.x - touchedView.frame.size.width/2;
    float y = -(touch.y - touchedView.frame.size.width/2);
    
    // 0으로 나누는 것 방지
    if (y == 0) {
        if (x > 0) {
            return M_PI_2;
        }
        return 3 * M_PI_2;
    }
    
    float arctan = atanf(x/y);
    
    // x,y가 1사분면
    if((x>=0) && (y>0)) {
        return arctan;
    }
    // x,y가 2사분면
    else if ((x<0) && (y>0)) {
        return arctan + 2 * M_PI;
    }
    // x,y가 3사분면
    else if ((x<=0) && (y<0)) {
        return arctan + M_PI;
    }
    // x,y가 4사분면
    else if ((x>0) && (y<0)) {
        return arctan + M_PI;
    }
    return -1;
}


@end
