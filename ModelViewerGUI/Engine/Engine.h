//
// Created by Krzysztof Kaczor on 12/28/14.
//

#import <Foundation/Foundation.h>
@protocol SceneModelLoader;
@class Scene;
@class LightSource;
@protocol LightSourceLoader;
@class TriangleRenderer;
@class SceneRenderer;


@interface Engine : NSObject
@property (readonly) id<SceneModelLoader> sceneModelLoader;
@property (readonly) id<LightSourceLoader> lightSourceLoader;
@property (readonly) Scene* scene;
@property (readonly) SceneRenderer* renderer;
@property(nonatomic, strong) NSMutableArray *helperCameras;

- (instancetype)initWithSceneModelLoader:(id <SceneModelLoader>)sceneModelLoader lightSourceLoader:(id <LightSourceLoader>)lightSourceLoader;

+ (instancetype)engineWithSceneModelLoader:(id <SceneModelLoader>)sceneModelLoader lightSourceLoader:(id <LightSourceLoader>)lightSourceLoader;


- (void)loadModel:(NSString *)path;

- (void)loadLightConfig:(NSString *)path;

- (void)run;

- (NSArray *)generateFrames;
@end