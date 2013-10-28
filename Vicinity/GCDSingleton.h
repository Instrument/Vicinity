//
//  GCDSingleton.h
//
//  Created by Ben Ford on 7/5/12.
//  Copyright (c) 2012 Ben Ford. All rights reserved.
//
// HOW TO USE:
// 
// #pragma mark Singleton
// + (GlobalPersistantStoreCoordinator *)sharedService {
//    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
//        return [[self alloc] init];
//    });
// }
// #pragma mark -

#pragma mark -

#ifndef _GCDSingleton_h
#define _GCDSingleton_h

//
// taken from here: https://gist.github.com/1057420
// see also this nice overview of the technique: http://lukeredpath.co.uk/blog/a-note-on-objective-c-singletons.html
// 
#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

#endif
