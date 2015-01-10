//
// Created by Krzysztof Kaczor on 1/9/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import "TriangleRenderer.h"
#import "Triangle.h"
#import "Vertex.h"
#import "Vector.h"
#import "Color.h"

void put_pixel(int x, int y, UInt8 r, UInt8 g, UInt8 b ) ;
void setup_buffer(UInt8* b, int w, int h) ;
struct TPoint {
    double x, y;
    double z;
    UInt8 r,g,b;
};
typedef struct TPoint TPoint;
void horizontal_line(float x, float x2, float y, float r1, float r2, float g1, float g2, float b1, float b2);
void render_triangle(TPoint A, TPoint B, TPoint C);
UInt8* buf;
int width, height;

@implementation TriangleRenderer {
    CGSize size;
}

- (void)startSceneRenderingOnScreen:(CGSize)aSize {
    size = aSize;
    size_t sizeX = (size_t) size.width;
    size_t sizeY = (size_t) size.height;

    UInt8 pixelData[sizeX * sizeY * 3];
    setup_buffer(pixelData, (int)sizeX, (int)sizeY);
}

- (void)renderSimpleTriangle:(Triangle*)triangle {
    int x = (int) (triangle.v1.position.x);
    int y = (int) (triangle.v1.position.y);
    TPoint A = {x, y,1, triangle.v1.color.r * 255, triangle.v1.color.g * 255,triangle.v1.color.b * 255};

    x = (int) (triangle.v2.position.x);
    y = (int) (triangle.v2.position.y);
    TPoint B = {x, y,1, triangle.v2.color.r * 255, triangle.v2.color.g * 255,triangle.v2.color.b * 255};

    x = (int) (triangle.v3.position.x);
    y = (int) (triangle.v3.position.y);
    TPoint C = {x, y,1, triangle.v3.color.r * 255, triangle.v3.color.g * 255,triangle.v3.color.b * 255};

    render_triangle(A, B, C);
}

- (void)renderTriangle:(Triangle*)t {
    NSArray* arr = [t split];
    Triangle* triangle = arr[0];
    Triangle* triangle2 = arr[1];
    [self renderSimpleTriangle:triangle];
    [self renderSimpleTriangle:triangle2];
}

- (NSImage*)finishRendering {
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CFDataRef rgbData = CFDataCreate(NULL, buf, size.width * size.height * 3);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(rgbData);
    CGImageRef rgbImageRef = CGImageCreate(size.width, size.height, 8, 24, size.width * 3, colorspace, kCGBitmapByteOrderDefault, provider, NULL, true, kCGRenderingIntentDefault);
    NSImage* image = [[NSImage alloc] initWithCGImage:rgbImageRef size:NSZeroSize];

    //cleanup
    CFRelease(rgbData);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorspace);
    CGImageRelease(rgbImageRef);

    return image;
}
@end


void setup_buffer(UInt8* b, int w, int h) {
    buf = b;
    width = w;
    height = h;

    memset(buf, 0, w*h*3);
}

void put_pixel(int x, int y, UInt8 r, UInt8 g,UInt8 b ) {
    if (x >= width || y >= height || x < 0 || y < 0)
        return;

    int addr = (y * width + x) * 3;

    buf[addr] = r;
    buf[addr + 1] = g;
    buf[addr + 2] = b;
}

void render_triangle(TPoint A, TPoint B, TPoint C) {
    //x
    double deltaAB = 0;
    double deltaBC = 0;
    double deltaAC = 0;

    if (B.y - A.y != 0) {
        deltaAB = (double)(B.x - A.x) / (B.y - A.y);
    }

    deltaBC = (double)(C.x - B.x) / (C.y - B.y);
    deltaAC = (double)(C.x - A.x) / (C.y - A.y);


    double deltaBCr;

    //color
    //r
    double deltaABr = (B.r - A.r) / (B.y - A.y);
    if (C.y == B.y) {
        deltaBCr = 0;
    } else {
        deltaBCr = (C.r - B.r) / (C.y - B.y);
    }
    double deltaACr = (C.r - A.r) / (C.y - A.y);
//    //g
//    double deltaABg = (B.g - A.g) / (B.y - A.y);
//    double deltaBCg = (C.g - B.g) / (C.y - B.y);
//    double deltaACg = (C.g - A.g) / (C.y - A.y);
//    //z
//    double deltaABb = (B.b - A.b) / (B.y - A.y);
//    double deltaBCb = (C.b - B.b) / (C.y - B.y);
//    double deltaACb = (C.b - A.b) / (C.y - A.y);

    //caluclate correct delatas before entering loop (with correct sign)

    double xl, xr;
    double rl, rr;
    double gl, gr;
    double bl, br;

    xl = xr = A.x;
    rl = rr = A.r;
    gl = gr = A.g;
    bl = br = A.b;

    if (A.y - B.y == 0) {
        xr = B.x;
        rr = B.r;
        gr = B.g;
        br = B.b;
    }

    if (B.x < C.x) {
        double tmp = deltaACr;
        deltaACr = deltaABr;
        deltaABr = tmp;
    }

    for(float y = A.y; y <= C.y;y++) {
        horizontal_line(xl, xr, y, rl, rr, gl, gr, bl, br);

        if (y >= B.y){
            xr += deltaBC;
            xl += deltaAC;
            rr += deltaBCr;
            rl += deltaACr;
        } else {
            xr += deltaAB;
            xl += deltaAC;
            rr += deltaABr;
            rl += deltaACr;
        }

    }
}

void horizontal_line(float x, float x2, float y, float r1, float r2, float g1, float g2, float b1, float b2) {
    if (x > x2){
        float tmp = x;
        x = x2;
        x2 = tmp;
    }

    double dr = (r2 - r1)/(x2 - x);
    for (;x < x2;x++) {
        put_pixel(x, y, 255, g1, b1);
        r1 += dr;
    }
};
