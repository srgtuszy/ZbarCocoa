//
//  APAppDelegate.m
//  Copyright 2013, Michal Tuszynski
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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
