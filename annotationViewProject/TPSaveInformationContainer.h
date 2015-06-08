//
//  Annotation.h
//  TestProjV2
//
//  Created by Dima on 29.04.15.
//  Copyright (c) 2015 Dima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>

@interface TPSaveInformationContainer : NSObject

@property (strong, nonatomic) NSNumber *coordinateLat;
@property (strong, nonatomic) NSNumber *coordinateLong;
@property (strong, nonatomic) UIImage  *annotationsImage;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *soundRecord;

+ (TPSaveInformationContainer *)sharedManager;

@end
