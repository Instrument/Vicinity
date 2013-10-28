//
//  ConsoleView.h
//  Vicinity
//
//  Created by Ben Ford on 10/25/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import <UIKit/UIKit.h>

void INLog(NSString *message, ...);

@interface ConsoleView : UIView

+ (ConsoleView *)singleton;

- (void)logStringWithFormat:(NSString *)log, ...;
@end
