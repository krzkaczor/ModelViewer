//
// Created by Krzysztof Kaczor on 1/6/15.
//

#import "Line.h"
#import "Vector.h"
#import "Color.h"
#import "YCMatrix.h"


@implementation Line {

}
- (instancetype)initWithA:(Vector *)a b:(Vector *)b color:(Color *)color {
    self = [super init];
    if (self) {
        self.a = a;
        self.b = b;
        self.color = color;
    }

    return self;
}

- (id)applyTransformation:(YCMatrix *)transformation {
    return [Line lineWithA:[self.a applyTransformation:transformation]  b:[self.b applyTransformation:transformation] color:self.color];
}

+ (instancetype)lineWithA:(Vector *)a b:(Vector *)b color:(Color *)color {
    return [[self alloc] initWithA:a b:b color:color];
}

@end