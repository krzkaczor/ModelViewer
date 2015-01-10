//
// Created by Krzysztof Kaczor on 1/9/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import "TriangleRenderer.h"
#import "Triangle.h"
#import "Vertex.h"
#import "Vector.h"
#import "Color.h"

void setup_buffers(int w, int h) ;
void horizontal_line(float x, float x2, float y, double zl, double zr, float r1, float r2, float g1, float g2, float b1, float b2);
struct TPoint {
    double x, y, z;
    UInt8 r,g,b;
};
typedef struct TPoint TPoint;
void render_triangle(TPoint A, TPoint B, TPoint C);
void clear_buffers();
void free_buffers();

UInt8* buf;
double* bufZ;
int width, height;

@implementation TriangleRenderer {
    CGSize size;
}

- (instancetype)initWithScreenSize:(CGSize)aSize {
    self = [super init];
    if (self) {
        size = aSize;
        setup_buffers((int)aSize.width, (int)aSize.height);
    }

    return self;
}

- (void)dealloc {
    free_buffers();
}

+ (instancetype)rendererWithScreenSize:(CGSize)aSize {
    return [[self alloc] initWithScreenSize:aSize];
}


- (void)startSceneRendering {
    clear_buffers();
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
    [self renderSimpleTriangle:triangle2];
    [self renderSimpleTriangle:triangle];
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

void free_buffers() {
    free (buf);
    free (bufZ);
}


void setup_buffers(int w, int h) {
    width = w;
    height = h;

    buf = malloc(sizeof (UInt8) * w*h*3);
    bufZ = malloc(sizeof (double) * w*h);
}

void clear_buffers() {
    memset(buf, 0, width*height*3);
    memset(bufZ, -DBL_MAX, width*height);
}

void put_pixel(int x, int y, double z, UInt8 r, UInt8 g,UInt8 b ) {
    if (x >= width || y >= height || x < 0 || y < 0)
        return;

    int bufZAddr = y * width + x;
    if (bufZ[bufZAddr] >= z )
        return;
    bufZ[bufZAddr] = z;

    int addr = (y * width + x) * 3;
    buf[addr] = r;
    buf[addr + 1] = g;
    buf[addr + 2] = b;
}

void render_triangle(TPoint A, TPoint B, TPoint C) {
    double deltaAB = 0;
    if (B.y - A.y != 0) {
        deltaAB = (double)(B.x - A.x) / (B.y - A.y);
    }
    double deltaBC = 0;
    if (C.y - B.y != 0) {
        deltaBC = (double) (C.x - B.x) / (C.y - B.y);
    }
    double deltaAC = 0;
    if (C.y - A.y != 0) {
        deltaAC = (double) (C.x - A.x) / (C.y - A.y);
    }

    double deltaABz = 0;
    if (B.y - A.y != 0 && B.z != A.z) {
        deltaABz = (B.z - A.z) / (B.y - A.y);
    }
    double deltaBCz = 0;
    if (C.y - B.y != 0 && C.z != B.z) {
        deltaBC = (C.z - B.z) / (C.y - B.y);
    }
    double deltaACz = 0;
    if (C.y - A.y != 0 && C.z != A.z) {
        deltaACz = (C.z - A.z) / (C.y - A.y);
    }

    double deltaBCr = 0;
    if (C.y != B.y && C.r != B.r) {
        deltaBCr = (C.r - B.r) / (C.y - B.y);
    }
    double deltaACr = 0;
    if (C.y != A.y && C.r != A.r) {
        deltaACr = (C.r - A.r) / (C.y - A.y);
    }
    double deltaABr = 0;
    if (B.y != A.y && B.r != A.r) {
        deltaABr = (B.r - A.r) / (B.y - A.y);
    }

    double deltaBCg = 0;
    if (C.y != B.y && C.g != B.g) {
        deltaBCg = (C.g - B.g) / (C.y - B.y);
    }
    double deltaACg = 0;
    if (C.y != A.y && C.g != A.g) {
        deltaACg = (C.g - A.g) / (C.y - A.y);
    }
    double deltaABg = 0;
    if (B.y != A.y && B.g != A.g) {
        deltaABg = (B.g - A.g) / (B.y - A.y);
    }

    double deltaBCb = 0;
    if (C.y != B.y && C.b != B.b) {
        deltaBCb = (C.b - B.b) / (C.y - B.y);
    }
    double deltaACb = 0;
    if (C.y != A.y && C.b != A.b) {
        deltaACb = (C.b - A.b) / (C.y - A.y);
    }
    double deltaABb = 0;
    if (B.y != A.y && B.b != A.b) {
        deltaABb = (B.b - A.b) / (B.y - A.y);
    }

    double xl, xr;
    double zl, zr;
    double rl, rr;
    double gl, gr;
    double bl, br;

    xl = xr = A.x;
    zl = zr = A.z;
    rl = rr = A.r;
    gl = gr = A.g;
    bl = br = A.b;

    if (A.y - B.y == 0) {
        xr = B.x;
        zr = B.z;
        rr = B.r;
        gr = B.g;
        br = B.b;
    }

    if (B.x < C.x && A.y != B.y) {
        double tmp = deltaACr;
        deltaACr = deltaABr;
        deltaABr = tmp;

        tmp = deltaACg;
        deltaACg = deltaABg;
        deltaABg = tmp;

        tmp = deltaACb;
        deltaACb = deltaABb;
        deltaABb = tmp;
    }

    for(float y = A.y; y <= C.y;y++) {
        horizontal_line(xl, xr,y,zl, zr, rl, rr, gl, gr, bl, br);

        if (y >= B.y){
            xr += deltaBC;
            xl += deltaAC;
            zr += deltaBCz;
            zl += deltaACz;
            rr += deltaBCr;
            rl += deltaACr;
            gr += deltaBCg;
            gl += deltaACg;
            br += deltaBCb;
            bl += deltaACb;

        } else {
            xr += deltaAB;
            xl += deltaAC;
            zr += deltaABz;
            zl += deltaACz;
            rr += deltaABr;
            rl += deltaACr;
            gr += deltaABg;
            gl += deltaACg;
            br += deltaABb;
            bl += deltaACb;
        }

    }
}


void horizontal_line(float x, float x2, float y, double zl, double zr, float r1, float r2, float g1, float g2, float b1, float b2) {
    if (x > x2){
        float tmp = x;
        x = x2;
        x2 = tmp;
    }

    double dr = (r2 - r1)/fabs(x2 - x);
    double dg = (g2 - g1)/fabs(x2 - x);
    double db = (b2 - b1)/fabs(x2 - x);
    printf("%f\n", dr);
    for (;x < x2;x++) {
        printf("r1 = %f\n", r1);
        put_pixel(x, y,zl, r1, g1, b1);
        r1 += dr;
        g1 += dg;
        b1 += db;
    }
};
