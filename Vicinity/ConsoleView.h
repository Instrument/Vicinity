//
//  ConsoleView.h
//  Vicinity
//
//  Created by Ben Ford on 10/25/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsoleView : UIView

- (void)logStringWithFormat:(NSString *)log, ...;
@end
