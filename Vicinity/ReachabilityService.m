//
//  ReachabilityService.h
//  
//
//  Created by Ben Ford on 12/19/11.
//  Copyright (c) 2012 Ben Ford. All rights reserved.
//

#import "ReachabilityService.h"
#import "GCDSingleton.h"

#define kDebugReachability YES

@implementation ReachabilityService
{
    Reachability *reachability;
    NSMutableSet *delegates;
    
    NSTimer *testModeTimer;
    BOOL testStatus;
}

- (id)init {
    if( (self = [super init]) ) {
        delegates = [[NSMutableSet alloc] initWithCapacity:0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        reachability = [Reachability reachabilityWithHostName:@"dropbox.com"];
        [reachability startNotifier];
                
        [self reachabilityChanged:nil];
    }
    return self;
}

#pragma mark Singleton
+ (ReachabilityService *)defaultService {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}
#pragma mark -

- (void)setTestModeEnabled:(BOOL)testModeEnabled
{
    _testModeEnabled = testModeEnabled;
    
    [testModeTimer invalidate];
    testModeTimer = nil;
    
    if (testModeEnabled == YES) {
        testModeTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(toggleTestMode:) userInfo:nil repeats:YES];
    }
}

- (void)addDelegate:(id<ReachabilityServiceDelegate>)aDelegate {
    [delegates addObject:aDelegate];    
}

- (void)removeDelegate:(id<ReachabilityServiceDelegate>)aDelegate {
    [delegates removeObject:aDelegate];
}

- (void)reachabilityChanged:(NSNotification *)notification {
    [self reportToDelegates];
}

- (BOOL)hasInternetConnection {
    if (self.testModeEnabled == YES)
        return testStatus;

    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable;
}

- (BOOL)hasLocalWiFiConnection {
    if (self.testModeEnabled == YES)
        return testStatus;

    return [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable;
}

- (BOOL)canReachHost {
    if (self.testModeEnabled == YES)
        return testStatus;

    return [reachability currentReachabilityStatus] != NotReachable;
}

- (void)reportToDelegates {
    
    for( id<ReachabilityServiceDelegate> delegate in delegates )
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate reachabilityChanged];
        });
    
    
    if( kDebugReachability )
        NSLog(@"reachabilityChanged: %d %d %d", self.hasInternetConnection, self.canReachHost, self.hasLocalWiFiConnection);
}

- (void)toggleTestMode:(NSTimer *)timer
{
    testStatus = !testStatus;
    
    [self reportToDelegates];
}
@end