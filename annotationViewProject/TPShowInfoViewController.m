//
//  ShowInfoViewViewController.m
//  TestProjV2
//
//  Created by Dima on 01.05.15.
//  Copyright (c) 2015 Dima. All rights reserved.
//

#import "TPShowInfoViewController.h"

@interface TPShowInfoViewController (){
    
    AVAudioPlayer *player;
    NSURL *SoungPath;
}
@property (weak, nonatomic) IBOutlet UIToolbar *thetoolbarSound;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewer;

- (IBAction)playTapped:(id)sender;

@end

@implementation TPShowInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title =  self.containerView.imageName;
    self.ImageViewer.contentMode = UIViewContentModeScaleAspectFit;
    self.ImageViewer.image = self.containerView.annotationsImage;
    SoungPath = [[NSURL alloc] initWithString:self.containerView.soundRecord];
    [self.thetoolbarSound setHidden:NO];
    [self.thetoolbarSound setBarStyle: UIBarStyleBlackOpaque];
    [self.thetoolbarSound setItems:[NSArray arrayWithObjects:_playButton, nil]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHideNavbar:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)showHideNavbar:(id) sender {
    
    if (self.navigationController.navigationBar.hidden == NO){
        
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self.thetoolbarSound setHidden:YES];
    } else if (self.navigationController.navigationBar.hidden == YES){
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.thetoolbarSound setHidden:NO];
    }
}

- (IBAction)playTapped:(id)sender {
    
    if(!player.playing){
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:SoungPath error:nil];
        [player setDelegate:self];
        [player play];
        [self.playButton setTitle:@"Pause"];
    } else {
        
        [self.playButton setTitle:@"Play"];
        [player stop];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    [self.playButton setTitle:@"Play"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end