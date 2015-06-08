//
//  TableViewInformations.m
//  TestProjV2
//
//  Created by Dima on 21.05.15.
//  Copyright (c) 2015 Dima. All rights reserved.
//

#import "TPTableViewInformations.h"

@implementation TPTableViewInformations

- (id)init {
    
    self=[super init];
    if(self){
        self.coordinateLat = nil;
        self.coordinateLong = nil;
        self.imageName = nil;
        self.annotationsImage = nil;
        self.soundRecord = nil;
    }
    return self;
}

@end
