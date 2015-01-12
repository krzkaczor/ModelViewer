//
// Created by Krzysztof Kaczor on 12/28/14.
//

#import <Foundation/Foundation.h>
#import "OrthographicCamera.h"
@protocol SceneModelLoader;
@class Scene;
@class LightSource;
@protocol LightSourceLoader;
@class BitmapRenderer;
@class SceneRenderer;
@class Camera;
@class Vector;


@class NSImageView;
@class InteractionImage;
@class MasterViewController;

@interface Engine : NSObject
@property (readonly) id<SceneModelLoader> sceneModelLoader;
@property (readonly) id<LightSourceLoader> lightSourceLoader;
@property (readonly) Scene* scene;
@property (readonly) SceneRenderer* renderer;

@property(nonatomic, strong) Camera *mainCamera;
@property(nonatomic, strong) OrthographicCamera *frontCamera;
@property(nonatomic, strong) OrthographicCamera *topCamera;
@property(nonatomic, strong) OrthographicCamera *sideCamera;

@property(nonatomic, weak) NSImageView*  mainImage;
@property(nonatomic, weak) InteractionImage*  frontImage;
@property(nonatomic, weak) InteractionImage*  topImage;
@property(nonatomic, weak) InteractionImage*  sideImage;

@property(nonatomic, strong) MasterViewController *vc;

- (instancetype)initWithSceneModelLoader:(id <SceneModelLoader>)sceneModelLoader lightSourceLoader:(id <LightSourceLoader>)lightSourceLoader;
+ (instancetype)engineWithSceneModelLoader:(id <SceneModelLoader>)sceneModelLoader lightSourceLoader:(id <LightSourceLoader>)lightSourceLoader;


- (void)loadModel:(NSString *)path;
- (void)loadLightConfig:(NSString *)path;


- (void)lightMovedTo:(Vector *)clickedPoint onViewShownBy:(OrthographicCamera *)camera;

- (void)cameraMovedTo:(Vector *)clickedPoint onViewShownBy:(OrthographicCamera *)camera;

- (void)changeOrthographicCamerasZoomTo:(int)value;

- (void)mainCameraTiltChangedTo:(double)angle;
@end