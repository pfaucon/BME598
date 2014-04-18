//
//  ViewController.m
//  BME598_final_project
//
//  Created by philippe faucon on 4/16/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *humidityLabel;
@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (strong, nonatomic) IBOutlet UITextField *desiredTempField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)updateReadings:(id)sender {
    
    [[XivelyManager sharedInstance] requestUpdateWithCallback:^{
//        self.humidityLabel.text = [NSString stringWithFormat:@"%.2f%%",[XivelyManager sharedInstance].humidity.currentValue];
//        self.temperatureLabel.text = [NSString stringWithFormat:@"%.2f°",[XivelyManager sharedInstance].temperature.currentValue];
    }];
}

- (IBAction)setTemperature:(id)sender {
    [[XivelyManager sharedInstance] setDesiredTemperature:self.desiredTempField.text.doubleValue];
}

@end
