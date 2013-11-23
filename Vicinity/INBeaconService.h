//
//  INBlueToothService.h
//  Vicinity
//
//  Created by Ben Ford on 10/28/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    INDetectorRangeUnknown = 0,
    INDetectorRangeFar,
    INDetectorRangeNear,
    INDetectorRangeImmediate,
} INDetectorRange;

#define SINGLETON_IDENTIFIER @"CB284D88-5317-4FB4-9621-C5A3A49E6155"

@class INBeaconService;
@protocol INBeaconServiceDelegate <NSObject>
- (void)service:(INBeaconService *)service foundDeviceUUID:(NSString *)uuid withRange:(INDetectorRange)range;
@end

@interface INBeaconService : NSObject

- (id)initWithIdentifiers:(NSArray *)theIdentifiers;

- (void)addDelegate:(id<INBeaconServiceDelegate>)delegate;
- (void)removeDelegate:(id<INBeaconServiceDelegate>)delegate;

+ (INBeaconService *)singleton;

@property (nonatomic, readonly) BOOL isDetecting;
@property (nonatomic, readonly) BOOL isBroadcasting;

- (void)startDetecting;
- (void)stopDetecting;

- (void)startBroadcasting;
- (void)stopBroadcasting;
@end
