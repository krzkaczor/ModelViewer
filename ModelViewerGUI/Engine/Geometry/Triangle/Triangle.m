//
// Created by Krzysztof Kaczor on 12/29/14.
//

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
        //sort points by y
        NSArray *arr = @[p1, p2 ,p3];
        NSArray *sortedArray = [arr sortedArrayUsingComparator:^NSComparisonResult(Vertex * a, Vertex * b) {
            NSNumber *first = @(a.position.y);
            NSNumber *second = @(b.position.y);
            NSComparisonResult res = [first compare:second];
            if (res != NSOrderedSame) return res;
            //sort by x if z are equal
            first = @(a.position.z);
            second = @(b.position.z);
            return [first compare:second];
        }];
        self.v1 = sortedArray[0];
        self.v2 = sortedArray[1];
        self.v3 = sortedArray[2];

        [self.v1 connectedTo:self];
        [self.v2 connectedTo:self];
        [self.v3 connectedTo:self];
    }

    return self;
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
    YCMatrix* a = [[_v1.position toMatrix] matrixBySubtracting:[_v2.position toMatrix]];
    YCMatrix* b = [[_v3.position toMatrix] matrixBySubtracting:[_v2.position toMatrix]];

    YCMatrix* normal = [[a vectorByCrossProduct:b] normalizeVector];
    YCMatrix* negatedNormal = [normal matrixByNegating];

    //check which one leads outside of model
    //shitty way but it is done only once after loading model
    YCMatrix* vector1 = self.v1.position.toMatrix;
    YCMatrix* vectorWithNormal = [vector1 matrixByAdding:normal];
    YCMatrix* vectorWithNegatedNormal = [vector1 matrixByAdding:negatedNormal];

    double len1 = [[vectorWithNormal matrixBySubtracting:[pointInside toMatrix]] vectorLength];
    double len2 = [[vectorWithNegatedNormal matrixBySubtracting:[pointInside toMatrix]] vectorLength];

    if (len1 > len2)
        self.normal = normal;
    else
        self.normal = negatedNormal;
}

- (NSArray*)split {
    double x1 = self.v1.position.x;
    double y1 = self.v1.position.y;
    double x2 = self.v2.position.x;
    double y2 = self.v2.position.y;
    double x3 = self.v3.position.x;
    double y3 = self.v3.position.y;

    double y4 = y2;
    double x4 =((y4 - y1) * ((x1 - x3) / (y1 - y3)) + x1);

    //color interpolation

    Vertex* v1 = self.v1;
    Vertex* v2 = self.v2;
    Vertex* v3 = self.v3;
    Vertex* v4 = [Vertex vertexWithPosition:[Vector vectorWithX:x4 y:y4 z:1]color:Color.red];
    Triangle* t1 = [Triangle triangleWithP1:v1 p2:v2 p3:v4];
    Triangle* t2 = [Triangle triangleWithP1:v2 p2:v3 p3:v4];

    return @[t1, t2];
}
@end