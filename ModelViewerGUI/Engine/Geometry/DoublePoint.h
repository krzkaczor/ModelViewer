//
// Created by Krzysztof Kaczor on 1/3/15.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "Transformable.h"
#import "Color.h"

@class Vector;
@class YCMatrix;

@interface DoublePoint : NSObject <NSCopying, Transformable>

@property Vector* position;
@property Color* color;

- (instancetype)initWithPos:(Vector *)pos color:(Color *)color;

+ (instancetype)pointWithPos:(Vector *)pos color:(Color *)color;

- (id)copyWithZone:(NSZone *)zone;

- (NSString *)description;
@end