//
// Created by Krzysztof Kaczor on 1/2/15.
//

#import <Foundation/Foundation.h>
#import "Projection.h"


@interface PerspectiveProjection : NSObject<Projection>
@property YCMatrix* projectionMatrix;


@property double n, f, fov;

- (instancetype)initWithN:(double)n f:(double)f fov:(double)fov;

+ (instancetype)projectionWithN:(double)n f:(double)f fov:(double)fov;


@end