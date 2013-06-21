//
//  MTQrDecoder.m
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

#import "MTQrDecoder.h"

#define zbar_fourcc(a, b, c, d)                 \
((unsigned long)(a) |                   \
((unsigned long)(b) << 8) |            \
((unsigned long)(c) << 16) |           \
((unsigned long)(d) << 24))

@interface MTQrDecoder ()

- (zbar_image_t *)_prepareImage:(CGImageRef)cgImage crop:(CGRect)cropRect;

@end

@implementation MTQrDecoder

- (zbar_image_t *)_prepareImage:(CGImageRef)cgImage crop:(CGRect)cropRect {
    CGSize size = CGSizeMake(CGImageGetWidth(cgImage), CGImageGetHeight(cgImage));

    unsigned int w = size.width;
    unsigned int h = size.height;

    unsigned long datalen = w * h;
    uint8_t *raw = malloc(datalen);

    if (raw) {
        zbar_image_t *zimg = zbar_image_create();
        zbar_image_set_data(zimg, raw, datalen, zbar_image_free_data);
        zbar_image_set_format(zimg, zbar_fourcc('Y', '8', '0', '0'));
        zbar_image_set_size(zimg, w, h);

        CGFloat scale = size.width / cropRect.size.width;
        cropRect.origin.x *= -scale;
        cropRect.size.width = scale * (CGFloat) CGImageGetWidth(cgImage);
        scale = size.height / cropRect.size.height;
        CGFloat height = CGImageGetHeight(cgImage);

        cropRect.origin.y = height - cropRect.origin.y - cropRect.size.height;
        cropRect.origin.y *= -scale;
        cropRect.size.height = scale * height;

        CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
        CGContextRef ctx =
                CGBitmapContextCreate(raw, w, h, 8, w, cs, kCGImageAlphaNone);
        CGColorSpaceRelease(cs);
        CGContextSetAllowsAntialiasing(ctx, 0);
        CGContextDrawImage(ctx, cropRect, cgImage);
        CGImageRef cgdump = CGBitmapContextCreateImage(ctx);
        CGImageRelease(cgdump);
        CGContextRelease(ctx);

        return zimg;
    }
    return nil;
}


#pragma mark - Public methods

- (void)decodeImage:(CGImageRef)cgImage crop:(CGRect)cropRect withCompletionHandler:(void (^)(NSImage *, NSString *, NSError *))handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        NSImage *resultImage;
        NSMutableString *results;
        NSError *error;

        zbar_image_t *zimg = [self _prepareImage:cgImage crop:cropRect];
        if (zimg != nil) {
            results = [NSMutableString string];
            zbar_image_scanner_t *imageScanner = zbar_image_scanner_create();
            zbar_image_scanner_set_config(imageScanner, ZBAR_I25, ZBAR_CFG_ENABLE, 0);
            zbar_scan_image(imageScanner, zimg);

            const zbar_symbol_set_t *symbolSet = zbar_image_scanner_get_results(imageScanner);
            const zbar_symbol_t *sym = zbar_symbol_set_first_symbol(symbolSet);

            int n = 0;
            for (; sym; sym = zbar_symbol_next(sym)) {
                NSString *str = [NSString stringWithUTF8String:zbar_symbol_get_data(sym)];
                [results appendString:str];
                n++;
            }

            if (![results isEqualToString:@""]) {

                NSSize imageSize = NSMakeSize(CGImageGetWidth(cgImage), CGImageGetHeight(cgImage));
                resultImage = [[NSImage alloc] initWithCGImage:cgImage
                                                          size:imageSize];
            }

            else {
                error = [NSError errorWithDomain:@"No qr codes found"
                                            code:1
                                        userInfo:nil];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                handler(resultImage, results, error);
            });

            zbar_image_scanner_destroy(imageScanner);
            zbar_image_destroy(zimg);
        }
    });
}

@end
