//
// Created by Krzysztof Kaczor on 1/3/15.
//

#import "AllegroInterpolatingTriangleRenderer.h"
#import "Triangle.h"
#import "DoublePoint.h"
#import "Vector.h"
#import "Color.h"
#import "Vertex.h"
#import "AllegroCTriangleRenderer.h"
#import <allegro5/allegro_primitives.h>


void putPixel(DoublePoint *point3D);
BOOL testBufferZ(int x, int y, double z );
void clear_z_buffer() ;

@implementation AllegroInterpolatingTriangleRenderer {

}

- (void)startRenderCycle {
    //clear_z_buffer();
}

- (void)renderTriangle:(Triangle *)triangle {
    float x1 = (int) (triangle.v1.position.x);
    float x2 = (int) (triangle.v2.position.x);
    float x3 = (int) (triangle.v3.position.x);

    float y1 = (int) (triangle.v1.position.y);
    float y2 = (int) (triangle.v2.position.y);
    float y3 = (int) (triangle.v3.position.y);

    struct FPoint p1 = {x1, y1, triangle.v1.position.z, triangle.v1.color.r, triangle.v1.color.g, triangle.v1.color.b};
    struct FPoint p2 = {x2, y2, triangle.v2.position.z, triangle.v2.color.r, triangle.v2.color.g, triangle.v2.color.b};
    struct FPoint p3 = {x3, y3, triangle.v3.position.z, triangle.v3.color.r, triangle.v3.color.g, triangle.v3.color.b};

    render_triangle(p1,p2,p3);
}
@end

int Z_BUFFER_MAX;
double Z_BUFFER [640*480];

void clear_z_buffer() {
    Z_BUFFER_MAX = 640 * 480;

    for (int i = 0; i < Z_BUFFER_MAX; i++) {
        Z_BUFFER[i] = DBL_MAX;
    }
}


void putPixel(DoublePoint *point3D) {
    int x = (int) round((float)point3D.position.x);
    int y = (int) round((float)point3D.position.y);
    if (testBufferZ(x, y, point3D.position.z)) {
        al_draw_pixel(x, y, al_map_rgb_f(point3D.color.r, point3D.color.g, point3D.color.b));
    }
}



BOOL testBufferZ(int x, int y, double z ) {
    int index = x*640+y;

    if (index > Z_BUFFER_MAX || index < 0 || Z_BUFFER[index] < z)
        return NO;

    Z_BUFFER[index] = z;
    return YES;
}






