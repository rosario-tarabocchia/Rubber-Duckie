//
//  RPTDuckDataStore.m
//  Rubber Duckie
//
//  Created by Rosario Tarabocchia on 4/19/16.
//  Copyright © 2016 RLDT. All rights reserved.
//

#import "RPTDuckDataStore.h"

@implementation RPTDuckDataStore

+ (instancetype)sharedDataStore {
    static RPTDuckDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[RPTDuckDataStore alloc] init];
    });
    
    return _sharedDataStore;
}


- (instancetype)init

{
    self = [super init];
    if (self) {
        
        _duckColor = [NSString new];
        _duckColorDictionary = @{@0:@"red", @1:@"yellow", @2:@"orange", @3:@"green", @4 : @"purple"};
        
    }
    
    return self;
}


@end
