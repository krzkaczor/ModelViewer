//
// Created by Krzysztof Kaczor on 1/2/15.
//

#import <Foundation/Foundation.h>
#import "Projection.h"


@interface OrthographicProjection : NSObject<Projection>
@property double r,l, t, b, f, n;

- (instancetype)initWithRight:(double)r left:(double)l top:(double)t bottom:(double)b far:(double)f near:(double)n;

+ (instancetype)projectionWithRight:(double)r left:(double)l top:(double)t bottom:(double)b far:(double)f near:(double)n;

@end