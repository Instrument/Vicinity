//
//  NSFileManager+Ext.h
//  
//
//  Created by Ben Ford on 3/8/12.
//  Copyright (c) 2012 Ben Ford All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager(Ext)
- (CGFloat)extFileSizeInMegaBytesAtPath:(NSString *)path;
- (NSUInteger)extFileSizeInBytesAtPath:(NSString *)path;

- (void)extCreateFolderPathIfNeeded:(NSString *)folderPath;
@end
