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
@optional
- (void)service:(INBeaconService *)service foundDeviceUUID:(NSString *)uuid withRange:(INDetectorRange)range;
- (void)service:(INBeaconService *)service bluetoothAvailable:(BOOL)enabled;
@end

@interface INBeaconService : NSObject

- (id)initWithIdentifier:(NSString *)theIdentifier;

- (void)addDelegate:(id<INBeaconServiceDelegate>)delegate;
- (void)removeDelegate:(id<INBeaconServiceDelegate>)delegate;

+ (INBeaconService *)singleton;

@property (nonatomic, readonly) BOOL isDetecting;
@property (nonatomic, readonly) BOOL isBroadcasting;

- (void)startDetecting;
- (void)stopDetecting;

- (void)startBroadcasting;
- (void)stopBroadcasting;

- (BOOL)hasBluetooth;
@end
