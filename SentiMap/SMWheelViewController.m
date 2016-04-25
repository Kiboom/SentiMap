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
/* initialization */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self moodInfoInit];
    [self gestureRecognizerInit];
    [self wheelInit];
    [self doneButtonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)moodInfoInit {
    NSDictionary *joy = @{@"num":@1, @"text":@"JOY", @"color":[UIColor colorWithRed:(199/255.f) green:(154/255.f) blue:(23/255.f) alpha:1.0], @"image":[UIImage imageNamed:@"joy"]};
    NSDictionary *tired = @{@"num":@2, @"text":@"TIRED", @"color":[UIColor colorWithRed:(114/255.f) green:(80/255.f) blue:(46/255.f) alpha:1.0], @"image":[UIImage imageNamed:@"tired"]};
    NSDictionary *fun = @{@"num":@3, @"text":@"FUN", @"color":[UIColor colorWithRed:(199/255.f) green:(87/255.f) blue:(25/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"fun"]};
    NSDictionary *angry = @{@"num":@4, @"text":@"ANGRY", @"color":[UIColor colorWithRed:(194/255.f) green:(46/255.f) blue:(66/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"angry"]};
    NSDictionary *surprised = @{@"num":@5, @"text":@"SURPRISED", @"color":[UIColor colorWithRed:(208/255.f) green:(94/255.f) blue:(142/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"surprised"]};
    NSDictionary *scared = @{@"num":@6, @"text":@"SCARED", @"color":[UIColor colorWithRed:(117/255.f) green:(62/255.f) blue:(146/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"scared"]};
    NSDictionary *sad = @{@"num":@7, @"text":@"SAD", @"color":[UIColor colorWithRed:(79/255.f) green:(111/255.f) blue:(217/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"sad"]};
    NSDictionary *excited = @{@"num":@8, @"text":@"EXCITED", @"color":[UIColor colorWithRed:(90/255.f) green:(212/255.f) blue:(194/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"excited"]};
    _moodInfo = [[NSArray alloc] initWithObjects:joy, tired, fun, angry, surprised, scared, sad, excited, nil];
    _preIndex = 10;
}

- (void)gestureRecognizerInit {
    _wheelGestureRecognizer = [[SMWheelGestureRecognizer alloc] initWithTarget:self action:@selector(didWheelGesture:)];
    _touchUpGestureRecognizer = [[SMTouchUpGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchUpGesture)];
    _touchDownGestureRecognizer = [[SMTouchDownGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchDownGesture:)];
    [_wheelContainer addGestureRecognizer:_wheelGestureRecognizer];
    [_wheelContainer addGestureRecognizer:_touchUpGestureRecognizer];
    [_wheelContainer addGestureRecognizer:_touchDownGestureRecognizer];
}

- (void)wheelInit {
    _isWheelTouched = NO;
    _moodColor.layer.opacity = 0.0;
    _moodPoses.layer.opacity = 0.0;
    _wheelGlow.layer.opacity = 0.0;
    _wheelGlow.layer.shouldRasterize = YES;
    [self performSelector:@selector(addPulseAnimationTo:) withObject:_wheelContainer afterDelay:0.1f];
}

- (void)doneButtonInit {
    _doneButton.layer.opacity = 0.0;
    _doneArrow.layer.opacity = 0.0;
    [_doneButton setEnabled:NO];
    [_doneArrow setEnabled:NO];
}



/* wheel glow */
- (void)didTouchDownGesture:(SMTouchDownGestureRecognizer *)recognizer {
    CGPoint touchPos = [recognizer.touch locationInView:_wheelContainer];
    if([self isMoodPosExposerTouched:touchPos]) {
        return;
    }
    _isWheelTouched = YES;
    CGFloat rotateDirection = recognizer.currentAngle - _wheelRotateDegree;
    [self rotateWheel:rotateDirection];
    [self wheelGlowAppear];
    NSLog(@"Touch Down, %@", (_wheelGlow.hidden)?@"hidden":@"show");
}

- (void)wheelGlowAppear {
    [self addFadeAnimationTo:_wheelGlow duration:0.25 isFadeIn:YES];
    [self addFadeAnimationTo:_moodColor duration:0.25 isFadeIn:YES];
    [self addFadeAnimationTo:_moodLabel duration:0.25 isFadeIn:YES];
    [self doneButtonEnable];
}

- (void)didTouchUpGesture {
    [self wheelGlowDisappear];
    NSLog(@"Touch Up, %@", (_wheelGlow.hidden)?@"hidden":@"show");
}

- (void)wheelGlowDisappear {
    [self addFadeAnimationTo:_wheelGlow duration:0.25 isFadeIn:NO];
    _isWheelTouched = NO;
}



/* wheel rotation */
- (void)didWheelGesture:(SMWheelGestureRecognizer *)recognizer {
    if([recognizer state] == UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint touchPos = [recognizer.touch locationInView:_wheelContainer];
    if([self isMoodPosExposerTouched:touchPos] || _wheelGlow.hidden) {
        return;
    }
    [self rotateWheel:recognizer.rotateDirection];
}

- (void)updateWheelRotateDegree:(CGFloat)direction {
    _wheelRotateDegree += direction;
    if(_wheelRotateDegree < -0.5) {
        _wheelRotateDegree += 360;
    }
    else if(_wheelRotateDegree > 359.5) {
        _wheelRotateDegree -= 360;
    }
}

- (void)rotateWheel:(CGFloat)direction {
    [self updateWheelRotateDegree:direction];
    CGAffineTransform newTransform = CGAffineTransformRotate(self.wheelGlow.transform, direction*M_PI/180);
    [self.wheelGlow setTransform:newTransform];
    [self updateCurrentMood];
}

- (void)updateCurrentMood {
    if(_isWheelTouched == NO) {
        return;
    }
    NSInteger index = _wheelRotateDegree/45;
    if(_preIndex != index){
        [self addUpdateMoodAnimationTo:_moodColor duration:0.1 moodInfo:_moodInfo[index]];
        [self addUpdateMoodAnimationTo:_moodLabel duration:0.1 moodInfo:_moodInfo[index]];
    }
    _chosenMood = [_moodInfo[index] objectForKey:@"num"];
    _preIndex = index;
}



/* animation */
- (void)addPulseAnimationTo:(UIView *)view {
    [self addRepeatAnimationTo:view
                  forKey:@"transform.scale"
               fromValue:@1.0
                 toValue:@1.04];
    
    [self addRepeatAnimationTo:view
                  forKey:@"opacity"
               fromValue:@0.86
                 toValue:@1.0];
}

- (void)addRepeatAnimationTo:(UIView *)view forKey:(NSString *)key fromValue:(NSNumber *)fromValue toValue:(NSNumber *)toValue {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
    animation.duration = 2;
    animation.repeatCount = HUGE_VALF;
    animation.autoreverses = YES;
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    [view.layer addAnimation:animation forKey:key];
}

- (void)addFadeAnimationTo:(UIView *)view duration:(CGFloat)duration isFadeIn:(BOOL)isFadeIn {
    [UIView animateWithDuration:duration
                     animations:^{
                         view.layer.opacity = (isFadeIn)? 1.0 : 0.0;
                     }];
}

- (void)addUpdateMoodAnimationTo:(UIView *)view duration:(CGFloat)duration moodInfo:(NSDictionary *)moodInfo {
    NSLog(@"animated!");
    [UIView transitionWithView:view
                      duration:duration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        if([view isMemberOfClass:[UILabel class]]){
                            UILabel *label = (UILabel *)view;
                            label.text = [moodInfo objectForKey:@"text"];
                            label.textColor = [moodInfo objectForKey:@"color"];
                        } else {
                            UIImageView *imageView = (UIImageView *)view;
                            imageView.image = [moodInfo objectForKey:@"image"];
                        }
                    }
                    completion:nil];
}



/* moodPos button */
- (IBAction)moodPosShow:(UIButton *)sender forEvent:(UIEvent *)event {
    UITouch *touch = [[event touchesForView:sender] anyObject];
    CGPoint touchPos = [touch locationInView:_wheelContainer];
    if([self isMoodPosExposerTouched:touchPos]) {
        [self addFadeAnimationTo:_moodPoses duration:0.4 isFadeIn:YES];
        _isWheelTouched = NO;
    }
}

- (IBAction)moodPosHide:(UIButton *)sender forEvent:(UIEvent *)event {
    [self addFadeAnimationTo:_moodPoses duration:0.4 isFadeIn:NO];
}

    // determine touch priority between two overlayered views (moodPosExposer and wheel)
- (BOOL)isMoodPosExposerTouched:(CGPoint)touchPos {
    CGPoint wheelPos = _moodColor.center;
    CGFloat fromCenterToTouch = sqrt(pow(wheelPos.x-touchPos.x, 2) + pow(wheelPos.y-touchPos.y, 2));
    CGFloat moodColorRadius = _moodColor.frame.size.width/2;
    if(_isWheelTouched || fromCenterToTouch>moodColorRadius){
        return NO;
    }
    return YES;
}



/* done button */
- (void)doneButtonEnable {
    [self addFadeAnimationTo:_doneButton duration:0.9 isFadeIn:YES];
    [self addFadeAnimationTo:_doneArrow duration:0.9 isFadeIn:YES];
    [_doneButton setEnabled:YES];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)done:(id)sender {
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
