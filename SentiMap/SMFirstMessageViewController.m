//
//  SMFirstMessageViewController.m
//  SentiMap
//
//  Created by 김기범 on 2016. 5. 2..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import "SMFirstMessageViewController.h"

@interface SMFirstMessageViewController ()

@end

@implementation SMFirstMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _notiCenter = [NSNotificationCenter defaultCenter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
*/

- (IBAction)gotIt:(id)sender {
    [_notiCenter postNotificationName:@"firstMessageClose" object:nil];
}

@end
