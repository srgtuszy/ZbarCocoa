//
//  APAppDelegate.m
//  ZbarOsxWrapper
//
//  Created by Michal Tuszynski on 6/21/13.
//  Copyright (c) 2013 Michal Tuszynski. All rights reserved.
//

#import "APAppDelegate.h"
#import "MTQrDecoder.h"

@interface APAppDelegate()

@property (strong, nonatomic) MTQrDecoder *decoder;

@end

@implementation APAppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.decoder = [[MTQrDecoder alloc] init];
}

- (IBAction)decode:(id)sender {
    NSImage *img = [self.imageView image];
    CGImageRef cgImage = [img CGImageForProposedRect:NULL context:NULL hints:NULL];
    [self.decoder decodeImage:cgImage
                         crop:CGRectMake(0, 0, CGImageGetWidth(cgImage), CGImageGetHeight(cgImage))
        withCompletionHandler:^ (NSImage *image, NSString *result, NSError *error) {
            NSLog(@"%@", result);
        }];
}


@end