/*float dx1, dx2, dx3;
    float dr1, dg1, db1;
    float dr2, dg2, db2;
    float dr3, dg3, db3;
    float dr, dg, db;

    if (triangle.v2.position.y-triangle.v1.position.y > 0) {
        dx1=(triangle.v2.position.x-triangle.v1.position.x)/(triangle.v2.position.y-triangle.v1.position.y);
        dr1=(triangle.v2.color.r - triangle.v1.color.r)/(triangle.v2.position.y-triangle.v1.position.y);
        dg1=(triangle.v2.color.g - triangle.v1.color.g)/(triangle.v2.position.y-triangle.v1.position.y);
        db1=(triangle.v2.color.b - triangle.v1.color.b)/(triangle.v2.position.y-triangle.v1.position.y);
    } else
        dx1=dr1=dg1=db1=0;

    if (triangle.v3.position.y-triangle.v1.position.y > 0) {
        dx2=(triangle.v3.position.x-triangle.v1.position.x)/(triangle.v3.position.y-triangle.v1.position.y);
        dr2=(triangle.v3.color.r-triangle.v1.color.r)/(triangle.v3.position.y-triangle.v1.position.y);
        dg2=(triangle.v3.color.g-triangle.v1.color.g)/(triangle.v3.position.y-triangle.v1.position.y);
        db2=(triangle.v3.color.b-triangle.v1.color.b)/(triangle.v3.position.y-triangle.v1.position.y);
    } else
        dx2=dr2=dg2=db2=0;

    if (triangle.v3.position.y-triangle.v2.position.y > 0) {
        dx3=(triangle.v3.position.x-triangle.v2.position.x)/(triangle.v3.position.y-triangle.v2.position.y);
        dr3=(triangle.v3.color.r-triangle.v2.color.r)/(triangle.v3.position.y-triangle.v2.position.y);
        dg3=(triangle.v3.color.g-triangle.v2.color.g)/(triangle.v3.position.y-triangle.v2.position.y);
        db3=(triangle.v3.color.b-triangle.v2.color.b)/(triangle.v3.position.y-triangle.v2.position.y);
    } else
        dx3=dr3=dg3=db3=0;

    DoublePoint *S, *E, *P;
    S = [triangle.v1 copy];
    E = [triangle.v1 copy];
    if(dx1 > dx2) {
        for(;S.position.y<=triangle.v2.position.y;S.position.y++,E.position.y++) {
            if(E.position.x-S.position.x > 0) {
                dr = (E.color.r   - S.color.r)/(E.position.x-S.position.x);
                dg = (E.color.g - S.color.g)/(E.position.x-S.position.x);
                db = (E.color.b  - S.color.b)/(E.position.x-S.position.x);
            } else
                dr=dg=db=0;
            P = [S copy];
            for(;P.position.x < E.position.x;P.position.x++) {
                putPixel(P);
                P.color.r += dr;
                P.color.g += dg;
                P.color.b += db;
            }
            S.position.x+=dx2;
            S.color.r += dr2;
            S.color.g += dg2;
            S.color.b += db2;
            E.position.x+=dx1;
            E.color.r += dr1;
            E.color.g += dg1;
            E.color.b += db1;
        }

        E = [triangle.v2 copy];
        for(;S.position.y<=triangle.v3.position.y;S.position.y++,E.position.y++) {
            if(E.position.x-S.position.x > 0) {
                dr = (E.color.r   - S.color.r)/(E.position.x-S.position.x);
                dg = (E.color.g - S.color.g)/(E.position.x-S.position.x);
                db = (E.color.b  - S.color.b)/(E.position.x-S.position.x);
            } else
                dr=dg=db=0;
            P= [S copy];
            for(;P.position.x < E.position.x;P.position.x++) {
                putPixel(P);
                P.color.r += dr;
                P.color.g += dg;
                P.color.b += db;
            }
            S.position.x+=dx2;
            S.color.r += dr2;
            S.color.g += dg2;
            S.color.b += db2;

            E.position.x+=dx3;
            E.color.r += dr3;
            E.color.g += dg3;
            E.color.b += db3;
        }
    } else {
        for(;S.position.y<=triangle.v2.position.y;S.position.y++,E.position.y++) {
            if(E.position.x-S.position.x > 0) {
                dr = (E.color.r   - S.color.r)/(E.position.x-S.position.x);
                dg = (E.color.g - S.color.g)/(E.position.x-S.position.x);
                db = (E.color.b  - S.color.b)/(E.position.x-S.position.x);
            } else
                dr=dg=db=0;

            P = [S copy];
            for(;P.position.x < E.position.x;P.position.x++) {
                putPixel(P);
                P.color.r += dr;
                P.color.g += dg;
                P.color.b += db;
            }
            S.position.x+=dx1;
            S.color.r += dr1;
            S.color.g += dg1;
            S.color.b += db1;
            E.position.x+=dx2;
            E.color.r += dr2;
            E.color.g += dg2;
            E.color.b += db2;
        }

        S= [triangle.v2 copy];
        for(;S.position.y<=triangle.v3.position.y;S.position.y++,E.position.y++) {
            if(E.position.x-S.position.x > 0) {
                dr = (E.color.r   - S.color.r)/(E.position.x-S.position.x);
                dg = (E.color.g - S.color.g)/(E.position.x-S.position.x);
                db = (E.color.b  - S.color.b)/(E.position.x-S.position.x);
            } else
                dr=dg=db=0;

            P= [S copy];
            for(;P.position.x < E.position.x;P.position.x++) {
                putPixel(P);
                P.color.r += dr;
                P.color.g += dg;
                P.color.b += db;
            }
            S.position.x+=dx3;
            S.color.r += dr3;
            S.color.g += dg3;
            S.color.b += db3;
            E.position.x+=dx2;
            E.color.r += dr2;
            E.color.g += dg2;
            E.color.b += db2;
        }
    }*/