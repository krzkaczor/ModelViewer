//
// Created by Krzysztof Kaczor on 1/6/15.
//

#import <MacTypes.h>
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
    }

    return copy;
}


- (id)applyTransformation:(YCMatrix *)transformation {
    return [Vertex vertexWithPosition:[_position applyTransformation:transformation] color:_color];
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
    int l = self.triangles.count;

    __block double x, y, z;
    x = y = z = 0;

    [self.triangles enumerateObjectsUsingBlock:^(Triangle* triangle, NSUInteger idx, BOOL *stop) {
        YCMatrix* normal = [triangle normal];
        x += [normal valueAtRow:0 Column:0];
        y += [normal valueAtRow:1 Column:0];
        z += [normal valueAtRow:2 Column:0];
    }];

    double normal_arr [] = {x / l, y / l, z / l};
    self.normal = [[YCMatrix matrixFromArray:normal_arr Rows:3 Columns:1] normalizeVector];
}


@end