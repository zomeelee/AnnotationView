//
//  SoundRecordView.h
//  TestProjV2
//
//  Created by Dima on 30.04.15.
//  Copyright (c) 2015 Dima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreData/CoreData.h>
#import "TPSaveInformationContainer.h"
#import "TPSaveViewController.h"

@interface TPSoundRecordViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIToolbarDelegate>

@end