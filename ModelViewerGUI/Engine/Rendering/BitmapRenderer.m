//
// Created by Krzysztof Kaczor on 1/9/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import "BitmapRenderer.h"
#import "Triangle.h"
#import "Vertex.h"
#import "Vector.h"
#import "Color.h"
#import "YCMatrix+Advanced.h"
#import "YCMatrix+Affine3D.h"
#import "Camera.h"
#import "Scene.h"
#import "LightSource.h"


#include <sys/time.h>
#import <MacTypes.h>
#import <objc/objc-api.h>
#import <YCMatrix/YCMatrix.h>

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
    Vertex* v1;
    Vertex* v2;
    Vertex* v3;
    Triangle *currentTriangle;
    Camera *camera;
    Scene *scene;
    YCMatrix *transformation;
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


    currentTriangle = triangle;

    v1 = triangle.v1;
    v2 = triangle.v2;
    v3 = triangle.v3;
    [self renderTriangleWithV1:triangle.v1 v2:triangle.v2 v3:triangle.v3];
}

- (void)renderTriangle:(Triangle*)t forCamera:(Camera*)aCamera andScene:(Scene*)aScene andTransformation:(YCMatrix*)modelViewProjectionMatrix {
    camera = aCamera;
    scene = aScene;
    transformation = [modelViewProjectionMatrix pseudoInverse];

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


-(void) renderTriangleWithV1:(Vertex*) A v2:(Vertex*)B v3:(Vertex*)C {
    triangles_rendered++;
    UInt8 Ar = (UInt8) (A.color.r * 255);
    UInt8 Ag = (UInt8) (A.color.g * 255);
    UInt8 Ab = (UInt8) (A.color.b * 255);

    UInt8 Br = (UInt8) (B.color.r * 255);
    UInt8 Bg = (UInt8) (B.color.g * 255);
    UInt8 Bb = (UInt8) (B.color.b * 255);

    UInt8 Cr = (UInt8) (C.color.r * 255);
    UInt8 Cg = (UInt8) (C.color.g * 255);
    UInt8 Cb = (UInt8) (C.color.b * 255);

    double deltaAB = 0;
    if (B.position.y - A.position.y != 0) {
        deltaAB = (B.position.x - A.position.x) / (B.position.y - A.position.y);
    }
    double deltaBC = 0;
    if (C.position.y - B.position.y != 0) {
        deltaBC = (C.position.x - B.position.x) / (C.position.y - B.position.y);
    }
    double deltaAC = 0;
    if (C.position.y - A.position.y != 0) {
        deltaAC = (C.position.x - A.position.x) / (C.position.y - A.position.y);
    }

    double deltaABz = 0;
    if (B.position.y - A.position.y != 0 && B.position.z != A.position.z) {
        deltaABz = (B.position.z - A.position.z) / (B.position.y - A.position.y);
    }
    double deltaBCz = 0;
    if (C.position.y - B.position.y != 0 && C.position.z != B.position.z) {
        deltaBCz = (C.position.z - B.position.z) / (C.position.y - B.position.y);
    }
    double deltaACz = 0;
    if (C.position.y - A.position.y != 0 && C.position.z != A.position.z) {
        deltaACz = (C.position.z - A.position.z) / (C.position.y - A.position.y);
    }

    double deltaBCr = 0;
    if (C.position.y != B.position.y && Cr != Br) {
        deltaBCr = (Cr - Br) / (C.position.y - B.position.y);
    }
    double deltaACr = 0;
    if (C.position.y != A.position.y && Cr != Ar) {
        deltaACr = (Cr - Ar) / (C.position.y - A.position.y);
    }
    double deltaABr = 0;
    if (B.position.y != A.position.y && Br != Ar) {
        deltaABr = (Br - Ar) / (B.position.y - A.position.y);
    }

    double deltaBCg = 0;
    if (C.position.y != B.position.y && Cg != Bg) {
        deltaBCg = (Cg - Bg) / (C.position.y - B.position.y);
    }
    double deltaACg = 0;
    if (C.position.y != A.position.y && Cg != Ag) {
        deltaACg = (Cg - Ag) / (C.position.y - A.position.y);
    }
    double deltaABg = 0;
    if (B.position.y != A.position.y && Bg != Ag) {
        deltaABg = (Bg - Ag) / (B.position.y - A.position.y);
    }

    double deltaBCb = 0;
    if (C.position.y != B.position.y && Cb != Bb) {
        deltaBCb = (Cb - Bb) / (C.position.y - B.position.y);
    }
    double deltaACb = 0;
    if (C.position.y != A.position.y && Cb != Ab) {
        deltaACb = (Cb - Ab) / (C.position.y - A.position.y);
    }
    double deltaABb = 0;
    if (B.position.y != A.position.y && Bb != Ab) {
        deltaABb = (Bb - Ab) / (B.position.y - A.position.y);
    }

    double xl, xr;
    double zl, zr;
    double rl, rr;
    double gl, gr;
    double bl, br;

    xl = xr = A.position.x;
    zl = zr = A.position.z;
    rl = rr = Ar;
    gl = gr = Ag;
    bl = br = Ab;

    if (A.position.y - B.position.y == 0) {
        xr = B.position.x;
        zr = B.position.z;
        rr = Br;
        gr = Bg;
        br = Bb;
    }

    if (B.position.x < C.position.x && A.position.y != B.position.y) {
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

    for(double y = A.position.y; y <= C.position.y;y++) {
        [self horizontalLineWith:xl and:xr and:y and:zl and:zr and:rl and:rr and:gl and:gr and:bl and:br];

        if (y >= B.position.y){
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


-(void) horizontalLineWith:(double)x and:(double)x2 and:(double) y and:(double)zl and:(double) zr and:(double)r1 and:(double)r2 and:(double)g1 and:(double)g2 and:(double)b1 and:(double)b2 {
    if (x > x2){
        double tmp = x;
        x = x2;
        x2 = tmp;
    }

    double dr = (r2 - r1)/fabs(x2 - x);
    double dg = (g2 - g1)/fabs(x2 - x);
    double db = (b2 - b1)/fabs(x2 - x);
    double dz = (zr - zl)/fabs(x2 - x);

    for (;x < x2;x++) {
        [self lightPixel:x and:y and:zl and:r1 and:g1 and:b1];
        r1 += dr;
        g1 += dg;
        b1 += db;
        zl += dz;
    }
}

- (void)lightPixel:(double)x and:(double)y and:(double)z and:(double)r and:(double)g and:(double)b {
    YCMatrix *point = [[[Vector vectorWithX:x y:y z:z] applyTransformation:transformation] toMatrix];

    if (scene.lightSource.position == nil)
        return;

    double* lambdas = [currentTriangle findBarycentricX:x y:y];
    double l1 = lambdas[0];
    double l2 = lambdas[1];
    double l3 = lambdas[2];

    Color* color = [currentTriangle findColorByBarLambdasL1:l1 L2:l2 L3:l3];

    UInt8 r1 = (UInt8) (color.r * 255);
    UInt8 g1 = (UInt8) (color.g * 255);
    UInt8 b1 = (UInt8) (color.b * 255);
//    r *= fmin(1 * fattr * (dot + s), 1);
//    g *= fmin(1 * fattr * (dot + s), 1);
//    b *= fmin(1 * fattr * (dot + s), 1);
//
    put_pixel(x, y, z, r1, g1, b1);
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

void put_int_pixel(int xI, int yI, double z, UInt8 r, UInt8 g,UInt8 b ) {
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

void put_pixel(double x, double y, double z, UInt8 r, UInt8 g,UInt8 b ) {
    put_int_pixel((int) floor(x), (int) floor(y), z, r, g, b);
    put_int_pixel((int) ceil(x), (int) ceil(y), z, r, g, b);
}


int will_be_drawn (TPoint* p) {
    int x = (int)round(p->x);
    int y = (int)round(p->y);
    double z = p->z;

    int bufZAddr = y * width + x;
    return bufZ[bufZAddr] < z;

}
