//
// Created by Krzysztof Kaczor on 12/28/14.
//

#include "YCMatrix/YCMatrix.h"

#import "Engine.h"
#import "Scene.h"
#import "SceneModelLoader.h"
#import "SceneModel.h"
#import "Camera.h"
#import "YCMatrix+Affine3D.h"
#import "PerspectiveProjection.h"
#import "TriangleRenderer.h"
#import "LightSource.h"
#import "Vector.h"
#import "LightSourceLoader.h"
#import "Model.h"
#import "Line.h"
#import "DoublePoint.h"
#import "SceneRenderer.h"
#import "Color.h"
#import "DebugService.h"
#import "TriangleRenderer.h"
#import "SceneRenderer.h"
#import "OrthographicProjection.h"

@implementation Engine {

}

- (instancetype)initWithSceneModelLoader:(id <SceneModelLoader>)sceneModelLoader lightSourceLoader:(id <LightSourceLoader>)lightSourceLoader {
    self = [super init];
    if (self) {
        _sceneModelLoader = sceneModelLoader;
        _lightSourceLoader = lightSourceLoader;
        _scene = [Scene emptyScene];
        _renderer = [[SceneRenderer alloc] init];

        [self setupCameras];
    }

    return self;
}

+ (instancetype)engineWithSceneModelLoader:(id <SceneModelLoader>)sceneModelLoader lightSourceLoader:(id <LightSourceLoader>)lightSourceLoader {
    return [[self alloc] initWithSceneModelLoader:sceneModelLoader lightSourceLoader:lightSourceLoader];
}


- (void)setupCameras {
    double size = 100;
    id<Projection> projection = [OrthographicProjection projectionWithRight:size left:-size top:size bottom:-size far:1 near:10];

    self.frontCamera = [Camera cameraWithHeight:400 width:400 projection:projection];

    self.topCamera = [Camera cameraWithHeight:400 width:400 projection:projection];
    self.topCamera.worldToViewMatrix = [YCMatrix rotateXWithAngle:M_PI / 2];

    self.sideCamera = [Camera cameraWithHeight:400 width:400 projection:projection];
    self.sideCamera.worldToViewMatrix = [YCMatrix rotateYWithAngle:M_PI / 2];

    id<Projection> perspectiveProjection = [PerspectiveProjection projectionWithN:1 f:7 fov:M_PI / 2];
    self.mainCamera = [Camera cameraWithHeight:400 width:400 projection:perspectiveProjection];
    self.mainCamera.position = [Vector vectorWithX:0 y:0 z:-45];
    self.mainCamera.eyePosition = [Vector vectorWithX:0 y:0 z:-50];
    //camera.up = [Vector vectorWithX:0.9 y:1 z:0];
    [self.mainCamera updateMatrix];
};


- (NSArray*)generateFrames {

    [DebugService.instance.dynamicHelperPoints addObject:[DoublePoint pointWithPos:self.mainCamera.position color:[Color colorWithR:0 g:1 b:0]]];

    NSImage* mainCameraView = [self.renderer renderScene:self.scene usingCamera:self.mainCamera putAdditionalInfo:NO];
    NSImage* frontCameraView = [self.renderer renderScene:self.scene usingCamera:self.frontCamera putAdditionalInfo:YES] ;
    NSImage* topCameraView = [self.renderer renderScene:self.scene usingCamera:self.topCamera putAdditionalInfo:YES];
    NSImage* sideCameraView = [self.renderer renderScene:self.scene usingCamera:self.sideCamera putAdditionalInfo:YES];

    return @[mainCameraView, topCameraView, frontCameraView, sideCameraView];
}

- (void)loadModel:(NSString *)path {
    SceneModel *sceneModel = [self.sceneModelLoader loadModelFromFile:path];
    [sceneModel.model calculateTriangleNormals];
    [sceneModel.model calculateVerticlesNormals];


    [self.scene addSceneModel:sceneModel];
}

-(void)loadLightConfig:(NSString*)path {
    self.scene.lightSource = [self.lightSourceLoader loadLightSourceFromFile:path];

    [self updateLight];
}

- (void)updateLight {
    [self.scene.sceneModels enumerateObjectsUsingBlock:^(SceneModel* sceneModel, NSUInteger idx, BOOL *stop) {
        [self.scene.lightSource lightModel:sceneModel forCamera:self.mainCamera];
        [self putConstantDebugData];
    }];

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

//        [self putDynamicDebugData];
        //[self.renderer render];

        [DebugService.instance clearDynamicData];

        usleep(10000);
    }
#pragma clang diagnostic pop
    getchar();
}

//- (void)putDynamicDebugData {
//    DoublePoint *cameraPosition = [DoublePoint pointWithPos:self.camera color:[Color colorWithR:0 g:1 b:0]];
//    [DebugService.instance.dynamicHelperPoints addObject:cameraPosition];
//}

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