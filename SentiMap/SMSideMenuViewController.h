//
//  SMSideMenuViewController.h
//  SentiMap
//
//  Created by 김기범 on 2016. 5. 1..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SMSideMenuViewController : UIViewController

@property NSNotificationCenter *notiCenter;

- (IBAction)searchPlace:(id)sender;
- (IBAction)timeMachine:(id)sender;
- (IBAction)logOut:(id)sender;
- (IBAction)exitSideMenu:(id)sender;

@end
