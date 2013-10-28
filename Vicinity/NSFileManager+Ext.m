//
//  NSFileManager+Ext.m
//  
//
//  Created by Ben Ford on 3/8/12.
//  Copyright (c) 2012 Ben Ford All rights reserved.
//

#import "NSFileManager+Ext.h"

@implementation NSFileManager(Ext)
- (CGFloat)extFileSizeInMegaBytesAtPath:(NSString *)path {
    NSUInteger bytes = [self extFileSizeInBytesAtPath:path];
    return ((CGFloat)bytes) / 1024.0f / 1024.f;
}

- (NSUInteger)extFileSizeInBytesAtPath:(NSString *)path {
    NSError *attributeError = nil;
	NSDictionary *attributes = [self attributesOfItemAtPath:path error:&attributeError];
    if( attributeError != nil )
        NSLog(@"ERROR: reading file attributes at path: %@ with error: %@", path, [attributeError localizedDescription]);
    
	return (NSUInteger)[attributes fileSize];
}

- (void)extCreateFolderPathIfNeeded:(NSString *)folderPath {
	
	if ( [self fileExistsAtPath:folderPath isDirectory:nil] == NO ) {
        NSError *createFolderError = nil;
		[self createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&createFolderError];
        if( createFolderError != nil )
            NSLog(@"ERROR: creating folder with path: %@ and error: %@", folderPath, [createFolderError localizedDescription]);
	}
}
@end
