//
//  MTQrDecoder.h
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

#import <Foundation/Foundation.h>
#import "zbar.h"

/**
* An Objective-C Cocoa wrapper around zbar library
*/
@interface MTQrDecoder : NSObject

/**
* Decodes QR codes in a given image asynchronously
* @param image The image to scan
* @param cropRect If only part of the image is to be scanned, pass the rect, otherwise
* parr the bounds of the image ({0, 0, image.width, image.height})
* @param handler Block to be notified on the main thread after scanning completes
* @param image The scanned image
* @param result The string with decoded contents of QR code, or nil of no QR codes were
* found or couldn't be decoded
* @param error If result is nil, this will contain information why decoding failed
*/
- (void)decodeImage:(CGImageRef)image
               crop:(CGRect)cropRect
        withCompletionHandler:(void(^)(NSImage *image, NSString *result, NSError *error))handler;

@end
