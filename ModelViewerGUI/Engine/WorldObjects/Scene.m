//
// Created by Krzysztof Kaczor on 12/29/14.
//

#import "Scene.h"
#import "YCMatrix.h"
#import "Camera.h"
#import "SceneModel.h"
#import "LightSource.h"
#import "Vector.h"
#import "Model.h"
#import "Triangle.h"
#import "Color.h"
#import "DoublePoint.h"


@implementation Scene
- (instancetype)initWithSceneModels:(NSMutableArray *)sceneModels {
    self = [super init];
    if (self) {
        self.sceneModels = sceneModels;
        self.origin = [Vector vectorWithX:0 y:0 z:0];
    }

    return self;
}

+ (instancetype)sceneWithSceneModels:(NSMutableArray *)sceneModels {
    return [[self alloc] initWithSceneModels:sceneModels];
}

- (void)addSceneModel:(SceneModel *)model {
    [self.sceneModels addObject:model];
}

+ (instancetype)emptyScene {
    return [self sceneWithSceneModels:[NSMutableArray array]];
}

- (void)clearLight {
    [self.sceneModels enumerateObjectsUsingBlock:^(SceneModel* sceneModel, NSUInteger idx, BOOL *stop) {
        [sceneModel.model.triangles enumerateObjectsUsingBlock:^(Triangle* t, NSUInteger idx, BOOL *stop) {
            //refactor
            t.v1.luminescence = [Color black];
            t.v2.luminescence = [Color black];
            t.v3.luminescence = [Color black];
        }];
    }];
}

- (void)putLight {
    if (self.lightSource == nil) {
        return;
    }

    [self clearLight];
    [self.sceneModels enumerateObjectsUsingBlock:^(SceneModel* sceneModel, NSUInteger idx, BOOL *stop) {
        [self.lightSource lightModel:sceneModel forCamera:self.mainCamera];
    }];
}
@end