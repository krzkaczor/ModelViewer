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

@end