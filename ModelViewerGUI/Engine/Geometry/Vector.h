//
// Created by Krzysztof Kaczor on 12/29/14.
//

#import <Foundation/Foundation.h>
#import "Transformable.h"

@class YCMatrix;


@interface Vector : NSObject <NSCopying, Transformable>
@property double x;
@property double y;
@property (readonly) double z;

- (instancetype)initWithX:(double)x y:(double)y z:(double)z;

- (YCMatrix *)toHomogeneousMatrix;

- (YCMatrix *)toMatrix;

+ (instancetype)vectorWithX:(double)x y:(double)y z:(double)z;

+ (Vector *)vectorFromMatrix:(YCMatrix *)matrix;

- (id)copyWithZone:(NSZone *)zone;

- (NSString *)description;
@end