//
// Created by Krzysztof Kaczor on 1/7/15.
//

struct FPoint {
    float x, y;
    double z;
    float r,g,b;
};
typedef struct FPoint FPoint;

struct IPoint {
    int x, y;
    double z;
    float r,g,b;
};
typedef struct IPoint IPoint;

//void put_pixel(struct FPoint *P);
void horizontal_line(float x, float x2, float y, float r1, float r2, float g1, float g2, float b1, float b2);
void render_triangle(FPoint A, FPoint B, FPoint C);
