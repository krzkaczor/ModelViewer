//
// Created by Krzysztof Kaczor on 12/28/14.
//

#import <Foundation/Foundation.h>
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

@interface Engine : NSObject
@property (readonly) id<SceneModelLoader> sceneModelLoader;
@property (readonly) id<LightSourceLoader> lightSourceLoader;
@property (readonly) Scene* scene;
@property (readonly) SceneRenderer* renderer;

@property(nonatomic, strong) Camera *mainCamera;
@property(nonatomic, strong) Camera *frontCamera;
@property(nonatomic, strong) Camera *topCamera;
@property(nonatomic, strong) Camera *sideCamera;

@property(nonatomic, weak) NSImageView*  mainImage;
@property(nonatomic, weak) InteractionImage*  frontImage;
@property(nonatomic, weak) InteractionImage*  topImage;
@property(nonatomic, weak) InteractionImage*  sideImage;

- (instancetype)initWithSceneModelLoader:(id <SceneModelLoader>)sceneModelLoader lightSourceLoader:(id <LightSourceLoader>)lightSourceLoader;
+ (instancetype)engineWithSceneModelLoader:(id <SceneModelLoader>)sceneModelLoader lightSourceLoader:(id <LightSourceLoader>)lightSourceLoader;


- (void)loadModel:(NSString *)path;
- (void)loadLightConfig:(NSString *)path;


- (void)mouseDown:(Vector *)clickedPoint onViewShownBy:(Camera *)camera;

- (NSArray *)generateFrames;
@end