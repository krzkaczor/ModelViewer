//
// Created by Krzysztof Kaczor on 1/4/15.
//

#import <Foundation/Foundation.h>

@class Color;
@class Vector;


@interface LightSource : NSObject
@property Vector *position;
@property Color *color;
@property double c2, c1, c0;

- (instancetype)initWithPosition:(Vector *)position color:(Color *)color;

+ (instancetype)sourceWithPosition:(Vector *)position color:(Color *)color;

+ (LightSource *)sourceWithPosition:(Vector *)vector;
@end