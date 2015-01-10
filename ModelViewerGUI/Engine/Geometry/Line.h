//
// Created by Krzysztof Kaczor on 1/6/15.
//

#import <Foundation/Foundation.h>
#import "Transformable.h"

@class Vector;
@class Color;


@interface Line : NSObject<Transformable>
@property Vector* a;
@property Vector* b;
@property Color* color;

- (instancetype)initWithA:(Vector *)a b:(Vector *)b color:(Color *)color;

+ (instancetype)lineWithA:(Vector *)a b:(Vector *)b color:(Color *)color;

@end