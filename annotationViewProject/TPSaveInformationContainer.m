//
//  Annotation.m
//  TestProjV2
//
//  Created by Dima on 29.04.15.
//  Copyright (c) 2015 Dima. All rights reserved.
//

#import "TPSaveInformationContainer.h"

@implementation TPSaveInformationContainer

+ (TPSaveInformationContainer *)sharedManager{
    
    static TPSaveInformationContainer* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TPSaveInformationContainer alloc] init];
    });
    
    return manager;
}

@end
