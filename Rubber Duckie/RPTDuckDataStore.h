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

@property (strong, nonatomic) NSDictionary *duckColorDictionary;
@property (strong, nonatomic) NSString *duckColor;
@property (assign, nonatomic) NSUInteger duckNumber;

@end
