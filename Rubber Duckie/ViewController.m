//
//  ViewController.m
//  Rubber Duckie
//
//  Created by Rosario Tarabocchia on 3/23/16.
//  Copyright © 2016 RLDT. All rights reserved.
//

#import "ViewController.h"
#import "Duck.h"
#import "RPTDuckDataStore.h"


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
@property (strong, nonatomic) IBOutlet Duck *shadow;
@property (strong, nonatomic) IBOutlet UIImageView *tub
;
@property (strong, nonatomic) IBOutlet UIImageView *ovalwater;
@property (strong, nonatomic) RPTDuckDataStore *dataStore;
@property (weak, nonatomic) IBOutlet UIButton *drainButton;
@property (assign, nonatomic) NSUInteger wallNumber;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.duckImageView.clipsToBounds = YES;
    
    self.dataStore = [RPTDuckDataStore sharedDataStore];
    
    NSLog(@"%@", self.dataStore.duckColor);
    
    [self checkScreenSize];
    
    self.originalBounds = self.view.bounds;
    self.originalCenter = self.view.center;
    self.longPressOutlet = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.duckImageView addGestureRecognizer:self.longPressOutlet];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(fingerMoving:)];
    [self.duckImageView addGestureRecognizer:self.panGesture];
    
    NSString *duckColor = [NSString stringWithFormat:@"%@Duck0", self.dataStore.duckColor];
    
    self.duckImage = [UIImage imageNamed:duckColor];
    
    NSLog(@"%@", self.dataStore.duckColor);
    NSLog(@"%@", duckColor);
    
    [self.duckImageView setImage:self.duckImage];
    
    self.animationNumber = 0;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    NSLog(@"%@", self.duckImageView);
    
    NSLog(@"Getting here before crash");
    
    NSLog(@"%@", self.dataStore.duckColor);
    
    
    self.collisionThing = [[UICollisionBehavior alloc] initWithItems:@[self.duckImageView]];
    
    NSLog(@"%@", self.collisionThing);
   
    NSLog(@"Getting here");
    
    self.collisionThing.translatesReferenceBoundsIntoBoundary = YES;

    
    self.collisionThing.collisionMode = UICollisionBehaviorModeEverything;
    
    [self.animator addBehavior:self.collisionThing];
    
    UICollisionBehavior *shadowBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.shadow]];
    shadowBehavior.collisionMode = UICollisionBehaviorModeEverything;
    shadowBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    [self.animator addBehavior:self.collisionThing];
    [self.animator addBehavior:shadowBehavior];
    
    
    
    self.duckBehaviors = [[UIDynamicItemBehavior alloc]initWithItems:@[self.duckImageView, self.shadow]];
    self.duckBehaviors.density = .7;
    self.duckBehaviors.elasticity = .3;
    self.duckBehaviors.resistance = .7;
    self.duckBehaviors.friction = 1.5;
    self.duckBehaviors.resistance = 1.0;
    self.duckBehaviors.allowsRotation = YES;
    [self.animator addBehavior:self.duckBehaviors];
    
    UIDynamicItemBehavior *resistanceBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.duckImageView, self.shadow]];
    resistanceBehavior.resistance = 1.0;
    [self.animator addBehavior:resistanceBehavior];
    
    
    [self.collisionThing addBoundaryWithIdentifier:@"wall"
                          fromPoint:CGPointMake(30,30)
                            toPoint:CGPointMake(self.view.bounds.size.width - 30,
                                                30)];
    
    [self.collisionThing addBoundaryWithIdentifier:@"wall1"
                                         fromPoint:CGPointMake(30,30)
                                           toPoint:CGPointMake(30,
                                                               self.view.bounds.size.height - 30)];
    
    [self.collisionThing addBoundaryWithIdentifier:@"wall2"
                                         fromPoint:CGPointMake(30,
                                                               self.view.bounds.size.height - 30)
                                           toPoint:CGPointMake(self.view.bounds.size.width - 30, self.view.bounds.size.height - 30)];
    
    [self.collisionThing addBoundaryWithIdentifier:@"wall2"
                                         fromPoint:CGPointMake(self.view.bounds.size.width - 30, 30)
                                           toPoint:CGPointMake(self.view.bounds.size.width - 30, self.view.bounds.size.height - 30)];
    
    
    [shadowBehavior addBoundaryWithIdentifier:@"wall"
                                         fromPoint:CGPointMake(30,30)
                                           toPoint:CGPointMake(self.view.bounds.size.width - 30,
                                                               30)];
    
    [shadowBehavior addBoundaryWithIdentifier:@"wall1"
                                         fromPoint:CGPointMake(30,30)
                                           toPoint:CGPointMake(30,
                                                               self.view.bounds.size.height - 30)];
    
    [shadowBehavior addBoundaryWithIdentifier:@"wall2"
                                         fromPoint:CGPointMake(30,
                                                               self.view.bounds.size.height - 30)
                                           toPoint:CGPointMake(self.view.bounds.size.width - 30, self.view.bounds.size.height - 30)];
    
    [shadowBehavior addBoundaryWithIdentifier:@"wall2"
                                         fromPoint:CGPointMake(self.view.bounds.size.width - 30, 30)
                                           toPoint:CGPointMake(self.view.bounds.size.width - 30, self.view.bounds.size.height - 30)];
    
    UIAttachmentBehavior *attach = [[UIAttachmentBehavior alloc] initWithItem:self.shadow attachedToItem:self.duckImageView];
    attach.damping = 0;
    attach.frequency = 0;
    [self.animator addBehavior:attach];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
    [UIView animateKeyframesWithDuration:10.0 delay:0.0 options:UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:5 animations:^{
            self.waterWaves1View.alpha = 0;
            self.waterWaves2View.alpha = .5;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:5 animations:^{
            self.waterWaves1View.alpha = .5;
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
        
        [self.drainButton setEnabled:NO];

        
        
    }
    
    
    else
    {
        if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateFailed || recognizer.state == UIGestureRecognizerStateEnded)
        {
            NSLog(@"TOUCH CANCELED AND %lu", self.animationNumber);
            
            self.touchCancelOnImageView = YES;
            
            [self imageLetGo];
            
            [self.drainButton setEnabled:NO];
            
            
            
        }
    }
}

