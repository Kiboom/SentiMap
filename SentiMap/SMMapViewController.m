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
    _serverURL = @"http://52.192.198.85:5000/loadData";
    
    [self notificationInit];
    [self mapInit];
    [self moodInfoInit];
    
    [self coordinatesInit];
    [self fetchJSONDataByCoordinates];
    [self addAnnotationAtLatitude:_latitude
                       Longtitude:_longitude
                             Mood:_mood
                    JustExpressed:YES];
    
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


- (void)coordinatesInit {
    _curCoordinates = @{@"startLat" : @0, @"endLat" : @0, @"startLon" : @0, @"endLon" : @0};
    [self setCurCoordinatesWithMapRect:_map.visibleMapRect];
    _prevCoordinates = _curCoordinates;
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


- (void)fetchJSONDataByCoordinates {
    NSString *query = [NSString stringWithFormat:@"?startLat=%@&endLat=%@&startLon=%@&endLon=%@", _curCoordinates[@"startLat"], _curCoordinates[@"endLat"], _curCoordinates[@"startLon"], _curCoordinates[@"endLon"]];
    NSString *url = [_serverURL stringByAppendingString:query];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask *dataTask, NSArray *jsonData) {
             [self setDatas:jsonData];
             [self drawAnnotations];
             [self eraseOldAnnotations];
             _prevCoordinates = _curCoordinates;
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
             [self drawAnnotations];
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


- (void)setDatas:(NSArray *)jsonData {
    if(jsonData==nil) {
        return;
    }
    
    NSString *predicateFormat = @"(lat < %@) OR (lat > %@) OR (lon < %@) OR (lon > %@)";
    if([_prevCoordinates[@"startLon"] floatValue] >=0 && [_prevCoordinates[@"endLon"] floatValue]<=0) {
        predicateFormat = @"(lat < %@) OR (lat > %@) OR ((lon < %@) AND (lon > %@))";
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat,
                                  _prevCoordinates[@"startLat"], _prevCoordinates[@"endLat"],
                                  _prevCoordinates[@"startLon"], _prevCoordinates[@"endLon"]];
    _jsonData = [jsonData filteredArrayUsingPredicate:predicate];
    _receivedLats = [_jsonData valueForKey:@"lat"];
    _receivedLons = [_jsonData valueForKey:@"lon"];
    _receivedMoods = [_jsonData valueForKey:@"emotion"];
}


- (void)drawAnnotations {
    for (int i = 0; i<_jsonData.count ; i++) {
        [self addAnnotationAtLatitude: [_receivedLats[i] floatValue]
                           Longtitude: [_receivedLons[i] floatValue]
                                 Mood: [_receivedMoods[i] intValue]
                        JustExpressed:NO];
    }
}


- (void)eraseOldAnnotations {
    NSArray<SMAnnotation *> *annotations = [_map annotations];
    CGFloat startLat = [(NSNumber *)_curCoordinates[@"startLat"] floatValue];
    CGFloat endLat = [(NSNumber *)_curCoordinates[@"endLat"] floatValue];
    CGFloat startLon = [(NSNumber *)_curCoordinates[@"startLon"] floatValue];
    CGFloat endLon = [(NSNumber *)_curCoordinates[@"endLon"] floatValue];
    
    // 지도가 날짜 변경선에 걸쳐있는 경우
    if(startLon>=0 && endLon <=0) {
        for(SMAnnotation *annotation in annotations) {
            if(annotation.coordinate.latitude < startLat || annotation.coordinate.latitude > endLat || (endLon<annotation.coordinate.longitude && annotation.coordinate.longitude<startLon)) {
                [_map removeAnnotation:annotation];
            }
        }
        return;
    }
    
    // 일반적인 경우
    for(SMAnnotation *annotation in annotations) {
        if(annotation.coordinate.latitude < startLat || annotation.coordinate.latitude > endLat || annotation.coordinate.longitude < startLon || annotation.coordinate.longitude > endLon) {
            [_map removeAnnotation:annotation];
        }
    }
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


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self setCurCoordinatesWithMapRect:_map.visibleMapRect];
    NSLog(@"%@", _curCoordinates);
    [self fetchJSONDataByCoordinates];
}


- (void)setCurCoordinatesWithMapRect:(MKMapRect)mapRect {
    CLLocationCoordinate2D topLeft = [self getNWCoordinate:mapRect];
    CLLocationCoordinate2D bottomRight = [self getSECoordinate:mapRect];
    
    NSNumber *startLat = [NSNumber numberWithFloat:bottomRight.latitude];
    NSNumber *endLat = [NSNumber numberWithFloat:topLeft.latitude];
    NSNumber *startLon = [NSNumber numberWithFloat:topLeft.longitude];
    NSNumber *endLon = [NSNumber numberWithFloat:bottomRight.longitude];
//    // 만약 longitude가 날짜변경선에 걸쳐 있는 경우, 두 값을 바꿔줘야 함. 안 그러면 70<lon<-175 인 lon을 찾아야 하는 불상사가 생김.
//    if([startLon floatValue] > [endLon floatValue]) {
//        NSNumber *temp = startLon;
//        startLon = endLon;
//        endLon = temp;
//    }
    _curCoordinates = @{@"startLat" : startLat, @"endLat" : endLat, @"startLon" : startLon, @"endLon" : endLon};
}


- (CLLocationCoordinate2D)getCoordinateFromMapRectPointWithX:(double)x Y:(double)y {
    MKMapPoint mapPoint = MKMapPointMake(x, y);
    return MKCoordinateForMapPoint(mapPoint);
}


- (CLLocationCoordinate2D)getNWCoordinate:(MKMapRect)mapRect {
    return [self getCoordinateFromMapRectPointWithX:MKMapRectGetMinX(mapRect) Y:mapRect.origin.y];
}


- (CLLocationCoordinate2D)getSECoordinate:(MKMapRect)mapRect {
    return [self getCoordinateFromMapRectPointWithX:MKMapRectGetMaxX(mapRect) Y:MKMapRectGetMaxY(mapRect)];
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
