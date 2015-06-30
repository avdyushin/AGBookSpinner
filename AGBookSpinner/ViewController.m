//
//  ViewController.m
//  AGBookSpinner
//
//  Created by Grigory Avdyushin on 30.06.15.
//  Copyright (c) 2015 Grigory Avdyushin. All rights reserved.
//

#import "ViewController.h"
#import "AGBookSpinner.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet AGBookSpinner *spinner;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.spinner.hidesWhenStopped = NO;
    self.spinner.tintColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onStartStopPressed:(UIButton *)sender {
    if (self.spinner.isAnimating) {
        [self.spinner stopAnimating];
        [sender setTitle:NSLocalizedString(@"Resume", nil) forState:UIControlStateNormal];
    } else {
        [self.spinner startAnimating];
        [sender setTitle:NSLocalizedString(@"Pause", nil) forState:UIControlStateNormal];
    }
}

@end
