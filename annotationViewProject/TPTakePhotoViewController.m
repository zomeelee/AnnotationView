//
//  TakePhotoViewController.m
//  TestProjV2
//
//  Created by Dima on 18.05.15.
//  Copyright (c) 2015 Dima. All rights reserved.
//

#import "TPTakePhotoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TPTakePhotoViewController ()

- (IBAction)takePhoto:(id)sender;
- (BOOL)shouldAutorotate;

@end

@implementation TPTakePhotoViewController

AVCaptureSession *session;
AVCaptureStillImageOutput *stillImageOutput;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    session = [[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    
    if([session canAddInput:deviceInput]){
        
        [session addInput:deviceInput];
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = [self.view.layer bounds];
    [previewLayer setFrame:frame];
    [rootLayer insertSublayer:previewLayer atIndex:0];
    stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    [session addOutput:stillImageOutput];
    [session startRunning];
}

- (IBAction)takePhoto:(id)sender {
    
    AVCaptureConnection *videoConnection = nil;
    for(AVCaptureConnection *connection in stillImageOutput.connections){
        
        for(AVCaptureInputPort *port in [connection inputPorts]){
            
            if([[port mediaType] isEqual:AVMediaTypeVideo]){
                
                videoConnection = connection;
                break;
            }
        }
        if(videoConnection){
            
            break;
        }
    }
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if(imageDataSampleBuffer != NULL){
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            [TPSaveInformationContainer sharedManager].annotationsImage = image;
            [self dismissViewControllerAnimated:YES completion:NULL];
        }}];
}

- (IBAction)BackViewbutton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotate{
    
    return NO;
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
}
@end
