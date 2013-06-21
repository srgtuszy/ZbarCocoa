//
//  APAppDelegate.h
//  ZbarOsxWrapper
//
//  Created by Michal Tuszynski on 6/21/13.
//  Copyright (c) 2013 Michal Tuszynski. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface APAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak, nonatomic) IBOutlet NSImageView *imageView;

- (IBAction)decode:(id)sender;

@end
