//
//  SMTimeMachineViewController.m
//  SentiMap
//
//  Created by 김기범 on 2016. 5. 1..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//


#import "SMTimeMachineViewController.h"

@implementation SMTimeMachineViewController

- (void) viewDidLoad {
	[super viewDidLoad];
    [self pickerViewInit];
    [self notificationCenterInit];
}


- (void)pickerViewInit {
    _pickerData = @[@"1 Month\nAgo", @"1 Week\nAgo", @"1 Day\nAgo", @"12 Hours\nAgo", @"Now"];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    
    // set initial row position
    [_pickerView selectRow:(_pickerData.count-1) inComponent:0 animated:YES];

    // remove selected row indicator
    [[_pickerView.subviews objectAtIndex:1] setHidden:TRUE];
    [[_pickerView.subviews objectAtIndex:2] setHidden:TRUE];
}

- (void)notificationCenterInit {
    _notiCenter = [NSNotificationCenter defaultCenter];
    _chosenTimeInfo = [[NSMutableDictionary alloc] initWithDictionary:@{@"time" : @""}];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _pickerData[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    // setting for line-break
    NSString* title = [_pickerData objectAtIndex:row];
    CGRect labelRect = CGRectMake(0, 0, 100., 70.);
    
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    [label setFont:[UIFont fontWithName:@"Odin Rounded" size:17.0]];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setNumberOfLines:2];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 83.;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString* time = (NSString*)[_pickerData objectAtIndex:row];
    [_chosenTimeInfo setValue:time forKey:@"time"];
    [_notiCenter postNotificationName:@"time selected" object:nil userInfo:_chosenTimeInfo];
}

- (IBAction)returnToSideMenu:(id)sender {
    [_notiCenter postNotificationName:@"return to side menu" object:nil];
}
@end