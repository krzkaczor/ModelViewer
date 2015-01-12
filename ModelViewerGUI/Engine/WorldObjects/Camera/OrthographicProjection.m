//
// Created by Krzysztof Kaczor on 1/2/15.
//

#import <objc/objc-api.h>
#import "OrthographicProjection.h"
#import "YCMatrix.h"


@implementation OrthographicProjection {

}

@synthesize projectionMatrix;

- (instancetype)initWithRight:(double)r left:(double)l top:(double)t bottom:(double)b far:(double)f near:(double)n {
    self = [super init];
    if (self) {
        self.r = r;
        self.l = l;
        self.t = t;
        self.b = b;
        self.f = f;
        self.n = n;

        double projectionMatrixArr[] = {
                2/(r-l), 0, 0, -(r + l)/(r - l),
                0, 2/(t-b), 0, -(t + b)/(t - b),
                0, 0, -1/(f-n), n/(f - n),
                0, 0, 0, 1
        };

        self.projectionMatrix = [YCMatrix matrixFromArray:projectionMatrixArr Rows:4 Columns:4];
    }

    return self;
}

+ (instancetype)projectionWithRight:(double)r left:(double)l top:(double)t bottom:(double)b far:(double)f near:(double)n {
    return [[self alloc] initWithRight:r left:l top:t bottom:b far:f near:n];
}

+ (instancetype)projectionWithSize:(double)size {
    return [self projectionWithRight:size left:-size top:size bottom:-size far:1 near:10];
}


@end