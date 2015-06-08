//
//  SaveViewController.m
//  TestProjV2
//
//  Created by Dima on 02.05.15.
//  Copyright (c) 2015 Dima. All rights reserved.
//

#import "TPSaveViewController.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "TPSaveInformationContainer.h"

@implementation TPSaveViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Save objects
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newObject;
    
    newObject = [NSEntityDescription insertNewObjectForEntityForName:@"AnnotationStore" inManagedObjectContext:context];
    [newObject setValue: [TPSaveInformationContainer sharedManager].coordinateLat forKey:@"coordinateLat"];
    [newObject setValue: [TPSaveInformationContainer sharedManager].coordinateLong forKey:@"coordinateLong"];
    [newObject setValue: [TPSaveInformationContainer sharedManager].imageName forKey:@"name"];
    [newObject setValue: UIImageJPEGRepresentation([TPSaveInformationContainer sharedManager].annotationsImage, 1) forKey:@"picture"];
    [newObject setValue: [TPSaveInformationContainer sharedManager].soundRecord forKey:@"sound"];
    NSError *error;
    [context save:&error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message!"
                                                    message: @"Save Done!"
                                                   delegate: self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0){
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
        UIAlertView *Newalert = [[UIAlertView alloc] initWithTitle: @"Message!"
                                                        message: @"Error Saving!"
                                                       delegate: self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [Newalert show];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end