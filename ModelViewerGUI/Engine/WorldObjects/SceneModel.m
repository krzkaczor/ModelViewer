//
// Created by Krzysztof Kaczor on 12/30/14.
//

#import "SceneModel.h"
#import "Model.h"
#import "YCMatrix.h"
#import "LightSource.h"
#import "Triangle.h"
#import "DoublePoint.h"
#import "Vector.h"
#import "YCMatrix+Affine3D.h"
#import "Color.h"
#import "Vertex.h"
#import "DebugService.h"
#import "Line.h"


@implementation SceneModel {

}
- (instancetype)initWithModel:(Model *)model modelToWorldMatrix:(YCMatrix *)modelToWorldMatrix {
    self = [super init];
    if (self) {
        self.model = model;
        self.modelToWorldMatrix = modelToWorldMatrix;
    }

    return self;
}

+ (instancetype)modelOnSceneWithModel:(Model *)model modelToWorldMatrix:(YCMatrix *)modelToWorldMatrix {
    return [[self alloc] initWithModel:model modelToWorldMatrix:modelToWorldMatrix];
}

- (void)lightUsingLightSource:(LightSource *)lightSource {
    [self.model.vertices enumerateObjectsUsingBlock:^(Vertex* vertex, NSUInteger idx, BOOL *stop) {
        YCMatrix *point = [vertex.position toMatrix];

        //vector to light
        YCMatrix *vectorToLightSource = [[lightSource.position toMatrix] matrixBySubtracting:point];
        double r = [vectorToLightSource vectorLength];

        double fattr = 1/(lightSource.c2*r*r + lightSource.c1 * r + lightSource.c0);

        vertex.luminescence.r += 1 * fattr * lightSource.color.r * [[vectorToLightSource normalizeVector] dotWith:vertex.normal];
        vertex.luminescence.g += 1 * fattr * lightSource.color.g * [[vectorToLightSource normalizeVector] dotWith:vertex.normal];
        vertex.luminescence.b += 1 * fattr * lightSource.color.b * [[vectorToLightSource normalizeVector] dotWith:vertex.normal];

        vertex.luminescence = [vertex.luminescence normalize];
    }];

    [self.model.vertices enumerateObjectsUsingBlock:^(Vertex *vertex, NSUInteger idx, BOOL *stop) {
        vertex.luminescence = [vertex.luminescence normalize];

        vertex.color.r *= vertex.luminescence.r;
        vertex.color.g *= vertex.luminescence.g;
        vertex.color.b *= vertex.luminescence.b;
    }];
}

@end