//
// Created by Krzysztof Kaczor on 1/4/15.
//

#import <objc/objc-api.h>
#import "Color.h"


@implementation Color {

}
- (instancetype)initWithR:(float)r g:(float)g b:(float)b {
    self = [super init];
    if (self) {
        self.r = r;
        self.g = g;
        self.b = b;
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    Color *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy.r = self.r;
        copy.g = self.g;
        copy.b = self.b;
    }

    return copy;
}


+ (instancetype)colorWithR:(float)r g:(float)g b:(float)b {
    return [[self alloc] initWithR:r g:g b:b];
}

- (Color *)normalize {
    return [Color colorWithR:self.r > 1? 1: self.r g:self.g > 1? 1: self.g b:self.b > 1? 1: self.b];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.r=%f", self.r];
    [description appendFormat:@", self.g=%f", self.g];
    [description appendFormat:@", self.b=%f", self.b];
    [description appendString:@">"];
    return description;
}


+ (Color *)red {
    return [Color colorWithR:1 g:0 b:0];
}

+ (Color *)black {
    return [Color colorWithR:0 g:0 b:0];
}

+ (Color *)white {
    return [Color colorWithR:1 g:1 b:1];
}

+ (Color *)green {
    return [Color colorWithR:0 g:1 b:0];
}

+ (Color *)blue {
    return [Color colorWithR:0 g:0 b:1];
}
@end