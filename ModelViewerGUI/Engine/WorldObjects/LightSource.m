//
// Created by Krzysztof Kaczor on 1/4/15.
//

#import "LightSource.h"
#import "DoublePoint.h"
#import "Color.h"
#import "Vector.h"


@implementation LightSource {

}
- (instancetype)initWithPosition:(Vector *)position color:(Color *)color {
    self = [super init];
    if (self) {
        self.position = position;
        self.color = color;
        _c2 = _c1 = _c0 = 0;
    }

    return self;
}

+ (instancetype)sourceWithPosition:(Vector *)position color:(Color *)color {
    return [[self alloc] initWithPosition:position color:color];
}

+ (LightSource *)sourceWithPosition:(Vector *)position {
    return [[self alloc] initWithPosition:position color:[Color colorWithR:1 g:1 b:1]];
}
@end