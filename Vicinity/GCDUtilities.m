//
//  GCDUtilities.m
//  
//
//  Created by Ben Ford on 9/25/12.
//  Copyright (c) 2012 Ben Ford. All rights reserved.
//

#import "GCDUtilities.h"

void dispatch_after_delay_ext(NSTimeInterval delayTimeInterval, dispatch_queue_t queue, dispatch_block_t blockToPerform) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayTimeInterval * NSEC_PER_SEC), queue, blockToPerform);
}