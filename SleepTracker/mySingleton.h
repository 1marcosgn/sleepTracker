//
//  mySingleton.h
//  healthTest
//
//  Created by Marcos Garcia on 5/6/15.
//  Copyright (c) 2015 marcos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface mySingleton : NSObject{
    
    HKHealthStore *healthStoreGlobal;
    
}

@property (nonatomic, retain) HKHealthStore *healthStoreGlobal;

+ (id)sharedSinleton;

@end
