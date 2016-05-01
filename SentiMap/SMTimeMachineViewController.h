//
//  SMTimeMachineViewController.h
//  SentiMap
//
//  Created by 김기범 on 2016. 5. 1..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SMMapViewController.h"

@interface SMTimeMachineViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

/* picker view */
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property NSArray *pickerData;

/* notification */
@property NSNotificationCenter *notiCenter;
@property NSMutableDictionary *chosenTimeInfo;

- (IBAction)returnToSideMenu:(id)sender;
@end
