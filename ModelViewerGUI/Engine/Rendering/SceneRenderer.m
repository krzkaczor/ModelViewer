//
// Created by Krzysztof Kaczor on 1/9/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import "SceneRenderer.h"
#import "Scene.h"
#import "Camera.h"
#import "TriangleRenderer.h"
#import "SceneModel.h"
#import "Model.h"
#import "Projection.h"
#import "YCMatrix+Affine3D.h"
#import "LightSource.h"
#import "DebugService.h"


@implementation SceneRenderer {

}
- (instancetype)init {
    self = [super init];
    if (self) {
        _triangleRenderer = [[TriangleRenderer alloc] initWithScreenSize:CGSizeMake(400, 400)];
    }

    return self;
}


- (NSImage *)renderScene:(Scene *)scene usingCamera:(Camera*)camera putAdditionalInfo:(BOOL)additionalInfo {
    NSImage* image;

    [self.triangleRenderer startSceneRendering];
    [scene.sceneModels enumerateObjectsUsingBlock:^(SceneModel* sceneModel, NSUInteger idx, BOOL *stop) {
        [sceneModel.model.triangles enumerateObjectsUsingBlock:^(Triangle* triangle, NSUInteger idx, BOOL *stop) {
            YCMatrix *modelViewProjectionMatrix = [YCMatrix assembleFromRightToLeft:@[
                    camera.viewportMatrix,
                    camera.projection.projectionMatrix,
                    camera.worldToViewMatrix,
                    sceneModel.modelToWorldMatrix,
            ]];

            [self.triangleRenderer renderTriangle:[triangle applyTransformation:modelViewProjectionMatrix]];
        }];
    }];

    if (additionalInfo) {
        YCMatrix *modelViewProjectionMatrix = [YCMatrix assembleFromRightToLeft:@[
                camera.viewportMatrix,
                camera.projection.projectionMatrix,
                camera.worldToViewMatrix
        ]];

        [[[DebugService instance] getAllPoints] enumerateObjectsUsingBlock:^(DoublePoint *point, NSUInteger idx, BOOL *stop) {
            [self.triangleRenderer renderPoint:[point applyTransformation:modelViewProjectionMatrix]];
        }];
    }


    return [self.triangleRenderer finishRendering];
}

@end