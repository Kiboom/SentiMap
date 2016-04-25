//
//  SMTouchUpGestureRecognizer.h
//  SentiMap
//
//  Created by 김기범 on 2016. 4. 20..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UITouch.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@protocol SMTouchUpGestureRecognizerDelegate <UIGestureRecognizerDelegate>
@end

@interface SMTouchUpGestureRecognizer : UIGestureRecognizer
@property SEL action;
@end
