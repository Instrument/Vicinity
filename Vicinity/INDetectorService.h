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

#define SINGLETON_IDENTIFIER @"1234-1234-1234-1234"

@class INDetectorService;
@protocol INDetectorServiceDelegate <NSObject>
- (void)service:(INDetectorService *)service foundDeviceWithRange:(INDetectorRange)range;
@end

@interface INDetectorService : NSObject

- (id)initWithIdentifier:(NSString *)theIdentifier;

+ (INDetectorService *)singleton;

- (void)startDetecting;
- (void)stopDetecting;

- (void)startBroadcasting;
- (void)stopBroadcasting;
@end