-(void)animateSinking {
    
    NSUInteger imageNumber = self.animationNumber + 1;
    NSString *imageName = [NSString stringWithFormat:@"%@Duck%lu", self.dataStore.duckColor, imageNumber];
    
//    NSString *imageName = @"testwater2";
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
    
    
    if (self.animationNumber == 0 && self.touchCancelOnImageView == NO) {
        
        [self animateSinking];
    }
    
    if (self.animationNumber == 1 && self.touchCancelOnImageView == NO) {
        
        [self animateSinking];
    }
    
    if (self.animationNumber == 2 && self.touchCancelOnImageView == NO) {
        
        [self animateSinking];
    }
    
    if (self.animationNumber == 3 && self.touchCancelOnImageView == NO) {
        
        [self animateSinking];
    }
    
    if (self.animationNumber == 4 && self.touchCancelOnImageView == NO) {
        
        [self animateSinking];
    }
    
    if (self.animationNumber == 5 && self.touchCancelOnImageView == NO) {
        
        [self animateSinking];
    }
    
    if (self.animationNumber == 6 && self.touchCancelOnImageView == NO) {
        
        [self animateSinking];
    }
    
    if (self.animationNumber == 7 && self.touchCancelOnImageView == NO) {

        self.touchCancelOnImageView = YES;
        [self.drainButton setEnabled:YES];
    }
    
}


-(void)animateRising {
    
    NSUInteger imageNumber = self.animationNumber - 1;
    NSString *imageName = [NSString stringWithFormat:@"%@Duck%lu", self.dataStore.duckColor, imageNumber];
    
//    NSString *imageName = @"testwater2";
    self.duckImage = [UIImage imageNamed:imageName];
    
    [UIView transitionWithView:self.duckImageView duration:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            [self.duckImageView setImage:self.duckImage];
            
        } completion:^(BOOL finished) {
            
            self.animationNumber -= 1;
            
            [self imageLetGo];
            
        }];
}

