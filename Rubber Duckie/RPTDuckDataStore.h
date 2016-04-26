//
//  RPTDuckDataStore.h
//  Rubber Duckie
//
//  Created by Rosario Tarabocchia on 4/19/16.
//  Copyright © 2016 RLDT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPTDuckDataStore : NSObject

+ (instancetype)sharedDataStore;

@property (strong, nonatomic) NSArray *duckColorArray;
@property (strong, nonatomic) NSString *duckColor;

@end
