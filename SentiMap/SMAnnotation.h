//
//  SMAnnotation.h
//  SentiMap
//
//  Created by 김기범 on 2016. 4. 29..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SMAnnotation : NSObject <MKAnnotation>

@property UIImage *icon;
@property BOOL justExpressed;
@property (copy, nonatomic) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate icon:(UIImage *)icon justExpressed:(BOOL)justExpressed;
- (MKAnnotationView *)annotationView;

@end
