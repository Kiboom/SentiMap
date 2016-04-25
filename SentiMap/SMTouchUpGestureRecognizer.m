//
//  SMTouchUpGestureRecognizer.m
//  SentiMap
//
//  Created by 김기범 on 2016. 4. 20..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import "SMTouchUpGestureRecognizer.h"

@implementation SMTouchUpGestureRecognizer

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
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
}


@end
