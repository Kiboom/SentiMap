//
//  SMTouchDownGestureRecognizer.h
//  SentiMap
//
//  Created by 김기범 on 2016. 4. 20..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface SMTouchDownGestureRecognizer : UIGestureRecognizer
@property SEL action;
@property UITouch *touch;
@property CGFloat currentAngle;
@end
