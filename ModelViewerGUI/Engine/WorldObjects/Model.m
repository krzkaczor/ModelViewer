//
// Created by Krzysztof Kaczor on 12/29/14.
//

#import "Model.h"
#import "YCMatrix.h"
#import "Triangle.h"
#import "Vertex.h"
#import "Vector.h"


@implementation Model {

}

- (instancetype)initWithVertices:(NSArray *)vertices triangles:(NSArray *)triangles pointInside:(Vector *)pointInside {
    self = [super init];
    if (self) {
        self.vertices = vertices;
        self.triangles = triangles;
        self.pointInside=pointInside;
    }

    return self;
}

+ (instancetype)modelWithVertices:(NSArray *)vertices triangles:(NSArray *)triangles pointInside:(Vector *)pointInside {
    return [[self alloc] initWithVertices:vertices triangles:triangles pointInside:pointInside];
}

- (void)calculateTriangleNormals {
    [self.triangles enumerateObjectsUsingBlock:^(Triangle* triangle, NSUInteger idx, BOOL *stop) {
        [triangle calculateNormalKnowingPointInside:self.pointInside];
    }];
}

- (void)calculateVerticlesNormals {
    [self.vertices enumerateObjectsUsingBlock:^(Vertex* vertex, NSUInteger idx, BOOL *stop) {
        [vertex calculateNormal];
    }];
}
@end