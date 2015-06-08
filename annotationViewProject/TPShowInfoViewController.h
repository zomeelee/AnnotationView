//
//  ShowInfoViewViewController.h
//  TestProjV2
//
//  Created by Dima on 01.05.15.
//  Copyright (c) 2015 Dima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>
#import "TPSaveInformationContainer.h"
#import "TPTableViewInformations.h"

@interface TPShowInfoViewController : UIViewController <AVAudioPlayerDelegate, UIToolbarDelegate>

@property (strong, nonatomic) TPTableViewInformations *containerView;

@end
