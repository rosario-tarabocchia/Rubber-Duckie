//
//  Duck.m
//  Rubber Duckie
//
//  Created by Rosario Tarabocchia on 3/23/16.
//  Copyright © 2016 RLDT. All rights reserved.
//

#import "Duck.h"

@implementation Duck

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIDynamicItemCollisionBoundsType) collisionBoundsType
{
    return UIDynamicItemCollisionBoundsTypeEllipse;
}

@end
