//
//  AnnotationView.h
//  TestProjV2
//
//  Created by Dima on 18.05.15.
//  Copyright (c) 2015 Dima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>

@interface TPAnnotationView : MKAnnotationView <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIImage *image;

@end
