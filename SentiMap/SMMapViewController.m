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
//             [self updateVisibleAnnotations];
         }
         failure:^(NSURLSessionTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}


- (void)fetchJSONDataByTime:(NSString *)time {
    time = [time componentsSeparatedByString:@"\nAgo"][0];
    time = [time stringByReplacingOccurrencesOfString:@"\\s"
                                           withString:@""
                                              options:NSRegularExpressionSearch
                                                range:NSMakeRange(0, time.length)];
    NSString *url = [NSString stringWithFormat:@"http://52.192.198.85:5000/loadData/%@",time];
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


- (void)updateMoods:(NSNotification *)noti{
    NSString *time = (NSString *)noti.userInfo[@"time"];
    NSLog(@"%@",time);
    [_map removeAnnotations:[_map annotations]];
    [self fetchJSONDataByTime:time];
}


- (void)setDatas:(NSDictionary *)jsonData {
    _jsonData = [jsonData objectForKey:@"results"];
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
        MKMapPoint point = MKMapPointForCoordinate(annotation.coordinate);
        if(MKMapRectContainsPoint(_map.visibleMapRect, point)) {
            // Move annotation out of view
            CGRect endFrame = annotation.annotationView.frame;
            annotation.annotationView.frame = CGRectMake(annotation.annotationView.frame.origin.x, -500, annotation.annotationView.frame.size.width, annotation.annotationView.frame.size.height);
            NSLog(@"%f", annotation.annotationView.frame.origin.y);
            [self addDropAnimationTo:annotation.annotationView endFrame:endFrame];
            annotation.title = @"Here's your feeling!";
            [_map selectAnnotation:annotation animated:YES];
        }
    }
}


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
//    for (MKAnnotationView *view in views) {
//        // Give animation to annotations if it's inside visible map rect, else go to next one
//        MKMapPoint point = MKMapPointForCoordinate(view.annotation.coordinate);
//        if(MKMapRectContainsPoint(_map.visibleMapRect, point)) {
//            // Move annotation out of view
//            CGRect endFrame = view.frame;
//            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - self.view.frame.size.height, view.frame.size.width, view.frame.size.height);
//            [self addDropAnimationTo:view endFrame:endFrame];
//        }
    
//        if (annotation.clusterAnnotation != nil) {
//            // animate the annotation from it's old container's coordinate, to its actual coordinate
//            CLLocationCoordinate2D actualCoordinate = annotation.coordinate;
//            CLLocationCoordinate2D containerCoordinate = annotation.clusterAnnotation.coordinate;
//            
//            // since it's displayed on the map, it is no longer contained by another annotation,
//            // (We couldn't reset this in -updateVisibleAnnotations because we needed the reference to it here
//            // to get the containerCoordinate)
//            view.clusterAnnotation = nil;
//            
//            annotation.coordinate = containerCoordinate;
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                annotation.coordinate = actualCoordinate;
//            }];
//        }
//    }
}


- (void)addDropAnimationTo:(UIView *)view endFrame:(CGRect)endFrame {
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         view.frame = endFrame;
                     }
                     completion:^(BOOL finished) {
                         if(finished) {
                             [self addSquashAnimationTo:view];
                         }
                     }];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
