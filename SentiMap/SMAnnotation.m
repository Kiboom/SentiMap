//
//  SMAnnotation.m
//  SentiMap
//
//  Created by 김기범 on 2016. 4. 29..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import "SMAnnotation.h"

@implementation SMAnnotation

- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate icon:(UIImage *)icon justExpressed:(BOOL)justExpressed{
    if(self = [super init]) {
        _title = title;
        _coordinate = coordinate;
        _icon = icon;
        _justExpressed = justExpressed;
    }
    return self;
}

- (MKAnnotationView *)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self
                                                                    reuseIdentifier:[NSString stringWithFormat:@"%@Annotation",_title]];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = _icon;
    return annotationView;
}

@end
