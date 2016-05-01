//
//  SMSideMenuViewController.m
//  SentiMap
//
//  Created by 김기범 on 2016. 5. 1..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import "SMSideMenuViewController.h"

@implementation SMSideMenuViewController

- (void)viewDidLoad {
    _notiCenter = [NSNotificationCenter defaultCenter];
}

- (IBAction)searchPlace:(id)sender {
    [_notiCenter postNotificationName:@"search place activated" object:nil];
}

- (IBAction)timeMachine:(id)sender {
    [_notiCenter postNotificationName:@"time machine activated" object:nil];
}

- (IBAction)logOut:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"About"
                                                                   message:@"ver. 0.0.2\ndeveloped by Kibeom Kim"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)exitSideMenu:(id)sender {
    [_notiCenter postNotificationName:@"side menu deactivated" object:nil];
}
@end
