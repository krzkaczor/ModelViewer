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
#import "LightSourceLoader.h"
#import "Model.h"
#import "Line.h"
#import "SceneRenderer.h"
#import "Color.h"
#import "DebugService.h"
#import "OrthographicProjection.h"
#import "MasterViewController.h"

@implementation Engine {
    CGSize screenSize;
}

- (void)setTopImage:(InteractionImage *)topImage {
    _topImage = topImage;
    topImage.engine = self;
    topImage.assignedCamera = self.topCamera;
    self.topCamera.view = topImage;
}

- (void)setSideImage:(InteractionImage *)sideImage {
    _sideImage = sideImage;
    sideImage.engine = self;
    sideImage.assignedCamera = self.sideCamera;
    self.sideCamera.view = sideImage;
}

- (void)setFrontImage:(InteractionImage *)frontImage {
    _frontImage = frontImage;
    frontImage.engine = self;
    frontImage.assignedCamera = self.frontCamera;
    self.frontCamera.view = frontImage;
}

- (instancetype)initWithSceneModelLoader:(id <SceneModelLoader>)sceneModelLoader lightSourceLoader:(id <LightSourceLoader>)lightSourceLoader {
    self = [super init];
    if (self) {
        screenSize = CGSizeMake(400, 400);
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
    self.frontCamera = [OrthographicCamera initWithSize:screenSize cameraWithLookAt:front];
    self.topCamera = [OrthographicCamera initWithSize:screenSize cameraWithLookAt:side];;
    self.sideCamera = [OrthographicCamera initWithSize:screenSize cameraWithLookAt:top];

    id<Projection> perspectiveProjection = [PerspectiveProjection projectionWithN:1 f:7 fov:M_PI / 2];
    self.mainCamera = [Camera cameraWithHeight:400 width:400 projection:perspectiveProjection];
    self.mainCamera.position = [Vector vectorWithX:0 y:0 z:-200];
    self.mainCamera.eyePosition = [Vector vectorWithX:0 y:0 z:-250];
    [self.mainCamera updateMatrix];
};

- (void)loadModel:(NSString *)path {
    SceneModel *sceneModel = [self.sceneModelLoader loadModelFromFile:path];
    NSLog(@"Succesfully loaded model");
    [sceneModel.model calculateTriangleNormals];
    [sceneModel.model calculateVerticlesNormals];
    NSLog(@"Succesfully calculated normals");

    [self.scene addSceneModel:sceneModel];
    [self.scene putLight];
    [self updateScreen];

    [self.vc updateModelInfo:(int) sceneModel.model.vertices.count and:(int) sceneModel.model.triangles.count];
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

- (void)lightMovedTo:(Vector *)clickedPoint onViewShownBy:(OrthographicCamera *)camera {
    self.scene.lightSource.position = [camera transform:self.scene.lightSource.position fromClickedVector:clickedPoint];

    [self.scene putLight];
    [self updateScreen];
}

- (void)cameraMovedTo:(Vector *)clickedPoint onViewShownBy:(OrthographicCamera *)camera {
    self.mainCamera.position = [[camera transform:self.mainCamera.position fromClickedVector:clickedPoint] negate];
    [self.mainCamera updateMatrix];

    [self.scene putLight];
    [self updateScreen];
}


- (void)eyeMovedTo:(Vector *)clickedPoint onViewShownBy:(OrthographicCamera *)camera {
    self.mainCamera.eyePosition = [[camera transform:self.mainCamera.eyePosition fromClickedVector:clickedPoint] negate];
    [self.mainCamera updateMatrix];

    [self.scene putLight];
    [self updateScreen];
}

- (void)updateScreen {
    [self updateMainCameraScreen];
    [self updateHelperCameraScreens];
}

-(void)updateMainCameraScreen {
    self.mainImage.image = [self.renderer renderScene:self.scene usingCamera:self.mainCamera putAdditionalInfo:NO];
}

-(void)updateHelperCameraScreens {
    self.frontImage.image = [self.renderer renderScene:self.scene usingCamera:self.frontCamera putAdditionalInfo:YES] ;
    self.topImage.image = [self.renderer renderScene:self.scene usingCamera:self.topCamera putAdditionalInfo:YES];
    self.sideImage.image = [self.renderer renderScene:self.scene usingCamera:self.sideCamera putAdditionalInfo:YES];
}

- (void)changeOrthographicCamerasZoomTo:(int)zoom {
    self.frontCamera.projection = [OrthographicProjection projectionWithSize:zoom];
    self.topCamera.projection = [OrthographicProjection projectionWithSize:zoom];
    self.sideCamera.projection = [OrthographicProjection projectionWithSize:zoom];
    [self updateHelperCameraScreens];
}

- (void)mainCameraTiltChangedTo:(double)angle {
    self.mainCamera.tilt = angle;
    [self.mainCamera updateMatrix];
    [self updateMainCameraScreen];
}
@end