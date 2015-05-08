//
//  ViewController.m
//  SleepTracker
//
//  Created by Garcia Nolasco, M. on 5/7/15.
//  Copyright (c) 2015 Garcia Nolasco, M. All rights reserved.
//

#import "ViewController.h"
#import "mySingleton.h"
#import <HealthKit/HealthKit.h>

int DEFAULT_TIME = 60;

@interface ViewController (){
    
    UILabel *countLabel;
    NSTimer *timer;
    HKHealthStore *healthStore;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mySingleton *singleton = [mySingleton sharedSinleton];
    healthStore = singleton.healthStoreGlobal;
    
    //Customize Navbar
    UIColor *topBarColor = [UIColor colorWithRed:99.0f/255.0f green:148.0f/255.0f blue:207.0f/255.0f alpha:1.0];
    self.navigationController.navigationBar.barTintColor = topBarColor;
    
    CGRect frame = CGRectMake(0, 0, 70, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"SleepTracker";
    self.navigationItem.titleView = label;
    
    //Customize Count Label
    countLabel = [[UILabel alloc]init];
    countLabel.textAlignment = NSTextAlignmentCenter;
    [countLabel setFont:[UIFont fontWithName:@"Time-Normal" size:44.0]];
    countLabel.backgroundColor = [UIColor colorWithRed:99.0f/255.0f green:148.0f/255.0f blue:207.0f/255.0f alpha:1.0];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.frame = CGRectMake(self.btnSleepAwake.frame.origin.x - 113, self.btnSleepAwake.frame.origin.y, self.btnSleepAwake.frame.size.width, self.btnSleepAwake.frame.size.height);
    [countLabel setHidden:YES];
    [self.view addSubview:countLabel];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)incrementDefaultTime:(id)sender {
    
    DEFAULT_TIME = DEFAULT_TIME + 60;

    //Graphic animation...
    UILabel *lblPoints = [[UILabel alloc]init];
    lblPoints.textColor = [UIColor blackColor];
    [lblPoints setFrame:self.btnEmoji.frame];
    lblPoints.backgroundColor = [UIColor clearColor];
    lblPoints.text = @"+1min";
    [lblPoints setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:44.0]];
    [self.view addSubview:lblPoints];
    
    [lblPoints setAlpha:0.5];
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{ lblPoints.alpha = 0;} completion:nil];
    
    
}

- (IBAction)goSleepAwake:(id)sender {
    
    if([sender tag] == 0){
        // 'Go to sleep' code here...
        self.btnSleepAwake.tag = 1;
        [self goToSleep];
        
    }
    else if ([sender tag] == 1){
        // 'Awake' code here...
        self.btnSleepAwake.tag = 0;
        [self awake];
    }
    
}

-(void)goToSleep{
    
    self.lblInfoMessage.alpha = 0.0;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         self.contraintTopDistance.constant = 50;
                         [self.view layoutIfNeeded];
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [self.btnSleepAwake setTitle:@"Wake Up" forState:UIControlStateNormal];
                         [self.btnEmoji setUserInteractionEnabled:NO];
                         [self.btnEmoji setImage:[UIImage imageNamed:@"sleep.png"] forState:UIControlStateNormal];
                         
                         [countLabel setHidden:NO];
                         
                         // Create timer here..
                         [self setTimer];
                         
                     }
     ];
    
}

-(void)setTimer{
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                      target: self
                                                    selector: @selector(updateTimer)
                                                    userInfo: nil
                                                     repeats: YES];
    NSLog(@"timer is:%@", timer);

}

-(void)updateTimer{
    
    int hours, minutes, seconds;
    
    DEFAULT_TIME++;
    hours = DEFAULT_TIME / 3600;
    minutes = (DEFAULT_TIME % 3600) / 60;
    seconds = (DEFAULT_TIME % 3600) % 60;
    
    countLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    
}

-(void)awake{
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.contraintTopDistance.constant = 221;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         
                         // Store information in HealthKit...
                         [self createNewSleepAnalysisRegister];
                         
                         
                         DEFAULT_TIME = 60;
                         [self.btnEmoji setUserInteractionEnabled:YES];
                         [self.btnEmoji setImage:[UIImage imageNamed:@"awake.png"] forState:UIControlStateNormal];
                         [self.btnSleepAwake setTitle:@"Sleep" forState:UIControlStateNormal];
                         
                         self.lblInfoMessage.text = @"Sleep Analysis was recorded on your HealthKit";
                         self.lblInfoMessage.alpha = 1.0;
                         
                         // Reset timer here...
                         [countLabel setHidden:YES];
                         [timer invalidate];
                         [self updateTimer];
                         
                     }];
    
}


-(void)createNewSleepAnalysisRegister{
    
    // Create an instance of HKCategoryType
    // to specify the data type that it's going to be updated
    HKCategoryType *hkCategoryType = [HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [self getEndDate];
    
    // The value has to be selected between two options 'HKCategoryValueSleepAnalysisAsleep' or 'HKCategoryValueSleepAnalysisInBed'
    // HealthKit uses two or more samples with overlapping times.
    HKCategorySample *sleepSample = [HKCategorySample categorySampleWithType:hkCategoryType
                                                                       value:HKCategoryValueSleepAnalysisAsleep
                                                                   startDate:startDate
                                                                     endDate:endDate];
    
    //Update the sleep activity in the health store
    [healthStore saveObject:sleepSample withCompletion:^(BOOL success, NSError *error){
        
        NSLog(@"Sleep activity stored");
        
    }];
    
    
}

-(NSDate*)getEndDate{
    
    NSDate *currentDate = [NSDate date];
    NSDate *datePlus = [currentDate dateByAddingTimeInterval:DEFAULT_TIME];
    return datePlus;
    
}

@end
