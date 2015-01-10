//
// Created by Krzysztof Kaczor on 1/3/15.
//

#import "DoublePoint.h"
#import "Vector.h"
#import "YCMatrix.h"
#import "Color.h"


@implementation DoublePoint {

}
- (instancetype)initWithPos:(Vector *)pos color:(Color *)color {
    self = [super init];
    if (self) {
        self.position = pos;
        self.color = color;
    }

    return self;
}

+ (instancetype)pointWithPos:(Vector *)pos color:(Color *)color {
    return [[self alloc] initWithPos:pos color:color];
}

- (DoublePoint *)applyTransformation:(YCMatrix *)transformation {
    return [DoublePoint pointWithPos:[self.position applyTransformation:transformation] color:self.color];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.position=%@", self.position];
    [description appendFormat:@", self.color=%@", self.color];
    [description appendString:@">"];
    return description;
}

- (id)copyWithZone:(NSZone *)zone {
    DoublePoint *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy.position = [self.position copy];
        copy.color = [self.color copy];
    }

    return copy;
}


@end