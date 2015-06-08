//
//  ChoosingSourceView.h
//  TestProjV2
//
//  Created by Dima on 29.04.15.
//  Copyright (c) 2015 Dima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AVFoundation/AVFoundation.h"
#import <CoreData/CoreData.h>
#import "TPSaveInformationContainer.h"
#import "TPSoundRecordViewController.h"
#import "TPTakePhotoViewController.h"
#import "TPMapViewController.h"

@interface TPChoosingSourceViewController : UIViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate>

@end
