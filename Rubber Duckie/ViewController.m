//
//  ViewController.m
//  Rubber Duckie
//
//  Created by Rosario Tarabocchia on 3/23/16.
//  Copyright © 2016 RLDT. All rights reserved.
//

#import "ViewController.h"
#import "Duck.h"


@interface ViewController () <UIGestureRecognizerDelegate, UICollisionBehaviorDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewCenterX;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewCenterY;
@property (strong, nonatomic) IBOutlet Duck *duckImageView;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressOutlet;
@property (strong, nonatomic) UIImage *duckImage;
@property (assign, nonatomic) NSUInteger animationNumber;
@property (assign, nonatomic) NSUInteger animateWobbleNumber;
@property (assign, nonatomic) BOOL touchDownOnImageView;
@property (assign, nonatomic) BOOL touchCancelOnImageView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIDynamicItemBehavior *duckBehaviors;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;

@property (nonatomic) CGFloat xDuckFloat;
@property (nonatomic) CGFloat yDuckFloat;
@property (nonatomic) UICollisionBehavior *collisionThing;

@property (nonatomic) UIGravityBehavior *gravity;
@property (nonatomic) CMMotionManager *motionManager;
@property (nonatomic) NSOperationQueue *motionQueue;

@property (strong, nonatomic) IBOutlet UIImageView *imageView2;

@property (nonatomic, assign) CGRect originalBounds;
@property (nonatomic, assign) CGPoint originalCenter;

@property (strong, nonatomic) IBOutlet UIImageView *waterWaves2View;
@property (strong, nonatomic) IBOutlet UIImageView *waterWaves1View;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.duckImageView.clipsToBounds = YES;
    
    self.originalBounds = self.view.bounds;
    self.originalCenter = self.view.center;
    self.longPressOutlet = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.duckImageView addGestureRecognizer:self.longPressOutlet];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(fingerMoving:)];
    [self.duckImageView addGestureRecognizer:self.panGesture];
    
    self.duckImage = [UIImage imageNamed:@"duck0"];
    [self.duckImageView setImage:self.duckImage];
    
    self.animationNumber = 0;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    
    self.collisionThing = [[UICollisionBehavior alloc] initWithItems:@[self.duckImageView]];
   
    
    
    self.collisionThing.translatesReferenceBoundsIntoBoundary = YES;

    
    self.collisionThing.collisionMode = UICollisionBehaviorModeEverything;
    
    [self.animator addBehavior:self.collisionThing];
    
    
    
    self.duckBehaviors = [[UIDynamicItemBehavior alloc]initWithItems:@[self.duckImageView]];
    self.duckBehaviors.density = .7;
    self.duckBehaviors.elasticity = .3;
    self.duckBehaviors.resistance = .7;
    self.duckBehaviors.friction = 1.5;
    self.duckBehaviors.resistance = 1.0;
    self.duckBehaviors.allowsRotation = YES;
    [self.animator addBehavior:self.duckBehaviors];
    
    UIDynamicItemBehavior *resistanceBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.duckImageView]];
    resistanceBehavior.resistance = 1.0;
    [self.animator addBehavior:resistanceBehavior];
    
    
    [self.collisionThing addBoundaryWithIdentifier:@"wall"
                          fromPoint:CGPointMake(15,15)
                            toPoint:CGPointMake(self.view.bounds.size.width - 15,
                                                15)];
    
    [self.collisionThing addBoundaryWithIdentifier:@"wall1"
                                         fromPoint:CGPointMake(15,15)
                                           toPoint:CGPointMake(15,
                                                               self.view.bounds.size.height - 15)];
    
    [self.collisionThing addBoundaryWithIdentifier:@"wall2"
                                         fromPoint:CGPointMake(15,
                                                               self.view.bounds.size.height - 15)
                                           toPoint:CGPointMake(self.view.bounds.size.width - 15, self.view.bounds.size.height - 15)];
    
    [self.collisionThing addBoundaryWithIdentifier:@"wall2"
                                         fromPoint:CGPointMake(self.view.bounds.size.width - 15, 15)
                                           toPoint:CGPointMake(self.view.bounds.size.width - 15, self.view.bounds.size.height - 15)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    
    [UIView animateKeyframesWithDuration:10.0 delay:0.0 options:UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:5 animations:^{
            self.waterWaves1View.alpha = 0;
            self.waterWaves2View.alpha = 1;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:7.5 animations:^{
            self.waterWaves1View.alpha = 1;
            self.waterWaves2View.alpha = 0;
        }];
    } completion:nil];
    
    
    
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

    
        [UIView transitionWithView:self.duckImageView duration:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            NSLog(@"Getting to Animate SINKING?");
            
            [self.duckImageView setImage:self.duckImage];
            
        } completion:^(BOOL finished) {
            
            self.animationNumber += 1;
            
            [self pushDownOnImage];

        }];
        


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
    

    
        [UIView transitionWithView:self.duckImageView duration:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            NSLog(@"Gettin to animate RISING?");
            
            [self.duckImageView setImage:self.duckImage];
            
        } completion:^(BOOL finished) {
            
            self.animationNumber -= 1;
            
            [self imageLetGo];
            
        }];
        

    
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
        
        self.animateWobbleNumber = 0;
        
        [self wobble];
    }
    

    
}

