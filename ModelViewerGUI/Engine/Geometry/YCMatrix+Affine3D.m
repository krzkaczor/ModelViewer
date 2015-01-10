//
// Created by Krzysztof Kaczor on 12/31/14.
//

#import "YCMatrix+Affine3D.h"


@implementation YCMatrix (Affine3D)

+ (YCMatrix*) translationX:(double)x Y:(double)y Z: (double)z {
    double affineArr [] = {
            1, 0, 0, x,
            0, 1, 0, y,
            0, 0, 1, z,
            0, 0, 0, 1
    };
    return [YCMatrix matrixFromArray:affineArr Rows:4 Columns:4];
}

+ (YCMatrix*) scaleY:(double)y {
    double affineArr [] = {
            1, 0, 0, 0,
            0, y, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1
    };
    return [YCMatrix matrixFromArray:affineArr Rows:4 Columns:4];
}

+ (YCMatrix*) scaleX:(double)x y:(double)y z:(double)z {
    double affineArr [] = {
            x, 0, 0, 0,
            0, y, 0, 0,
            0, 0, z, 0,
            0, 0, 0, 1
    };
    return [YCMatrix matrixFromArray:affineArr Rows:4 Columns:4];
}

+ (YCMatrix*) rotateXWithAngle:(double)angle {
    double affineArr [] = {
            1, 0, 0, 0,
            0, cos(angle), -sin(angle), 0,
            0, sin(angle), cos(angle), 0,
            0, 0, 0, 1
    };
    return [YCMatrix matrixFromArray:affineArr Rows:4 Columns:4];
}

+ (YCMatrix*) rotateYWithAngle:(double)angle {
    double affineArr [] = {
            cos(angle), 0, sin(angle), 0,
            0, 1, 0, 0,
            -sin(angle), 0, cos(angle), 0,
            0, 0, 0, 1
    };
    return [YCMatrix matrixFromArray:affineArr Rows:4 Columns:4];
}

+ (YCMatrix*) rotateZWithAngle:(double)angle {
    double affineArr [] = {
            cos(angle), 0, sin(angle), 0,
            -sin(angle), 0, cos(angle), 0,
            0, 0, 1, 0,
            0, 0, 0, 1
    };
    return [YCMatrix matrixFromArray:affineArr Rows:4 Columns:4];
}

+(YCMatrix*) assembleFromRightToLeft:(NSArray*)matrices {
    YCMatrix *result = [YCMatrix identityOfRows:4 Columns:4];
    for (int i = matrices.count - 1; i >= 0; i--) {
        result = [matrices[i] matrixByMultiplyingWithRight:result];
    }

    return result;
}

- (YCMatrix*) makeHomogeneous {
    double arr []= {
            [self valueAtRow:0 Column:0],
            [self valueAtRow:1 Column:0],
            [self valueAtRow:2 Column:0],
            1
    };
    return [YCMatrix matrixFromArray:arr Rows:4 Columns:1];
}

-(double) vectorLength {
    double a = [self valueAtRow:0 Column:0];
    double b = [self valueAtRow:1 Column:0];
    double c = [self valueAtRow:2 Column:0];

    return sqrt(a*a + b*b + c*c);
}

-(YCMatrix*) normalizeVector {
    double l = [self vectorLength];

    double arr []= {
            [self valueAtRow:0 Column:0] / l,
            [self valueAtRow:1 Column:0] / l,
            [self valueAtRow:2 Column:0] / l,
    };
    return [YCMatrix matrixFromArray:arr Rows:3 Columns:1];
}

-(YCMatrix*) vectorByCrossProduct:(YCMatrix*)other {
    YCMatrix* a = self;
    YCMatrix* b = other;

    double res[] = {
            [a valueAtRow:1 Column:0] * [b valueAtRow:2 Column:0] - [a valueAtRow:2 Column:0] * [b valueAtRow:1 Column:0],
            [a valueAtRow:2 Column:0] * [b valueAtRow:0 Column:0] - [a valueAtRow:0 Column:0] * [b valueAtRow:2 Column:0],
            [a valueAtRow:0 Column:0] * [b valueAtRow:1 Column:0] - [a valueAtRow:1 Column:0] * [b valueAtRow:0 Column:0]
    };
    return [YCMatrix matrixFromArray:res Rows:3 Columns:1];
}
@end