-(void)imageLetGo {
    
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView transitionWithView:self.duckImageView duration:.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            [self.duckImageView setImage:self.duckImage];
            
        } completion:^(BOOL finished) {
            
            self.animateWobbleNumber += 1;
            
            [self wobble];
            
        }];
        
    });
    
}

-(void)wobble {
    
    NSString *imageName = [NSString stringWithFormat:@"%@Duck", self.dataStore.duckColor];
    
    if (self.animateWobbleNumber == 0 && self.touchCancelOnImageView == YES) {
        
        self.duckImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@A", imageName]];
        
        [self animateWobble];
    }
    
    if (self.animateWobbleNumber == 1 && self.touchCancelOnImageView == YES) {
        
        self.duckImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@B", imageName]];
        
        [self animateWobble];
    }
    
    if (self.animateWobbleNumber == 2 && self.touchCancelOnImageView == YES) {
        
        self.duckImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@A", imageName]];
        
        [self animateWobble];
    }
    
    if (self.animateWobbleNumber == 3 && self.touchCancelOnImageView == YES) {
        
        self.duckImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@0", imageName]];

        [self animateWobble];
    }
    
    if (self.animateWobbleNumber == 4 && self.touchCancelOnImageView == YES) {
        
        self.touchCancelOnImageView = NO;
        [self.drainButton setEnabled:YES];
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

- (IBAction)drainButton:(id)sender {
    
    
//    [UIView transitionWithView:self.water duration:7 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        
//        [self.water setAlpha:0];
//        
//    } completion:^(BOOL finished) {
//        [UIView transitionWithView:self.ovalwater duration:7.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//            [self.ovalwater setAlpha:0];
//        
//        } completion:nil];
//
//        
//    }];
    
    if (self.dataStore.duckNumber == 4) {
        self.dataStore.duckNumber = 0;
    }
    
    else {
       
        self.dataStore.duckNumber = self.dataStore.duckNumber + 1;
        
    }
    
    self.dataStore.duckColor = self.dataStore.duckColorDictionary[@(self.dataStore.duckNumber)];
    
    
    NSString *duckColor = [NSString stringWithFormat:@"%@Duck0", self.dataStore.duckColor];
    
    self.duckImage = [UIImage imageNamed:duckColor];
//
    NSLog(@"%@", self.dataStore.duckColor);
    NSLog(@"%@", duckColor);
    
    [self.duckImageView setImage:self.duckImage];
    
    
    
}

-(void)checkScreenSize {
    

    
    if (self.view.frame.size.height < 500) {
        
        self.tub.image = [UIImage imageNamed:@"bottomTub4Sx1"];
        self.waterWaves1View.image = [UIImage imageNamed:@"water4sx1"];
        self.waterWaves2View.image = [UIImage imageNamed:@"water4sx1"];
        
    }
    
    else if (self.view.frame.size.height < 600) {
        
        self.tub.image = [UIImage imageNamed:@"bottomTub5x2"];
        self.waterWaves1View.image = [UIImage imageNamed:@"water5x2"];
        self.waterWaves2View.image = [UIImage imageNamed:@"water5x2"];
        
        
    }
    
    else if (self.view.frame.size.height < 700) {
        
        self.tub.image = [UIImage imageNamed:@"bottomTub6x2"];
        self.waterWaves1View.image = [UIImage imageNamed:@"water6x2"];
        self.waterWaves2View.image = [UIImage imageNamed:@"water6x2"];
        
        
        
    }
    
    else {
        
        self.tub.image = [UIImage imageNamed:@"bottomTub6Plusx3"];
        self.waterWaves1View.image = [UIImage imageNamed:@"water6Plusx3"];
        self.waterWaves2View.image = [UIImage imageNamed:@"water6Plusx3"];
        
        
        
    }
    
    
    
    
}




@end
