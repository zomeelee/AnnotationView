//
//  MapViewController.h
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
#import "TPSaveInformationContainer.h"
#import "TPAnnotationView.h"

#define WIMB_LATITUDE 47.838800;
#define WINB_LONGITUDE 35.139567;
#define THE_SPAN 0.02f;

@interface TPMapViewController : UIViewController <MKMapViewDelegate,  CLLocationManagerDelegate, UIActionSheetDelegate, UIToolbarDelegate>

@end
