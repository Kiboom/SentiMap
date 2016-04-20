//
//  SMWheelViewController.h
//  SentiMap
//
//  Created by 김기범 on 2016. 4. 20..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SMWheelGestureRecognizer.h"

@interface SMWheelViewController : UIViewController <SMWheelGestureRecognizerDelegate, CLLocationManagerDelegate>

/* recognizer */
@property SMWheelGestureRecognizer * wheelGestureRecognizer;

/* labels */
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *moodLabel;

/* wheel views */
@property CGFloat wheelRotateAngle;
@property (strong, nonatomic) IBOutlet UIView *wheelContainer;
@property (strong, nonatomic) IBOutlet UIImageView *wheel;
@property (strong, nonatomic) IBOutlet UIImageView *wheelGlow;
@property (strong, nonatomic) IBOutlet UIImageView *moodColor;
@property (strong, nonatomic) IBOutlet UIView *moodPoses;
@property (strong, nonatomic) IBOutlet UIButton *moodPosExposer;

/* done button */
@property (strong, nonatomic) IBOutlet UIView *doneButton;

/* geographical position */
@property NSString *city;
@property double *longitude;
@property double *latitude;

/* mood */
@property NSNumber *chosenMood;
@property NSArray<NSDictionary *> *moodInfo;

/* flags to determine touch priority between two overlayered views */
@property BOOL isWheelTouched;
@property BOOL isMoodPosesTouched;

/* IBActions */
- (IBAction)moodPosShow:(id)sender;
- (IBAction)moodPosHide:(id)sender;
- (IBAction)done:(id)sender;

@end
