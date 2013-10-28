//
//  ReachabilityService.h
//  
//
//  Created by Ben Ford on 12/19/11.
//  Copyright (c) 2012 Ben Ford. All rights reserved.
//
// Tiny Wrapper around Reachability 2.2 that makes it easy to see if we have internet.

#import <Foundation/Foundation.h>
#import "Reachability.h"

@protocol ReachabilityServiceDelegate <NSObject>
- (void)reachabilityChanged;
@end

@interface ReachabilityService : NSObject 

+ (ReachabilityService *)defaultService;

- (void)addDelegate:(id<ReachabilityServiceDelegate>)aDelegate;
- (void)removeDelegate:(id<ReachabilityServiceDelegate>)aDelegate;

@property (nonatomic, readonly) BOOL canReachHost;
@property (nonatomic, readonly) BOOL hasInternetConnection;
@property (nonatomic, readonly) BOOL hasLocalWiFiConnection;

- (void)reportToDelegates;

@property (nonatomic, assign) BOOL testModeEnabled;
@end
