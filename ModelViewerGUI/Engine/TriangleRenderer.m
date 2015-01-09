//
// Created by Krzysztof Kaczor on 1/9/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import "TriangleRenderer.h"

void put_pixel(int x, int y, UInt8 r, UInt8 g, UInt8 b ) ;
void setup_buffer(UInt8* b, int w, int h) ;

@implementation TriangleRenderer {

}

- (NSImage*)renderTriangle:(void*)triangle onScreen:(CGSize)size {
    size_t sizeX = (size_t) size.width;
    size_t sizeY = (size_t) size.height;

    UInt8 pixelData[sizeX * sizeY * 3];
    setup_buffer(pixelData, (int)sizeX, (int)sizeY);

    int c = 100;

    srand(123);
    while (c--) {
        int x = (int) (((double) rand() / RAND_MAX) * sizeX);
        int y = (int) (((double) rand() / RAND_MAX) * sizeY);

        put_pixel(x, y, 255, 255, 255);

    }

    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CFDataRef rgbData = CFDataCreate(NULL, pixelData, sizeX * sizeY * 3);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(rgbData);
    CGImageRef rgbImageRef = CGImageCreate(sizeX, sizeY, 8, 24, sizeX * 3, colorspace, kCGBitmapByteOrderDefault, provider, NULL, true, kCGRenderingIntentDefault);
    NSImage* image = [[NSImage alloc] initWithCGImage:rgbImageRef size:NSZeroSize];

    //cleanup
    CFRelease(rgbData);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorspace);
    CGImageRelease(rgbImageRef);

    return image;
}
@end


UInt8* buf;
int width, height;

void setup_buffer(UInt8* b, int w, int h) {
    buf = b;
    width = w;
    height = h;

    memset(buf, 0, w*h*3);
}

void put_pixel(int x, int y, UInt8 r, UInt8 g,UInt8 b ) {
    if (x >= width || y >= width || x < 0 || y < 0)
        return;

    int addr = (x * width + y) * 3;

    buf[addr] = r;
    buf[addr + 1] = g;
    buf[addr + 2] = b;
}