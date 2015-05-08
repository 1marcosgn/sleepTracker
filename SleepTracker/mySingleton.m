//
//  mySingleton.m
//  healthTest
//
//  Created by Marcos Garcia on 5/6/15.
//  Copyright (c) 2015 marcos. All rights reserved.
//

#import "mySingleton.h"

@implementation mySingleton

@synthesize healthStoreGlobal;

#pragma mark - Singleton Methods

+(id)sharedSinleton{
    
    static mySingleton *sharedMySingleton = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        
        sharedMySingleton = [[self alloc]init];
    
    });
    
    return sharedMySingleton;
    
}

-(id)init{
    
    if (self = [super init]) {
        healthStoreGlobal = [[HKHealthStore alloc] init];
    }
    return self;
    
}

@end
