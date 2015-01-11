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
#import "BitmapRenderer.h"
#import "LightSource.h"
#import "Vector.h"
#import "LightSourceLoader.h"
#import "Model.h"
#import "Line.h"
#import "DoublePoint.h"
#import "SceneRenderer.h"
#import "Color.h"
#import "DebugService.h"
#import "BitmapRenderer.h"
#import "SceneRenderer.h"
#import "OrthographicProjection.h"
#import "YCMatrix+Advanced.h"
#import "InteractionImage.h"

@implementation Engine {

}

- (void)setTopImage:(InteractionImage *)topImage {
    _topImage = topImage;
    topImage.engine = self;
    topImage.assignedCamera = self.topCamera;
}

- (void)setSideImage:(InteractionImage *)sideImage {
    _sideImage = sideImage;
    sideImage.engine = self;
    sideImage.assignedCamera = self.sideCamera;
}

- (void)setFrontImage:(InteractionImage *)frontImage {
    _frontImage = frontImage;
    frontImage.engine = self;
    frontImage.assignedCamera = self.sideCamera;
}

- (instancetype)initWithSceneModelLoader:(id <SceneModelLoader>)sceneModelLoader lightSourceLoader:(id <LightSourceLoader>)lightSourceLoader {
    self = [super init];
    if (self) {
        _sceneModelLoader = sceneModelLoader;
        _lightSourceLoader = lightSourceLoader;
        _scene = [Scene emptyScene];
        _renderer = [[SceneRenderer alloc] init];

        [self setupCameras];
        _scene.mainCamera = self.mainCamera;
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
    NSLog(@"Succesfully loaded model");
    [sceneModel.model calculateTriangleNormals];
    [sceneModel.model calculateVerticlesNormals];
    NSLog(@"Succesfully calculated normals");

    [self.scene addSceneModel:sceneModel];
    [self.scene putLight];
    [self updateScreen];
}

-(void)loadLightConfig:(NSString*)path {
    self.scene.lightSource = [self.lightSourceLoader loadLightSourceFromFile:path];

    [self.scene putLight];
    [self updateScreen];
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

- (void)mouseDown:(Vector *)clickedPoint onViewShownBy:(Camera*)camera {
    YCMatrix *modelViewProjectionMatrix = [YCMatrix assembleFromRightToLeft:@[
            camera.viewportMatrix,
            camera.projection.projectionMatrix,
            camera.worldToViewMatrix
    ]];

    YCMatrix* invertedMatrix = [modelViewProjectionMatrix pseudoInverse];

    Vector* transformedVector = [clickedPoint applyTransformation:invertedMatrix];
    self.scene.lightSource.position = [Vector vectorWithX:self.scene.lightSource.position.x y:transformedVector.y z:transformedVector.z];
    [DebugService.instance.dynamicHelperPoints addObject:[DoublePoint pointWithPos:self.scene.lightSource.position color:[Color colorWithR:1 g:1 b:1]]];

    [self.scene putLight];
    [self updateScreen];
}

- (void)updateScreen {
    NSArray* frames = self.generateFrames;
    self.mainImage.image = frames[0];
    self.topImage.image = frames[1];
    self.frontImage.image = frames[2];
    self.sideImage.image = frames[3];
}
@end