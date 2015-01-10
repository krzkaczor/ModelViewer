//
// Created by Krzysztof Kaczor on 12/31/14.
//

#import <Foundation/Foundation.h>
#import "YCMatrix.h"

@interface YCMatrix (Affine3D)
+ (YCMatrix *)translationX:(double)x Y:(double)y Z:(double)z;

+ (YCMatrix *)scaleY:(double)y;

+ (YCMatrix *)scaleX:(double)x y:(double)y z:(double)z;

+ (YCMatrix *)rotateXWithAngle:(double)angle;

+ (YCMatrix *)rotateYWithAngle:(double)angle;

+ (YCMatrix *)rotateZWithAngle:(double)angle;

+ (YCMatrix *)assembleFromRightToLeft:(NSArray *)matrices;

- (YCMatrix *)makeHomogeneous;

- (YCMatrix *)transformHomogeneousVector;

- (double)vectorLength;

- (YCMatrix *)normalizeVector;

- (YCMatrix *)vectorByCrossProduct:(YCMatrix *)other;
@end