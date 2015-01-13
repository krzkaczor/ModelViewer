//
// Created by Krzysztof Kaczor on 1/6/15.
//

#import <MacTypes.h>
#import <YCMatrix/YCMatrix.h>
#import "Vertex.h"
#import "Vector.h"
#import "Color.h"
#import "YCMatrix+Affine3D.h"
#import "Triangle.h"


@implementation Vertex {

}
- (instancetype)initWithPosition:(Vector *)position color:(Color *)color {
    self = [super init];
    if (self) {
        self.position = position;
        self.color = color;
        self.triangles = [NSMutableArray array];
        self.luminescence = [Color black];
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    Vertex *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy.position = [self.position copy];
        copy.color = [self.color copy];
        copy.normal = [self.normal copy];
        copy.luminescence = [self.luminescence copy];
        copy.normal = [self.normal copy];
        copy.vectorToLightSource = [self.vectorToLightSource copy];
        copy.mirroredVectorToCamera = [self.mirroredVectorToCamera copy];
    }

    return copy;
}


- (id)applyTransformation:(YCMatrix *)transformation {

    Vertex* transformed = [Vertex vertexWithPosition:[_position applyTransformation:transformation] color:_color];
    transformed.normal = self.normal;
    transformed.vectorToLightSource = self.vectorToLightSource;
    transformed.mirroredVectorToCamera = self.mirroredVectorToCamera;
    return transformed;
}

+ (instancetype)vertexWithPosition:(Vector *)position color:(Color *)color {
    return [[self alloc] initWithPosition:position color:color];
}

- (void)connectedTo:(Triangle *)triangle {
    [self.triangles addObject:triangle];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.position=%@", self.position];
    [description appendFormat:@", self.color=%@", self.color];
    [description appendFormat:@", self.normal=%@", self.normal];
    [description appendString:@">"];
    return description;
}

- (void)calculateNormal {
    YCMatrix* sumOfVectors = [[Vector vectorWithX:0 y:0 z:0] toMatrix];
    [self.triangles enumerateObjectsUsingBlock:^(Triangle* triangle, NSUInteger idx, BOOL *stop) {
        YCMatrix* normal = [triangle normal];
        [sumOfVectors add:normal];
    }];

    self.normal = [sumOfVectors normalizeVector];
}

- (Vertex*) luminate {
    Vertex* v = [self copy];
    v.color.r *= v.luminescence.r;
    v.color.g *= v.luminescence.g;
    v.color.b *= v.luminescence.b;

    return v;
}


@end