//
//  SMWheelViewController.h
//  SentiMap
//
//  Created by 김기범 on 2016. 4. 20..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SMMapContainerViewController.h"
#import "SMWheelGestureRecognizer.h"
#import "SMTouchUpGestureRecognizer.h"
#import "SMTouchDownGestureRecognizer.h"
#import "AFHTTPSessionManager.h"

@interface SMWheelViewController : UIViewController <CLLocationManagerDelegate>

/* URL request info */
@property unsigned long long userId;
@property NSString *serverURL;

/* recognizer */
@property SMWheelGestureRecognizer *wheelGestureRecognizer;
@property SMTouchUpGestureRecognizer *touchUpGestureRecognizer;
@property SMTouchDownGestureRecognizer *touchDownGestureRecognizer;

/* labels */
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *moodLabel;

/* wheel views */
@property CGFloat wheelRotateDegree;
@property (strong, nonatomic) IBOutlet UIView *wheelContainer;
@property (strong, nonatomic) IBOutlet UIImageView *wheel;
@property (strong, nonatomic) IBOutlet UIImageView *wheelGlow;
@property (strong, nonatomic) IBOutlet UIImageView *moodColor;
@property (strong, nonatomic) IBOutlet UIView *moodPoses;
@property (strong, nonatomic) IBOutlet UIButton *moodPosExposer;
@property BOOL isStillAnimating;

/* done button */
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *doneArrow;

/* geographical position */
@property NSString *city;
@property double latitude;
@property double longitude;
@property CLLocationManager *locationManager;

/* mood */
@property NSNumber *chosenMood;
@property NSInteger preIndex;
@property NSArray<NSDictionary *> *moodInfo;

/* flags to determine touch priority between two overlayered views */
@property BOOL isWheelTouched;
@property BOOL isMoodPosExposerTouched;

/* first tutorial view */
@property (strong, nonatomic) IBOutlet UIView *firstMessageViewController;

/* notification */
@property NSNotificationCenter *notiCenter;

/* IBActions */
- (IBAction)done:(id)sender;
- (IBAction)moodPosShow:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)moodPosHide:(UIButton *)sender forEvent:(UIEvent *)event;

@end
