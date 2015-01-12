//
// Created by Krzysztof Kaczor on 12/29/14.
//

#import "Vector.h"
#import "YCMatrix.h"


@implementation Vector
- (instancetype)initWithX:(double)x y:(double)y z:(double)z {
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
        _z = z;
    }

    return self;
}

+ (instancetype)vectorWithX:(double)x y:(double)y z:(double)z {
    return [[self alloc] initWithX:x y:y z:z];
}

- (YCMatrix*)toHomogeneousMatrix {
    double matrixValues [] = {self.x, self.y, self.z, 1};
    return [YCMatrix matrixFromArray:matrixValues Rows:4 Columns:1];
}

- (YCMatrix*)toMatrix {
    double matrixValues [] = {self.x, self.y, self.z};
    return [YCMatrix matrixFromArray:matrixValues Rows:3 Columns:1];
}

- (Vector*)applyTransformation:(YCMatrix*)transformation {
    YCMatrix *v = [self toHomogeneousMatrix];
    YCMatrix *transformedV = [transformation matrixByMultiplyingWithRight:v];

    double w = [transformedV valueAtRow:3 Column:0];
    double x = [transformedV valueAtRow:0 Column:0] / w;
    double y = [transformedV valueAtRow:1 Column:0] / w;
    double z = [transformedV valueAtRow:2 Column:0] / w;

    return [Vector vectorWithX:x y:y z:z];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.x=%f", self.x];
    [description appendFormat:@", self.y=%f", self.y];
    [description appendFormat:@", self.z=%f", self.z];
    [description appendString:@">"];
    return description;
}


- (id)copyWithZone:(NSZone *)zone {
    Vector *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->_x = self.x;
        copy->_y = self.y;
        copy->_z = _z;
    }

    return copy;
}

+ (Vector*)vectorFromMatrix:(YCMatrix*)matrix {
    double x = [matrix valueAtRow:0 Column:0];
    double y = [matrix valueAtRow:1 Column:0];
    double z = [matrix valueAtRow:2 Column:0];

    return [Vector vectorWithX:x y:y z:z];
}

- (BOOL)isInRadiusOf:(int)i withVector:(Vector *)vector {
    double minX = vector.x - i;
    double maxX = vector.x + i;
    double minY = vector.y - i;
    double maxY = vector.y + i;

    return self.x >= minX && self.x <= maxX && self.y >= minY && self.y <= maxY;
}


@end