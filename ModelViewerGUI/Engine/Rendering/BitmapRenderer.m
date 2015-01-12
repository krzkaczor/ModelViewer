//
// Created by Krzysztof Kaczor on 1/9/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import "BitmapRenderer.h"
#import "Triangle.h"
#import "Vertex.h"
#import "Vector.h"
#import "Color.h"


#include <sys/time.h>

double get_time()
{
    struct timeval t;
    struct timezone tzp;
    gettimeofday(&t, &tzp);
    return t.tv_sec + t.tv_usec*1e-6;
}

#define POINT_SIZE 5
struct TPoint {
    double x, y, z;
    UInt8 r,g,b;
};
typedef struct TPoint TPoint;

void setup_buffers(int w, int h) ;
void horizontal_line(double x, double x2, double y, double zl, double zr, double r1, double r2, double g1, double g2, double b1, double b2);
void render_triangle(TPoint A, TPoint B, TPoint C);
void clear_buffers();
void free_buffers();
void put_pixel(double x, double y, double z, UInt8 r, UInt8 g,UInt8 b ) ;

void check_triangle(Triangle *triangle);

UInt8* buf;
double* bufZ;
int width, height;

double renderingStartedAt;
int triangles_rendered = 0;

@implementation BitmapRenderer {
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
    renderingStartedAt = get_time();
    triangles_rendered = 0;
    clear_buffers();
}

- (void)renderSimpleTriangle:(Triangle*)triangle {
    double x = triangle.v1.position.x;
    double y = (triangle.v1.position.y);
    double z = (triangle.v1.position.z);
    TPoint A = {x, y,z, (UInt8) (triangle.v1.color.r * 255), (UInt8) (triangle.v1.color.g * 255), (UInt8) (triangle.v1.color.b * 255)};

    x =  (triangle.v2.position.x);
    y = (triangle.v2.position.y);
    z = (triangle.v2.position.z);
    TPoint B = {x, y,z, (UInt8) (triangle.v2.color.r * 255), (UInt8) (triangle.v2.color.g * 255), (UInt8) (triangle.v2.color.b  * 255)};

    x = triangle.v3.position.x;
    y = triangle.v3.position.y;
    z = triangle.v3.position.z;
    TPoint C = {x, y,z, (UInt8) (triangle.v3.color.r * 255), (UInt8) (triangle.v3.color.g * 255), (UInt8) (triangle.v3.color.b  * 255)};

    if (A.y == B.y && A.y == C.y)
        return;

    if ((A.x < 0 && B.x < 0 && C.x < 0 )|| (A.x > 400 && B.x > 400 && C.x > 400))
        return;

    if((A.y < 0 && B.y < 0 && C.y < 0) || (A.y > 400 && B.y > 400 && C.y > 400))
        return;

    render_triangle(A, B, C);
}

- (void)renderTriangle:(Triangle*)t {
    NSArray* triangles = [t split];

    [self renderSimpleTriangle:triangles[0]];
    if (triangles.count == 2) {
        [self renderSimpleTriangle:triangles[1]];
    }
}

- (void)renderPoint:(DoublePoint*)p {
    int x = (int) p.position.x;
    int y = (int) p.position.y;
    int r = (int) (p.color.r * 255);
    int g = (int) (p.color.g * 255);
    int b = (int) (p.color.b * 255);

    for (int i = x-POINT_SIZE; i < x+POINT_SIZE;i++) {
        for (int j = y-POINT_SIZE;j < y+POINT_SIZE;j++) {
            put_pixel(i, j, DBL_MAX, r, g, b);
        }
    }
}

- (NSImage*)finishRendering {
    double renderingFinishedAt = get_time();
    double renderingTime = renderingFinishedAt - renderingStartedAt;
    printf("-------------------------------------------------------------\n");
    printf("Rendering took: %f\n", renderingTime);
    printf("Triangles rendered: %i\n", triangles_rendered);

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

//void check_triangle(Triangle *triangle) {
//    triangle->_v1->_position->_x
//}

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
    memset(buf, 75, sizeof (UInt8) * width*height*3);

    for (int i = 0;i < width*height;i++) {
        bufZ[i] = -DBL_MAX;
    }
}

void put_pixel(double x, double y, double z, UInt8 r, UInt8 g,UInt8 b ) {

    int xI = (int)round(x);
    int yI = (int)round(y);

    if (xI >= width || yI >= height || xI < 0 || yI < 0)
        return;

    int bufZAddr = yI * width + xI;
    if (bufZ[bufZAddr] >= z )
        return;
    bufZ[bufZAddr] = z;

    int addr = (yI * width + xI) * 3;
    buf[addr] = r;
    buf[addr + 1] = g;
    buf[addr + 2] = b;
}


int will_be_drawn (TPoint* p) {
    int x = (int)round(p->x);
    int y = (int)round(p->y);
    double z = p->z;

    int bufZAddr = y * width + x;
    return bufZ[bufZAddr] < z;

}

void render_triangle(TPoint A, TPoint B, TPoint C) {
//    if (!will_be_drawn(&A) && !will_be_drawn(&B) && !will_be_drawn(&C)) {
//        return;
//    }

    triangles_rendered++;

    double deltaAB = 0;
    if (B.y - A.y != 0) {
        deltaAB = (B.x - A.x) / (B.y - A.y);
    }
    double deltaBC = 0;
    if (C.y - B.y != 0) {
        deltaBC = (C.x - B.x) / (C.y - B.y);
    }
    double deltaAC = 0;
    if (C.y - A.y != 0) {
        deltaAC = (C.x - A.x) / (C.y - A.y);
    }

    double deltaABz = 0;
    if (B.y - A.y != 0 && B.z != A.z) {
        deltaABz = (B.z - A.z) / (B.y - A.y);
    }
    double deltaBCz = 0;
    if (C.y - B.y != 0 && C.z != B.z) {
        deltaBCz = (C.z - B.z) / (C.y - B.y);
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

        tmp = deltaACz;
        deltaACz = deltaABz;
        deltaABz = tmp;
    }

    for(double y = A.y; y <= C.y;y++) {
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


void horizontal_line(double x, double x2, double y, double zl, double zr, double r1, double r2, double g1, double g2, double b1, double b2) {
    if (x > x2){
        double tmp = x;
        x = x2;
        x2 = tmp;
    }
    x = floor(x);
    x2 = ceil(x2);

    double dr = (r2 - r1)/fabs(x2 - x);
    double dg = (g2 - g1)/fabs(x2 - x);
    double db = (b2 - b1)/fabs(x2 - x);
    double dz = (zr - zl)/fabs(x2 - x);
    for (;x < x2;x++) {
        put_pixel(x, y,zl, r1, g1, b1);
        r1 += dr;
        g1 += dg;
        b1 += db;
        zl += dz;
    }
};
