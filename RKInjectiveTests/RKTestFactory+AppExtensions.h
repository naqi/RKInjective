//
//  RKTestFactory+AppExtensions.h
//  RKInjective
//
//  Created by Taras Kalapun on 1/30/13.
//  Copyright (c) 2013 AppFellas. All rights reserved.
//

#import "RKTestFactory.h"

@interface RKTestFactory (AppExtensions)

+ (void)stubGetRequest:(NSString *)uri withFixture:(NSString *)fixtureName;

@end
