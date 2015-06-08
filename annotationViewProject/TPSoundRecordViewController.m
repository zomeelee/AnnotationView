//
//  SaveViewController.h
//  TestProjV2
//
//  Created by Dima on 02.05.15.
//  Copyright (c) 2015 Dima. All rights reserved.
//

#import "TPSoundRecordViewController.h"
#import "AppDelegate.h"

@interface TPSoundRecordViewController (){
    
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    __weak IBOutlet UILabel *theLabelTimeProgress;
    __weak IBOutlet UIProgressView *theMyProgressViewer;
    NSTimer *timer;
    int currSeconds;
}

@property (weak, nonatomic) IBOutlet UIToolbar *thetoolbarSound;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *recordPauseButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *stopButton;

- (void)recordPauseTapped;
- (void)stopTapped;
- (void)start;
- (void)timerFired;

@end

@implementation TPSoundRecordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    srandom(time(NULL));
    
    // SetTimer
    theLabelTimeProgress.textColor=[UIColor redColor];
    [theLabelTimeProgress setText:@"Time : 0:30"];
    currSeconds=30;
    
    // Disable Stop/Play button when application launches
    self.recordPauseButton = [[UIBarButtonItem alloc]initWithTitle:@"Record"style: UIBarButtonItemStylePlain target:self action: @selector(recordPauseTapped)];
    self.stopButton = [[UIBarButtonItem alloc]initWithTitle:@"Stop"style: UIBarButtonItemStylePlain target:self action: @selector(stopTapped)];
    
    [self.thetoolbarSound setHidden:NO];
    [self.thetoolbarSound setBarStyle: UIBarStyleBlackOpaque];
    [self.thetoolbarSound setItems:[NSArray arrayWithObjects:_recordPauseButton, _stopButton, nil] animated:YES];
    [self.stopButton setEnabled:NO];
    
    int a = arc4random() % 100;
    int b = arc4random() % 300;
    NSString *stringPath = [NSString stringWithFormat:@"%i%s%i%@",a ,"__",b , @"_MyAudioMemo.m4a"];

    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                 stringPath,
                                        nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    [TPSaveInformationContainer sharedManager].soundRecord = [outputFileURL absoluteString];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
    UIBarButtonItem *btSave = [[UIBarButtonItem alloc]initWithTitle:@"Next"style: UIBarButtonItemStylePlain target:self action: @selector(ChangeView)];
    self.navigationItem.rightBarButtonItem = btSave;
}

- (void)ChangeView {
    
     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
     TPSaveViewController *SVC = [mainStoryboard instantiateViewControllerWithIdentifier: @"SaveView"];
     [self.navigationController pushViewController:SVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)start {
    
    theMyProgressViewer.progress = 0.0f;
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void)recordPauseTapped {
    
    if (!recorder.recording){
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        [self start];
        [_stopButton setEnabled:NO];
    }
    
    [_recordPauseButton setEnabled:NO];
    [_stopButton setEnabled:YES];
}

- (void)stopTapped {
    
    [_recordPauseButton setEnabled:YES];
    [_stopButton setEnabled:NO];
    [recorder stop];
    currSeconds=30;
    [timer invalidate];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag {
    
    [_recordPauseButton setTitle:@"Record"];
    [_stopButton setEnabled:NO];
}

- (void)timerFired {
    
    if(currSeconds>0){
        
        if(currSeconds>0){
            
            currSeconds-=1;
        }
        if(currSeconds>-1){
            
            theMyProgressViewer.progress = theMyProgressViewer.progress + 0.0333f;
            [theLabelTimeProgress setText:[NSString stringWithFormat:@"%@%02d", @"Time 0:",currSeconds]];
        }
    }
    else if(currSeconds == 0){
        
        [self stopTapped];
    }
}

@end