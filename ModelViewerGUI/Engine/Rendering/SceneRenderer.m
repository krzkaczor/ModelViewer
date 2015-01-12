//
// Created by Krzysztof Kaczor on 1/9/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import "SceneRenderer.h"
#import "Scene.h"
#import "Camera.h"
#import "BitmapRenderer.h"
#import "SceneModel.h"
#import "Model.h"
#import "Projection.h"
#import "YCMatrix+Affine3D.h"
#import "LightSource.h"
#import "DebugService.h"
#import "Color.h"


@implementation SceneRenderer {

}
- (instancetype)init {
    self = [super init];
    if (self) {
        _renderer = [[BitmapRenderer alloc] initWithScreenSize:CGSizeMake(400, 400)];
    }

    return self;
}

- (NSImage *)renderScene:(Scene *)scene usingCamera:(Camera*)camera putAdditionalInfo:(BOOL)additionalInfo {
    [self.renderer startSceneRendering];
    [scene.sceneModels enumerateObjectsUsingBlock:^(SceneModel* sceneModel, NSUInteger idx, BOOL *stop) {
        YCMatrix *modelViewProjectionMatrix = [YCMatrix assembleFromRightToLeft:@[
                camera.viewportMatrix,
                camera.projection.projectionMatrix,
                camera.worldToViewMatrix,
                sceneModel.modelToWorldMatrix,
        ]];

//        NSMutableArray *transformedTriangles = [NSMutableArray array];
        [sceneModel.model.triangles enumerateObjectsUsingBlock:^(Triangle* triangle, NSUInteger idx, BOOL *stop) {
            [self.renderer renderTriangle:[[triangle luminate] applyTransformation:modelViewProjectionMatrix]];
        }];

//        [transformedTriangles sortUsingComparator:^NSComparisonResult(Triangle* t1, Triangle* t2) {
//            return [@(t2.z) compare:@(t1.z)];
//        }];

//        [transformedTriangles enumerateObjectsUsingBlock:^(Triangle* triangle, NSUInteger idx, BOOL *stop) {
//
//        }];
    }];

    if (additionalInfo) {
        YCMatrix *modelViewProjectionMatrix = [YCMatrix assembleFromRightToLeft:@[
                camera.viewportMatrix,
                camera.projection.projectionMatrix,
                camera.worldToViewMatrix
        ]];

        Vector* lightSourcePosition = [scene.lightSource.position applyTransformation:modelViewProjectionMatrix];
        DoublePoint* lightSourcePoint = [DoublePoint pointWithPos:lightSourcePosition color:scene.lightSource.color];
        camera.view.lightSourceDragPoint = lightSourcePoint.position;
        [self.renderer renderPoint: lightSourcePoint];

        Vector* cameraPosition = [scene.mainCamera.position applyTransformation:modelViewProjectionMatrix];
        DoublePoint* cameraPoint = [DoublePoint pointWithPos:cameraPosition color:Color.green];
        camera.view.cameraDragPoint = cameraPosition;
        [self.renderer renderPoint: cameraPoint];
    }


    return [self.renderer finishRendering];
}

@end