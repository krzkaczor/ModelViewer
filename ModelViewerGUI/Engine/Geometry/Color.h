//
// Created by Krzysztof Kaczor on 1/4/15.
//

#import <Foundation/Foundation.h>


@interface Color : NSObject <NSCopying>
@property float r,g,b;

- (id)copyWithZone:(NSZone *)zone;
- (instancetype)initWithR:(float)r g:(float)g b:(float)b;

+ (instancetype)colorWithR:(float)r g:(float)g b:(float)b;

- (Color *)normalize;

- (NSString *)description;

- (YCMatrix *)toMatrix;

+ (Color *)colorFromMatrix:(YCMatrix *)matrix;

+ (Color *)red;

+ (Color *)black;

+ (Color *)white;

+ (Color *)green;

+ (Color *)blue;
@end