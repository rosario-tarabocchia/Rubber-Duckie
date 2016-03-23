//
//  ViewController.m
//  Rubber Duckie
//
//  Created by Rosario Tarabocchia on 3/23/16.
//  Copyright © 2016 RLDT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *duckImageView;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressOutlet;
@property (strong, nonatomic) UIImage *duckImage;
@property (assign, nonatomic) NSUInteger animationNumber;
@property (assign, nonatomic) BOOL touchDownOnImageView;
@property (assign, nonatomic) BOOL touchCancelOnImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.longPressOutlet = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.duckImageView addGestureRecognizer:self.longPressOutlet];
    
    self.duckImage = [UIImage imageNamed:@"duck0"];
    [self.duckImageView setImage:self.duckImage];
    
    self.animationNumber = 0;
    
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)longPressAction:(UILongPressGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    
    {
        
        NSLog(@"TOUCH PRESSED AND %lu", self.animationNumber);
        
        self.touchCancelOnImageView = NO;
        
        [self pushDownOnImage];

        
        
    }
    
    
    else
    {
        if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateFailed || recognizer.state == UIGestureRecognizerStateEnded)
        {
            NSLog(@"TOUCH CANCELED AND %lu", self.animationNumber);
            
            self.touchCancelOnImageView = YES;
            
            [self imageLetGo];
            
            
            
        }
    }
}

-(void)animateSinking {
    
    NSUInteger imageNumber = self.animationNumber + 1;
    NSString *imageName = [NSString stringWithFormat:@"duck%lu", imageNumber];
    self.duckImage = [UIImage imageNamed:imageName];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView transitionWithView:self.duckImageView duration:.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            NSLog(@"Getting to Animate SINKING?");
            
            [self.duckImageView setImage:self.duckImage];
            
        } completion:^(BOOL finished) {
            
            self.animationNumber += 1;
            
            [self pushDownOnImage];

        }];
        
    });
    
}

-(void)pushDownOnImage {
    
    NSLog(@"Getting here to PUSHDOWNIMAGE");
    
    if (self.animationNumber == 0 && self.touchCancelOnImageView == NO) {
        
        NSLog(@"Getting here to PUSHDOWNIMAGE 0");
        
        [self animateSinking];
    }
    
    if (self.animationNumber == 1 && self.touchCancelOnImageView == NO) {
        
        NSLog(@"Getting here to PUSHDOWNIMAGE 1");
        
        [self animateSinking];
    }
    
    if (self.animationNumber == 2 && self.touchCancelOnImageView == NO) {

        NSLog(@"Getting here to PUSHDOWNIMAGE 2");
        
        [self animateSinking];
    }
    
    if (self.animationNumber == 3 && self.touchCancelOnImageView == NO) {
        
        NSLog(@"Getting here to PUSHDOWNIMAGE 3");
        
        [self animateSinking];
    }
    
    if (self.animationNumber == 4 && self.touchCancelOnImageView == NO) {
        
        NSLog(@"Getting here to PUSHDOWNIMAGE 4");
        
        [self animateSinking];
    }
    
    if (self.animationNumber == 5 && self.touchCancelOnImageView == NO) {
        
        NSLog(@"Getting here to PUSHDOWNIMAGE 5");
        
        [self animateSinking];
    }
    
    if (self.animationNumber == 6 && self.touchCancelOnImageView == NO) {
        
        NSLog(@"Getting here to PUSHDOWNIMAGE 6");
        
        [self animateSinking];
    }
    
    if (self.animationNumber == 7 && self.touchCancelOnImageView == NO) {
        
        NSLog(@"Getting here to PUSHDOWNIMAGE 7");
        
        
        self.touchCancelOnImageView = YES;
    }
    
}


-(void)animateRising {
    
    NSUInteger imageNumber = self.animationNumber - 1;
    NSString *imageName = [NSString stringWithFormat:@"duck%lu", imageNumber];
    self.duckImage = [UIImage imageNamed:imageName];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView transitionWithView:self.duckImageView duration:.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            NSLog(@"Gettin to animate RISING?");
            
            [self.duckImageView setImage:self.duckImage];
            
        } completion:^(BOOL finished) {
            
            self.animationNumber -= 1;
            
            [self imageLetGo];
            
        }];
        
    });
    
}

-(void)imageLetGo {
    
    NSLog(@"Getting here");
    
    if (self.animationNumber == 7 && self.touchCancelOnImageView == YES) {
        
        [self animateRising];
    }
    
    if (self.animationNumber == 6 && self.touchCancelOnImageView == YES) {
        
        [self animateRising];
    }
    
    if (self.animationNumber == 5 && self.touchCancelOnImageView == YES) {
        
        [self animateRising];
    }
    
    if (self.animationNumber == 4 && self.touchCancelOnImageView == YES) {
        
        [self animateRising];
    }
    
    if (self.animationNumber == 3 && self.touchCancelOnImageView == YES) {
        
        [self animateRising];
    }
    
    if (self.animationNumber == 2 && self.touchCancelOnImageView == YES) {
        
        [self animateRising];
    }
    
    if (self.animationNumber == 1 && self.touchCancelOnImageView == YES) {
        
        [self animateRising];
    }
    
    if (self.animationNumber == 0 && self.touchCancelOnImageView == YES) {
        
        self.touchCancelOnImageView = NO;
    }
    

    
}

@end
