//
// Created by Krzysztof Kaczor on 1/2/15.
//

#import "PerspectiveProjection.h"
#import "YCMatrix.h"


@implementation PerspectiveProjection {

}
- (instancetype)initWithN:(double)n f:(double)f fov:(double)fov {
    self = [super init];
    if (self) {
        self.n = n;
        self.f = f;
        self.fov = fov;

        //zamienic na ta z wykladu d = |E-d|
        double s = 1/ tan(fov * 0.5);
        double projectionMatrixArr[] = {
                s, 0, 0, 0,
                0, s, 0, 0,
                0, 0, -f/(f-n), -f*n/(f-n),
                0, 0, 1, 0
        };

        self.projectionMatrix = [Matrix matrixFromArray:projectionMatrixArr Rows:4 Columns:4];
    }

    return self;
}

+ (instancetype)projectionWithN:(double)n f:(double)f fov:(double)fov {
    return [[self alloc] initWithN:n f:f fov:fov];
}

@end