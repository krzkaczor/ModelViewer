//
// Created by Krzysztof Kaczor on 12/28/14.
//

#include "YCMatrix/YCMatrix.h"

#import "Engine.h"
#import "Scene.h"
#import "WorldObjectsLoader.h"
#import "SceneModel.h"
#import "Camera.h"
#import "YCMatrix+Affine3D.h"
#import "PerspectiveProjection.h"
#import "LightSource.h"
#import "Vector.h"
#import "Model.h"
#import "Line.h"
#import "DoublePoint.h"
#import "Color.h"
#import "DebugService.h"
#import "TriangleRenderer.h"

@implementation Engine {

}

- (instancetype)initWithRenderer:(id)renderer modelLoader:(id <WorldObjectsLoader>)modelLoader {
    self = [super init];
    if (self) {
        _renderer = renderer;
        _worldLoader = modelLoader;

        _scene = [Scene emptyScene];

        //self.renderer.scene = _scene;
    }

    return self;
}


- (NSImage *)generateFrame {
//    id<Projection> projection = [PerspectiveProjection projectionWithN:1 f:7 fov:M_PI / 2];
//    Camera *camera = [Camera cameraWithHeight:640 width:480 projection:projection];
//    YCMatrix *trans = [Matrix translationX:0 Y:0 Z:10];
//    camera.worldToViewMatrix = [YCMatrix assembleFromRightToLeft:@[
//            trans
//    ]];
//    __block NSImage* image;
//
//    TriangleRenderer* renderer = [[TriangleRenderer alloc]init];
//    [renderer startSceneRenderingOnScreen:CGSizeMake(400, 400)];
//    [self.scene.sceneModels enumerateObjectsUsingBlock:^(SceneModel* sceneModel, NSUInteger idx, BOOL *stop) {
//        [sceneModel.model.triangles enumerateObjectsUsingBlock:^(Triangle* triangle, NSUInteger idx, BOOL *stop) {
//            YCMatrix *modelViewProjectionMatrix = [YCMatrix assembleFromRightToLeft:@[
//                    camera.viewportMatrix,
//                    camera.projection.projectionMatrix,
//                    camera.worldToViewMatrix,
//                    sceneModel.modelToWorldMatrix,
//            ]];
//
//            [renderer renderTriangle:[triangle applyTransformation:modelViewProjectionMatrix]];
//        }];
//    }];

    TriangleRenderer* renderer = [[TriangleRenderer alloc]init];
    [renderer startSceneRenderingOnScreen:CGSizeMake(400, 400)];

    Vector *v1 = [Vector vectorWithX:200 y:100 z:0];
    Vector *v2 = [Vector vectorWithX:100 y:270 z:0];
    Vector *v3 = [Vector vectorWithX:300 y:370 z:0];

    Vertex *p1 = [Vertex vertexWithPosition:v1 color:[Color colorWithR:0.7 g:0 b:0]];
    Vertex *p2 = [Vertex vertexWithPosition:v2 color:[Color colorWithR:0.7 g:0 b:0]];
    Vertex *p3 = [Vertex vertexWithPosition:v3 color:Color.black];

    [renderer renderTriangle:[Triangle triangleWithP1:p2 p2:p1 p3:p3]];

    return [renderer finishRendering];
}

- (void)loadModel:(NSString *)path {
    SceneModel *sceneModel = [self.worldLoader loadModelFromFile:path];
    [sceneModel.model calculateTriangleNormals];
    [sceneModel.model calculateVerticlesNormals];


    [self.scene addSceneModel:sceneModel];
}

-(void)loadLightConfig:(NSString*)path {
    self.scene.lightSource = [self.worldLoader loadLightSourceFromFile:path];
}

- (void)run {
    id<Projection> projection = [PerspectiveProjection projectionWithN:1 f:7 fov:M_PI / 2];
    Camera *camera = [Camera cameraWithHeight:640 width:480 projection:projection];
    //self.renderer.camera = camera;

//    [self.scene.sceneModels[0] lightUsingLightSource:self.scene.lightSource]; //refactor!

    [self putConstantDebugData];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmissing-noreturn"
    int i = 0;
    while (true) {
        YCMatrix *trans = [Matrix translationX:0 Y:0 Z:6];
        YCMatrix *trans2 = [Matrix translationX:-1 Y:0 Z:0];
        YCMatrix *rot = [Matrix rotateXWithAngle:M_PI / 16];
        YCMatrix *rot2 = [Matrix rotateYWithAngle:M_PI / 360 * i++];
        YCMatrix *rot3 = [Matrix rotateYWithAngle:M_PI / 2 ];
        //YCMatrix *scal = [Matrix scaleX:1 y:-1 z:-1];
        camera.worldToViewMatrix = [YCMatrix assembleFromRightToLeft:@[
                trans,
                //rot,
//                rot2,
                //scal
                //rot3,
//                trans2,
        ]];

        [self putDynamicDebugData];
        //[self.renderer render];

        [DebugService.instance clearDynamicData];

        usleep(10000);
    }
#pragma clang diagnostic pop
    getchar();
}

- (void)putDynamicDebugData {
//    DoublePoint *cameraPosition = [DoublePoint pointWithPos:[self.scene.origin applyTransformation:[self.renderer.camera.worldToViewMatrix pseudoInverse]] color:[Color colorWithR:0 g:1 b:0]];
//    [DebugService.instance.dynamicHelperPoints addObject:cameraPosition];
}

- (void)putConstantDebugData {
    DoublePoint *origin = [DoublePoint pointWithPos:[Vector vectorWithX:0 y:0 z:0] color:[Color colorWithR:1 g:0 b:0]];
    DoublePoint *lightSourcePosition = [DoublePoint pointWithPos:self.scene.lightSource.position color:self.scene.lightSource.color];

    Line *versorX = [Line lineWithA:origin.position b:[Vector vectorWithX:1 y:0 z:0] color:[Color colorWithR:1 g:0 b:0]];
    Line *versorY = [Line lineWithA:origin.position b:[Vector vectorWithX:0 y:1 z:0] color:[Color colorWithR:0 g:1 b:0]];
    Line *versorZ = [Line lineWithA:origin.position b:[Vector vectorWithX:0 y:0 z:1] color:[Color colorWithR:0 g:0 b:1]];

    [DebugService.instance.constantPoints addObjectsFromArray: [@[origin] mutableCopy]];
    [DebugService.instance.constantHelperPoints addObjectsFromArray:[@[lightSourcePosition] mutableCopy]];
    [DebugService.instance.constantLines addObjectsFromArray: [@[versorX, versorY, versorZ] mutableCopy]];
}
@end