//
// Created by Krzysztof Kaczor on 12/29/14.
//

#import <objc/objc-api.h>
#import "Triangle.h"
#import "Vector.h"
#import "YCMatrix.h"
#import "DoublePoint.h"
#import "YCMatrix+Affine3D.h"
#import "Vertex.h"
#import "Color.h"


@implementation Triangle
- (instancetype)initWithP1:(Vertex *)p1 p2:(Vertex *)p2 p3:(Vertex *)p3 {
    self = [super init];
    if (self) {
        self.v1 = p1;
        self.v2 = p2;
        self.v3 = p3;

        [self.v1 connectedTo:self];
        [self.v2 connectedTo:self];
        [self.v3 connectedTo:self];
        _z = (p1.position.z + p2.position.z + p3.position.z) / 3;
    }

    return self;
}

- (void)sortVertices {
    //sort points by y
    NSArray *arr = @[self.v1, self.v2 ,self.v3];
    NSArray *sortedArray = [arr sortedArrayUsingComparator:^NSComparisonResult(Vertex * a, Vertex * b) {
        NSNumber *first = @(a.position.y);
        NSNumber *second = @(b.position.y);
        NSComparisonResult res = [first compare:second];
        if (res != NSOrderedSame) return res;
        //sort by x if y are equal
        first = @(a.position.x);
        second = @(b.position.x);
        return [first compare:second];
    }];

    self.v1 = sortedArray[0];
    self.v2 = sortedArray[1];
    self.v3 = sortedArray[2];
}

+ (instancetype)triangleWithP1:(Vertex *)p1 p2:(Vertex *)p2 p3:(Vertex *)p3 {
    return [[self alloc] initWithP1:p1 p2:p2 p3:p3];
}

- (Triangle*)applyTransformation:(YCMatrix*)transformation {
    Vertex * v1 = [self.v1 applyTransformation:transformation];
    Vertex * v2 = [self.v2 applyTransformation:transformation];
    Vertex * v3 = [self.v3 applyTransformation:transformation];

    return [Triangle triangleWithP1:v1 p2:v2 p3:v3];
}

- (void)calculateNormalKnowingPointInside:(Vector *)pointInside {
    YCMatrix* a = [[_v3.position toMatrix] matrixBySubtracting:[_v2.position toMatrix]];
    YCMatrix* b = [[_v1.position toMatrix] matrixBySubtracting:[_v2.position toMatrix]];

    self.normal = [[a vectorByCrossProduct:b] normalizeVector];
    //YCMatrix* negatedNormal = [normal matrixByNegating];

    //check which one leads outside of model
    //shitty way but it is done only once after loading model
//    YCMatrix* vector1 = self.v1.position.toMatrix;
//    YCMatrix* vectorWithNormal = [vector1 matrixByAdding:normal];
//    YCMatrix* vectorWithNegatedNormal = [vector1 matrixByAdding:negatedNormal];
//
//    double len1 = [[vectorWithNormal matrixBySubtracting:[pointInside toMatrix]] vectorLength];
//    double len2 = [[vectorWithNegatedNormal matrixBySubtracting:[pointInside toMatrix]] vectorLength];
//
//    if (len1 > len2)
//        self.normal = normal;
//    else
//        self.normal = negatedNormal;
}

- (id)copyWithZone:(NSZone *)zone {
    Triangle *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy.v1 = self.v1;
        copy.v2 = self.v2;
        copy.v3 = self.v3;
        copy.normal = self.normal;
    }

    return copy;
}


- (Triangle*) luminate {
    Triangle * t = [self copy];
    t.v1 = [t.v1 luminate];
    t.v2 = [t.v2 luminate];
    t.v3 = [t.v3 luminate];
    return t;
}

- (NSArray*)split {
    [self sortVertices];

    double x1 = self.v1.position.x;
    double y1 = self.v1.position.y;
    double z1 = self.v1.position.z;
    double r1 = self.v1.color.r;
    double g1 = self.v1.color.g;
    double b1 = self.v1.color.b;

    double x2 = self.v2.position.x;
    double y2 = self.v2.position.y;
    double z2 = self.v2.position.z;
    double r2 = self.v2.color.r;
    double g2 = self.v2.color.g;
    double b2 = self.v2.color.b;

    double x3 = self.v3.position.x;
    double y3 = self.v3.position.y;
    double z3 = self.v3.position.z;
    double r3 = self.v3.color.r;
    double g3 = self.v3.color.g;
    double b3 = self.v3.color.b;

    if (y1 == y2 && y2 == y3) {
        return @[self];
    }

    double y4 = y2;
    double x4 =((y4 - y1) * ((x1 - x3) / (y1 - y3)) + x1);
    double z4 =((y4 - y1) * ((z1 - z3) / (y1 - y3)) + z1);

    double r4 =((y4 - y1) * ((r1 - r3) / (y1 - y3)) + r1);
    double g4 =((y4 - y1) * ((g1 - g3) / (y1 - y3)) + g1);
    double b4 =((y4 - y1) * ((b1 - b3) / (y1 - y3)) + b1);

    //color interpolation
    Vertex* v1 = self.v1;
    Vertex* v2 = self.v2;
    Vertex* v3 = self.v3;
    Vertex* v4 = [Vertex vertexWithPosition:[Vector vectorWithX:x4 y:y4 z:z4]color:[Color colorWithR:r4 g:g4 b:b4]];
    Triangle* t1 = [Triangle triangleWithP1:v1 p2:v2 p3:v4];
    Triangle* t2 = [Triangle triangleWithP1:v2 p2:v3 p3:v4];

    [t1 sortVertices];
    [t2 sortVertices];

    return @[t1, t2];
}

@end