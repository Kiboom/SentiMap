//
//  SMMapContainerViewController.m
//  SentiMap
//
//  Created by 김기범 on 2016. 5. 1..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import "SMMapContainerViewController.h"

@interface SMMapContainerViewController ()

@end

@implementation SMMapContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self notificationInit];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self sideMenuInit];
}


/* initialize */
- (void)notificationInit {
    _notiCenter = [NSNotificationCenter defaultCenter];
    [_notiCenter addObserver:self selector:@selector(hideSideMenu) name:@"search place activated" object:nil];
    [_notiCenter addObserver:self selector:@selector(hideButtons) name:@"search place activated" object:nil];
    
    [_notiCenter addObserver:self selector:@selector(showButtons) name:@"search complete" object:nil];
    
    [_notiCenter addObserver:self selector:@selector(showTimeMachine) name:@"time machine activated" object:nil];
    [_notiCenter addObserver:self selector:@selector(hideSideMenu) name:@"time machine activated" object:nil];
    
    [_notiCenter addObserver:self selector:@selector(showSideMenu:) name:@"return to side menu" object:nil];
    [_notiCenter addObserver:self selector:@selector(hideTimeMachine) name:@"return to side menu" object:nil];
}

- (void)sideMenuInit {
    _sideMenuWidth = _sideMenuView.bounds.size.width;
    _sideMenuHeight = _sideMenuView.bounds.size.height;
    _timeMachineWidth = _timeMachineView.bounds.size.width;
    _timeMachineHeight = _timeMachineView.bounds.size.height;
    [self hideSideMenu];
    [self hideTimeMachine];
    [self showButtons];
}



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"mapSegue"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        _mapViewController = navigationController.viewControllers[0];
        _mapViewController.latitude = _latitude;
        _mapViewController.longitude = _longitude;
        _mapViewController.mood = _mood;
    }
}



/* show and hide views*/
- (IBAction)showSideMenu:(id)sender {
    [self.view bringSubviewToFront:_sideMenuView];
    [UIView animateWithDuration:0.35
                           delay:0.0
                         options:UIViewAnimationOptionCurveEaseInOut
                      animations:^{
                          _sideMenuView.bounds = CGRectMake(0, 0, _sideMenuWidth, self.view.bounds.size.height);
                      }
                      completion:nil];
}

- (void)hideSideMenu {
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _sideMenuView.bounds = CGRectMake(_sideMenuWidth, 0, _sideMenuWidth, _sideMenuHeight);
                     }
                     completion:^(BOOL finished) {
                         [self.view sendSubviewToBack:_sideMenuView];
                     }];
}

- (void)showButtons {
    [self.view bringSubviewToFront:_hamburger];
    [self.view bringSubviewToFront:_plusMoodButton];
}

- (void)hideButtons {
    [self.view sendSubviewToBack:_hamburger];
    [self.view sendSubviewToBack:_plusMoodButton];
}

- (void)showTimeMachine {
    [self.view bringSubviewToFront:_timeMachineView];
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _timeMachineView.bounds = CGRectMake(0, 0, _timeMachineWidth, self.view.bounds.size.height);
                     }
                     completion:nil];
}

- (void)hideTimeMachine {
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _timeMachineView.bounds = CGRectMake(_timeMachineWidth, 0, _timeMachineWidth, self.view.bounds.size.height);
                     }
                     completion:^(BOOL finished) {
                         [self.view sendSubviewToBack:_timeMachineView];
                     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
