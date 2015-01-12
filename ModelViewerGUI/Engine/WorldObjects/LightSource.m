//
// Created by Krzysztof Kaczor on 1/4/15.
//

#import "LightSource.h"
#import "DoublePoint.h"
#import "Color.h"
#import "Vector.h"
#import "SceneModel.h"
#import "Vertex.h"
#import "Model.h"
#import "YCMatrix+Affine3D.h"
#import "Camera.h"


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


- (void)lightModel:(SceneModel *)sceneModel forCamera:(Camera*)camera {
    [sceneModel.model.vertices enumerateObjectsUsingBlock:^(Vertex* vertex, NSUInteger idx, BOOL *stop) {
        [self lightVertex:vertex forCamera:camera];
    }];
}

- (void) lightVertex:(Vertex *)vertex forCamera:(Camera*)camera {
    YCMatrix *point = [vertex.position toMatrix];

    //vector to light
    YCMatrix *vectorToLightSource = [[self.position toMatrix] matrixBySubtracting:point];
    YCMatrix *vectorToLightSourceNormalized = [vectorToLightSource normalizeVector];
    double r = [vectorToLightSource vectorLength];
    double fattr = 1/(self.c2*r*r + self.c1 * r + self.c0);

    //diffuse
    double dot = fmax([vertex.normal dotWith:vectorToLightSourceNormalized], 0);
    //specular
    YCMatrix* vectorToCamera = [[[camera.position toMatrix] matrixBySubtracting:point] normalizeVector];
    YCMatrix* mirroredVectorToCamera = [[[vertex.normal matrixByMultiplyingWithScalar:2 * fmax([vertex.normal dotWith:vectorToCamera],0)] matrixBySubtracting:vectorToCamera] normalizeVector];
    double v = fmax([vectorToLightSourceNormalized dotWith:mirroredVectorToCamera], 0);
    double s = fmax(pow(v, 100), 0);

    vertex.luminescence.r += 1 * fattr * self.color.r * (dot + s);
    vertex.luminescence.g += 1 * fattr * self.color.g * (dot + s);
    vertex.luminescence.b += 1 * fattr * self.color.b * (dot + s);

    vertex.luminescence = [vertex.luminescence normalize];
}


@end