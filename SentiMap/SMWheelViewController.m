//
//  SMWheelViewController.m
//  SentiMap
//
//  Created by 김기범 on 2016. 4. 20..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import "SMWheelViewController.h"

@interface SMWheelViewController ()
@end

@implementation SMWheelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMoodInfo];
    self.wheelGestureRecognizer = [[SMWheelGestureRecognizer alloc] initWithTarget:self action:@selector(didWheelGesture:)];
    [self.wheelContainer addGestureRecognizer:self.wheelGestureRecognizer];
    _isWheelTouched = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initializeMoodInfo {
    NSDictionary *joy = @{@"num":@1, @"text":@"JOY", @"color":[UIColor colorWithRed:(199/255.f) green:(154/255.f) blue:(23/255.f) alpha:1.0], @"image":[UIImage imageNamed:@"joy"]};
    NSDictionary *tired = @{@"num":@2, @"text":@"TIRED", @"color":[UIColor colorWithRed:(114/255.f) green:(80/255.f) blue:(46/255.f) alpha:1.0], @"image":[UIImage imageNamed:@"tired"]};
    NSDictionary *fun = @{@"num":@3, @"text":@"FUN", @"color":[UIColor colorWithRed:(199/255.f) green:(87/255.f) blue:(25/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"fun"]};
    NSDictionary *angry = @{@"num":@4, @"text":@"ANGRY", @"color":[UIColor colorWithRed:(194/255.f) green:(46/255.f) blue:(66/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"angry"]};
    NSDictionary *surprised = @{@"num":@5, @"text":@"SURPRISED", @"color":[UIColor colorWithRed:(208/255.f) green:(94/255.f) blue:(142/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"surprised"]};
    NSDictionary *scared = @{@"num":@6, @"text":@"SCARED", @"color":[UIColor colorWithRed:(117/255.f) green:(62/255.f) blue:(146/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"scared"]};
    NSDictionary *sad = @{@"num":@7, @"text":@"SAD", @"color":[UIColor colorWithRed:(79/255.f) green:(111/255.f) blue:(217/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"sad"]};
    NSDictionary *excited = @{@"num":@8, @"text":@"EXCITED", @"color":[UIColor colorWithRed:(90/255.f) green:(212/255.f) blue:(194/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"excited"]};
    _moodInfo = [[NSArray alloc] initWithObjects:joy, tired, fun, angry, surprised, scared, sad, excited, nil];
}


- (void)didWheelGesture:(SMWheelGestureRecognizer *)recognizer {
    CGPoint touchPos = [recognizer.touch locationInView:self.wheelContainer];
    if([recognizer state] == UIGestureRecognizerStateEnded) {
        return;
    }
    if([self isMoodPosExposerTouched:touchPos]) {
        return;
    }
    CGFloat direction = recognizer.currentAngle - recognizer.previousAngle;
    [self updateWheelRotateAngle:direction];
    [self rotateWheel:direction];
    [self giveAnimationToMood];
    [self updateCurrentMood];
}


- (void)updateWheelRotateAngle:(CGFloat)direction {
    _wheelRotateAngle += 180 * direction / M_PI;
    if(_wheelRotateAngle < -0.5) {
        _wheelRotateAngle += 360;
    }
    else if(_wheelRotateAngle > 359.5) {
        _wheelRotateAngle -= 360;
    }
}


- (void)rotateWheel:(CGFloat)direction {
    CGAffineTransform newTransform = CGAffineTransformRotate(self.wheelGlow.transform, direction);
    [self.wheelGlow setTransform:newTransform];
}


- (void)giveAnimationToMood {
    
}


- (void)updateCurrentMood {
    if(_isWheelTouched == NO) {
        return;
    }
    [self giveAnimationToMood];
    NSInteger index = _wheelRotateAngle/45;
    _moodLabel.text = [(NSDictionary *)_moodInfo[index] objectForKey:@"text"];
    _moodLabel.textColor = [(NSDictionary *)_moodInfo[index] objectForKey:@"color"];
    _moodColor.image = [(NSDictionary *)_moodInfo[index] objectForKey:@"image"];
    _chosenMood = [(NSDictionary *)_moodInfo[index] objectForKey:@"num"];
}


// determine touch priority between two overlayered views (moodPosExposer and wheel)
- (BOOL)isMoodPosExposerTouched:(CGPoint)touchPos {
    if(_isMoodPosesTouched){
        return YES;
    }
    CGPoint wheelPos = self.moodColor.center;
    CGFloat fromCenterToTouch = sqrt(pow(touchPos.x, wheelPos.x) + pow(touchPos.y, wheelPos.y));
    CGFloat moodColorRadius = self.moodColor.frame.size.width/2;
    if(_isWheelTouched || fromCenterToTouch-moodColorRadius>0){
        NSLog(@"Can't expose moodPoses. Out of touch range.");
        return NO;
    }
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)moodPosShow:(id)sender {
}

- (IBAction)moodPosHide:(id)sender {
}

- (IBAction)done:(id)sender {
}
@end
