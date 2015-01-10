//
// Created by Krzysztof Kaczor on 1/7/15.
//

#include <math.h>
#import "AllegroCTriangleRenderer.h"


void render_triangle(FPoint A, FPoint B, FPoint C) {
    //x
    double deltaAB = (B.x - A.x) / (B.y - A.y);
    double deltaBC = (C.x - B.x) / (C.y - B.y);
    double deltaAC = (C.x - A.x) / (C.y - A.y);
    //color
    //r
    double deltaABr = (B.r - A.r) / (B.y - A.y);
    double deltaBCr = (C.r - B.r) / (C.y - B.y);
    double deltaACr = (C.r - A.r) / (C.y - A.y);
    //g
    double deltaABg = (B.g - A.g) / (B.y - A.y);
    double deltaBCg = (C.g - B.g) / (C.y - B.y);
    double deltaACg = (C.g - A.g) / (C.y - A.y);
    //z
    double deltaABb = (B.b - A.b) / (B.y - A.y);
    double deltaBCb = (C.b - B.b) / (C.y - B.y);
    double deltaACb = (C.b - A.b) / (C.y - A.y);

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

    for(float y = A.y; y <= C.y;y++) {
        horizontal_line(xl, xr, y, rl, rr, gl, gr, bl, br);

        if (y >= B.y){
            xr += deltaBC;
            xl += deltaAC;
            rr += deltaBCr;
            rl += deltaACr;
//            gr += deltaBCg;
//            gl += deltaACg;
//            br += deltaBCb;
//            bl += deltaACb;
        } else {
            xr += deltaAB;
            xl += deltaAC;
            rr += deltaABr;
            rl += deltaACr;
//            gr += deltaABg;
//            gl += deltaACg;
        }

    }
}

void horizontal_line(float x, float x2, float y, float r1, float r2, float g1, float g2, float b1, float b2) {
    if (x > x2){
        float tmp = x;
        x = x2;
        x2 = tmp;
    }

    float dr = (r2 - r1)/(x2 - x);
    float dg = (g2 - g1)/(x2 - x);
    float db = (b2 - b1)/(x2 - x);
    for (;x < x2;x++) {
        al_draw_pixel(x,y,al_map_rgb_f(r1, g1, b1));//, g1, b1));
        r1 += dr;
        g1 += dg;
        b1 += db;
    }
    //al_draw_line(x, y, x2, y, al_map_rgb_f(1, 0, 0), 1);
};
