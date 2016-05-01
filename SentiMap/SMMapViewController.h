//
//  SMMapViewController.h
//  SentiMap
//
//  Created by 김기범 on 2016. 4. 29..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SMAnnotation.h"
#import "SMLocationSearchTable.h"
#import "AFHTTPSessionManager.h"

@interface SMMapViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, HandleMapSearchDelegate>

/* URL request info */
@property NSString *serverURL;

/* camera start pos */
@property double latitude;
@property double longitude;

/* moods data */
@property int mood;
@property NSDictionary *jsonData;
@property NSMutableArray *receivedMoods;
@property NSMutableArray *receivedLats;
@property NSMutableArray *receivedLons;
@property NSArray *moodInfo;

/* map view */
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property MKMapView *allAnnotationsMapView;

/* search */
@property UISearchController *resultSearchController;

/* notification */
@property NSNotificationCenter *notiCenter;

- (IBAction)goToCurrentLocation:(id)sender;

@end
