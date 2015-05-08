//
//  ViewController.m
//  SleepTracker
//
//  Created by Garcia Nolasco, M. on 5/7/15.
//  Copyright (c) 2015 Garcia Nolasco, M. All rights reserved.
//

#import "ViewController.h"

int DEFAULT_TIME = 60;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
                         
                         
                         
                         self.btnSleepAwake.frame = CGRectMake(self.btnSleepAwake.frame.origin.x, self.lblInfoMessage.frame.origin.y + 20.0, self.btnSleepAwake.frame.size.width, self.btnSleepAwake.frame.size.height);
                         
                         
                         
                     }
                     completion:^(BOOL finished) {
                         [self.btnSleepAwake setTitle:@"Awake" forState:UIControlStateNormal];
                     }
     
     
     ];
    
    
    
}

-(void)awake{
    
    
}

@end
