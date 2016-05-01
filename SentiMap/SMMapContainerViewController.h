//
//  SMMapContainerViewController.h
//  SentiMap
//
//  Created by 김기범 on 2016. 5. 1..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "SMMapViewController.h"
#import "SMSideMenuViewController.h"

@interface SMMapContainerViewController : UIViewController

/* map */
@property (strong, nonatomic) IBOutlet UIView *mapView;
@property SMMapViewController *mapViewController;

/* side menu */
@property (strong, nonatomic) IBOutlet UIView *sideMenuView;
@property CGFloat sideMenuWidth;
@property CGFloat sideMenuHeight;

/* time machine */
@property (strong, nonatomic) IBOutlet UIView *timeMachineView;
@property CGFloat timeMachineWidth;
@property CGFloat timeMachineHeight;

/* buttons */
@property (strong, nonatomic) IBOutlet UIButton *hamburger;
@property (strong, nonatomic) IBOutlet UIButton *plusMoodButton;

/* camera start pos */
@property double latitude;
@property double longitude;

/* moods data */
@property int mood;

/* notification */
@property NSNotificationCenter *notiCenter;

- (IBAction)showSideMenu:(id)sender;

@end
