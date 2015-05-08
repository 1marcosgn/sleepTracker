//
//  ViewController.h
//  SleepTracker
//
//  Created by Garcia Nolasco, M. on 5/7/15.
//  Copyright (c) 2015 Garcia Nolasco, M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UIButton *btnEmoji;
@property (weak, nonatomic) IBOutlet UILabel *lblInfoMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnSleepAwake;

#pragma mark - Methods
- (IBAction)incrementDefaultTime:(id)sender;
- (IBAction)goSleepAwake:(id)sender;

@end

