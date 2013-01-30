//
//  RKTestFactory+AppExtensions.m
//  RKInjective
//
//  Created by Taras Kalapun on 1/30/13.
//  Copyright (c) 2013 AppFellas. All rights reserved.
//

#import "RKTestFactory+AppExtensions.h"

@implementation RKTestFactory (AppExtensions)

+ (void)checkPathForCoreDataFile {
    NSString *path = RKApplicationDataDirectory();
    NSError *error = nil;
    BOOL isDir = YES;
    NSFileManager *fm= [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path isDirectory:&isDir]) {
        if (![fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Error: Create folder failed");
        }
    }
}

// Perform any global initialization of your testing environment
+ (void)load
{
    // Configuring test bundle
    NSBundle *testTargetBundle = [NSBundle bundleWithIdentifier:@"com.AppFellas.RKInjectiveTests"];
    [RKTestFixture setFixtureBundle:testTargetBundle];
    
    [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://localhost/"]];
    
    // Set logging levels
	RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    // Setup CoreData
    [self checkPathForCoreDataFile];
	
	[self setSetupBlock:^{
        // Setup Network stubs
		[[LSNocilla sharedInstance] start];
        
        // Core Data
        [RKManagedObjectStore setDefaultStore:[RKTestFactory managedObjectStore]];
	}];
	
	[self setTearDownBlock:^{
        // Clear Network stubs
		[[LSNocilla sharedInstance] clearStubs];
        [[LSNocilla sharedInstance] stop];
	}];
}

+ (void)stubGetRequest:(NSString *)uri withFixture:(NSString *)fixtureName {
    NSString *fileName = [fixtureName stringByAppendingPathExtension:@"json"];
    NSString *data = [RKTestFixture stringWithContentsOfFixture:fileName];
    stubRequest(@"GET", uri).andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).withBody(data);
}

@end
