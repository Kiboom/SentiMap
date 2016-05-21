//
//  SMMapViewController.m
//  SentiMap
//
//  Created by 김기범 on 2016. 4. 29..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import "SMMapViewController.h"

@interface SMMapViewController ()

@end

@implementation SMMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _serverURL = @"http://localhost:3000/loadData";
    [self notificationInit];
    [self mapInit];
    [self moodInfoInit];
    [self addAnnotationAtLatitude:_latitude
                       Longtitude:_longitude
                             Mood:_mood
                    JustExpressed:YES];
    [self fetchJSONData];
    [self searchBarInit];
}



- (void)mapInit {
    [_map setCamera:[MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(_latitude, _longitude)
                                                    fromDistance:500.0
                                                           pitch:4
                                                         heading:0]];
    _map.delegate = self;
    _map.rotateEnabled = NO;
    _allAnnotationsMapView = [[MKMapView alloc] initWithFrame:CGRectZero];
}



- (void)moodInfoInit {
    NSDictionary *joy = @{@"num":@1, @"title":@"JOY", @"color":[UIColor colorWithRed:(199/255.f) green:(154/255.f) blue:(23/255.f) alpha:1.0], @"image":[UIImage imageNamed:@"marker_joy"]};
    NSDictionary *tired = @{@"num":@2, @"title":@"TIRED", @"color":[UIColor colorWithRed:(114/255.f) green:(80/255.f) blue:(46/255.f) alpha:1.0], @"image":[UIImage imageNamed:@"marker_tired"]};
    NSDictionary *fun = @{@"num":@3, @"title":@"FUN", @"color":[UIColor colorWithRed:(199/255.f) green:(87/255.f) blue:(25/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"marker_fun"]};
    NSDictionary *angry = @{@"num":@4, @"title":@"ANGRY", @"color":[UIColor colorWithRed:(194/255.f) green:(46/255.f) blue:(66/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"marker_angry"]};
    NSDictionary *surprised = @{@"num":@5, @"title":@"SURPRISED", @"color":[UIColor colorWithRed:(208/255.f) green:(94/255.f) blue:(142/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"marker_surprised"]};
    NSDictionary *scared = @{@"num":@6, @"title":@"SCARED", @"color":[UIColor colorWithRed:(117/255.f) green:(62/255.f) blue:(146/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"marker_scared"]};
    NSDictionary *sad = @{@"num":@7, @"title":@"SAD", @"color":[UIColor colorWithRed:(79/255.f) green:(111/255.f) blue:(217/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"marker_sad"]};
    NSDictionary *excited = @{@"num":@8, @"title":@"EXCITED", @"color":[UIColor colorWithRed:(90/255.f) green:(212/255.f) blue:(194/255.f)alpha:1.0], @"image":[UIImage imageNamed:@"marker_excited"]};
    _moodInfo = [[NSArray alloc] initWithObjects:joy, tired, fun, angry, surprised, scared, sad, excited, nil];
}


- (void)searchBarInit {
    SMLocationSearchTable *locationSearchTable = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationSearchTable"];
    locationSearchTable.map = _map;
    locationSearchTable.delegate = self;
    
    _resultSearchController = [[UISearchController alloc] initWithSearchResultsController:locationSearchTable];
    _resultSearchController.searchResultsUpdater = locationSearchTable;
    
    UISearchBar *searchBar = _resultSearchController.searchBar;
    searchBar.delegate = self;
    [searchBar sizeToFit];
    searchBar.placeholder = @"Search for places!";
    self.navigationItem.titleView = _resultSearchController.searchBar;
    [[self navigationController] setNavigationBarHidden:YES];
    
    _resultSearchController.hidesNavigationBarDuringPresentation = NO;
    _resultSearchController.dimsBackgroundDuringPresentation = YES;
    self.definesPresentationContext = YES;
}


- (void)notificationInit {
    _notiCenter = [NSNotificationCenter defaultCenter];
    [_notiCenter addObserver:self
                    selector:@selector(showSearchBar)
                        name:@"search place activated"
                      object:nil];
    [_notiCenter addObserver:self
                    selector:@selector(hideSearchBar)
                        name:@"search complete"
                      object:nil];
    [_notiCenter addObserver:self
                    selector:@selector(updateMoods:)
                        name:@"time selected"
                      object:nil];
}


- (void)showSearchBar {
    [[self navigationController] setNavigationBarHidden:NO];
}


- (void)hideSearchBar {
    [[self navigationController] setNavigationBarHidden:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_notiCenter postNotificationName:@"search complete" object:nil];
    [self hideSearchBar];
}

- (void)fetchJSONData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:_serverURL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask *dataTask, NSDictionary *jsonData) {
             [self setDatas:jsonData];
             for (int i = 0; i<_jsonData.count ; i++) {
                 [self addAnnotationAtLatitude: [_receivedLats[i] doubleValue]
                                    Longtitude: [_receivedLons[i] doubleValue]
                                          Mood: [_receivedMoods[i] intValue]
                                 JustExpressed:NO];
             }
         }
         failure:^(NSURLSessionTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}


- (void)fetchJSONDataByTime:(NSString *)time {
    NSString *hour = [self timeStringToHour:time];
    NSString *url = [NSString stringWithFormat:@"%@/%@", _serverURL, hour]; //http://localhost:3000/loadData/{hour}
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask *dataTask, NSDictionary *jsonData) {
             [self setDatas:jsonData];
             for (int i = 0; i<_jsonData.count ; i++) {
                 [self addAnnotationAtLatitude: [_receivedLats[i] doubleValue]
                                    Longtitude: [_receivedLons[i] doubleValue]
                                          Mood: [_receivedMoods[i] intValue]
                                 JustExpressed:NO];
             }
         }
         failure:^(NSURLSessionTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}


- (NSString *)timeStringToHour:(NSString *)time {
    if([time isEqualToString:@"Now"]) {
        return @"0";
    }
    else if([time isEqualToString:@"12 Hours\nAgo"]) {
        return @"12";
    }
    else if([time isEqualToString:@"1 Day\nAgo"]) {
        return @"24";
    }
    else if([time isEqualToString:@"1 Week\nAgo"]) {
        return @"168";
    }
    else if([time isEqualToString:@"1 Month\nAgo"]) {
        return @"732";
    }
    return nil;
}



- (void)updateMoods:(NSNotification *)noti{
    NSString *time = (NSString *)noti.userInfo[@"time"];
    [_map removeAnnotations:[_map annotations]];
    [self fetchJSONDataByTime:time];
}


- (void)setDatas:(NSDictionary *)jsonData {
    _jsonData = jsonData;
    _receivedLats = [_jsonData valueForKey:@"lat"];
    _receivedLons = [_jsonData valueForKey:@"lon"];
    _receivedMoods = [_jsonData valueForKey:@"emotion"];
}



- (void)addAnnotationAtLatitude:(double)lat Longtitude:(double)lon Mood:(int)mood JustExpressed:(BOOL)justExpressed{
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lat, lon);
    SMAnnotation *annotation = [[SMAnnotation alloc] initWithTitle:[_moodInfo[mood-1] objectForKey:@"title"]
                                                        coordinate:location
                                                              icon:[_moodInfo[mood-1] objectForKey:@"image"]
                                                     justExpressed:justExpressed];
    [_map addAnnotation:annotation];
    
    if(justExpressed) {
        annotation.title = @"Here's your feeling!";
        [_map selectAnnotation:annotation animated:YES];
    }
}


- (void)addSquashAnimationTo:(UIView *)view {
    [UIView animateWithDuration:0.05
                     animations:^{
                         view.transform = CGAffineTransformMakeScale(1.0, 0.8);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1 animations:^ {
                             view.transform = CGAffineTransformIdentity;
                         }];
                         
                     }];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    SMAnnotation *smAnnotation = (SMAnnotation *)annotation;
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:[NSString stringWithFormat:@"%@Annotation", smAnnotation.title]];
    if(annotationView == nil) {
        annotationView = [smAnnotation annotationView];
    } else {
        annotationView.annotation = annotation;
    }
    return annotationView;
}


- (void)goToSearchedLocation:(MKPlacemark *)placemark {
    MKCoordinateRegion region = MKCoordinateRegionMake(placemark.coordinate, MKCoordinateSpanMake(0.05, 0.05));
    [_map setRegion:region animated:YES];
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
    MKMapRect mapRect = _map.visibleMapRect;
    NSArray *boundingBox = [self getBoundingBox:mapRect];
    NSLog(@"%@", boundingBox);
}


- (NSArray *)getBoundingBox:(MKMapRect)mapRect {
    CLLocationCoordinate2D bottomRight = [self getSECoordinate:mapRect];
    CLLocationCoordinate2D topLeft = [self getNWCoordinate:mapRect];
    return @[@{@"lat":[NSNumber numberWithDouble:topLeft.latitude], @"lon":[NSNumber numberWithDouble:topLeft.longitude]},
             @{@"lat":[NSNumber numberWithDouble:bottomRight.latitude], @"lon":[NSNumber numberWithDouble:bottomRight.longitude]}];
}


- (CLLocationCoordinate2D)getCoordinateFromMapRectPointWithX:(double)x Y:(double)y {
    MKMapPoint mapPoint = MKMapPointMake(x, y);
    return MKCoordinateForMapPoint(mapPoint);
}


- (CLLocationCoordinate2D)getSWCoordinate:(MKMapRect)mapRect {
    return [self getCoordinateFromMapRectPointWithX:mapRect.origin.x Y:MKMapRectGetMaxY(mapRect)];
}


- (CLLocationCoordinate2D)getSECoordinate:(MKMapRect)mapRect {
    return [self getCoordinateFromMapRectPointWithX:MKMapRectGetMaxX(mapRect) Y:MKMapRectGetMaxY(mapRect)];
}


- (CLLocationCoordinate2D)getNWCoordinate:(MKMapRect)mapRect {
    return [self getCoordinateFromMapRectPointWithX:MKMapRectGetMinX(mapRect) Y:mapRect.origin.y];
}


- (CLLocationCoordinate2D)getNECoordinate:(MKMapRect)mapRect {
    return [self getCoordinateFromMapRectPointWithX:MKMapRectGetMaxX(mapRect) Y:mapRect.origin.y];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)goToCurrentLocation:(id)sender {
    [_map setCamera:[MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(_latitude, _longitude)
                                                    fromDistance:2000.0
                                                           pitch:4
                                                         heading:0]];
}

@end
