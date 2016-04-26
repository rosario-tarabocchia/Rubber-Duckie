//
//  RPTIntroViewController.m
//  Rubber Duckie
//
//  Created by Rosario Tarabocchia on 4/18/16.
//  Copyright © 2016 RLDT. All rights reserved.
//

#import "RPTIntroViewController.h"
#import "RPTDuckDataStore.h"

@interface RPTIntroViewController ()

@property (strong, nonatomic) RPTDuckDataStore *dataStore;

@end

@implementation RPTIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataStore = [RPTDuckDataStore sharedDataStore];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"redDuck"]) {
        self.dataStore.duckColor = @"red";
    }
    
    if ([segue.identifier isEqualToString:@"yellowDuck"]) {
        self.dataStore.duckColor = @"yellow";
    }
   
    if ([segue.identifier isEqualToString:@"orangeDuck"]) {
        self.dataStore.duckColor = @"orange";
    }
    
    if ([segue.identifier isEqualToString:@"greenDuck"]) {
        self.dataStore.duckColor = @"green";
    }
    if ([segue.identifier isEqualToString:@"purpleDuck"]) {
        self.dataStore.duckColor = @"purple";
    }

}


@end
