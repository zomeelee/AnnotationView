//
//  ChoosingSourceView.m
//  TestProjV2
//
//  Created by Dima on 29.04.15.
//  Copyright (c) 2015 Dima. All rights reserved.
//

#import "TPChoosingSourceViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MapKit/MapKit.h>

@interface TPChoosingSourceViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *pictureOutput;
@property (weak, nonatomic) IBOutlet UITextField *TextFieldForPictureName;
@property (strong, nonatomic) NSMutableArray *images;

- (void)ChangeView;

@end

@implementation TPChoosingSourceViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    //self.pictureOutput.contentMode = UIViewContentModeScaleAspectFit;
    self.images = [NSMutableArray array];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    UIBarButtonItem *btNext = [[UIBarButtonItem alloc]initWithTitle:@"Next"style: UIBarButtonItemStylePlain target:self action: @selector(ChangeView)];
    self.navigationItem.rightBarButtonItem = btNext;
}

- (void)viewDidAppear:(BOOL)animated{
    
    if([TPSaveInformationContainer sharedManager].annotationsImage == nil){
        
        [self ACtShow];
    }
    else{
        
        self.pictureOutput.image = [TPSaveInformationContainer sharedManager].annotationsImage;
    }
}

- (void)ChangeView{
    
    if([TPSaveInformationContainer sharedManager].imageName == nil || [[TPSaveInformationContainer sharedManager].imageName isEqual: @""]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message!"
                                                        message: @"Please, write text"
                                                       delegate: self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        TPMapViewController *MVC = [mainStoryboard instantiateViewControllerWithIdentifier: @"RecordView"];
        [self.navigationController pushViewController:MVC animated:YES];
    }
}

- (void)ACtShow{
    
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"Library",@"Camera",nil];
    
    [actSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0){
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
    else if(buttonIndex == 1){
        
        [self takePhoto];
    }
    else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)takePhoto{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TPTakePhotoViewController *TPVC = [mainStoryboard instantiateViewControllerWithIdentifier: @"TakePhoto"];
    [self presentViewController:TPVC animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *pickedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (pickedImage){
        
        [self.images addObject:pickedImage];
        [TPSaveInformationContainer sharedManager].annotationsImage = pickedImage;
        self.pictureOutput.image = [self.images lastObject];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    
    if ([sender isEqual:_TextFieldForPictureName]){
        
      [TPSaveInformationContainer sharedManager].imageName = _TextFieldForPictureName.text;
    }
}

- (void)dismissKeyboard{
    
    [_TextFieldForPictureName resignFirstResponder];
}
@end