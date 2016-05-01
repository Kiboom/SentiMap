//
//  SMLocationSearchTable.h
//  SentiMap
//
//  Created by 김기범 on 2016. 5. 1..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol HandleMapSearchDelegate
- (void)goToSearchedLocation:(nonnull MKPlacemark *)placemark;
@end


@interface SMLocationSearchTable : UITableViewController <UISearchResultsUpdating>
@property(nullable) MKMapView *map;
@property(nullable) NSArray<MKMapItem *> *matchingItems;
@property(nullable,nonatomic,weak) id <HandleMapSearchDelegate> delegate;
@property(nullable) NSNotificationCenter *notiCenter;
@end