-(void)animateWobble {
    
//    NSUInteger imageNumber = self.animateWobbleNumber + 1;
//    NSString *imageName = [NSString stringWithFormat:@"duckup%lu", imageNumber];
//    self.duckImage = [UIImage imageNamed:imageName];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView transitionWithView:self.duckImageView duration:.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            NSLog(@"Gettin to animate WOBBLE?");
            
            [self.duckImageView setImage:self.duckImage];
            
        } completion:^(BOOL finished) {
            
            self.animateWobbleNumber += 1;
            
            [self wobble];
            
        }];
        
    });
    
}

-(void)wobble {
    
    NSLog(@"%lu", self.animateWobbleNumber);
    
    if (self.animateWobbleNumber == 0 && self.touchCancelOnImageView == YES) {
        
        self.duckImage = [UIImage imageNamed:@"testBig"];
        
        [self animateWobble];
    }
    
    if (self.animateWobbleNumber == 1 && self.touchCancelOnImageView == YES) {
        
        self.duckImage = [UIImage imageNamed:@"testduck1"];
        
        [self animateWobble];
    }
    
    if (self.animateWobbleNumber == 2 && self.touchCancelOnImageView == YES) {
        
        self.duckImage = [UIImage imageNamed:@"testduck3"];
        
        [self animateWobble];
    }
    
    if (self.animateWobbleNumber == 3 && self.touchCancelOnImageView == YES) {
        
        
        self.duckImage = [UIImage imageNamed:@"duck0"];

        
        [self animateWobble];
    }
    
    if (self.animateWobbleNumber == 4 && self.touchCancelOnImageView == YES) {
        
        self.touchCancelOnImageView = NO;
    }
    
    
    
}

-(IBAction)fingerMoving:(UIPanGestureRecognizer *)gesture {

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{

            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            
            CGPoint velocity = [gesture velocityInView:[gesture.view superview]];
            CGFloat angle = atan2f(velocity.y, velocity.x);
            CGFloat velocityAsFloat = .5;
            [self pushDuck:angle WithVelocity:velocityAsFloat];

        }
            
        
        case UIGestureRecognizerStateEnded: {


            
            break;
        }
            
            

        
        default:

            break;
    }
    
    
    
    
    
    
    
    
    
}


-(void)pushDuck:(CGFloat)angle WithVelocity:(CGFloat)velocity{
    
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.duckImageView] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.magnitude = velocity;
    self.pushBehavior.angle = angle;
    [self.animator addBehavior:self.pushBehavior];
    

    
}

- (IBAction)swipeUp:(UISwipeGestureRecognizer *)sender {

}


@end
