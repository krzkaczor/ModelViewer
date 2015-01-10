//
// Created by Krzysztof Kaczor on 12/28/14.
//

#import <Foundation/Foundation.h>
@protocol WorldObjectsLoader;
@class Scene;
@class LightSource;


@interface Engine : NSObject
@property (readonly) id renderer;
@property (readonly) id<WorldObjectsLoader> worldLoader;
@property (readonly) Scene* scene;


- (instancetype)initWithRenderer:(id)renderer modelLoader:(id <WorldObjectsLoader>)modelLoader;


- (void)loadModel:(NSString *)path;

- (void)loadLightConfig:(NSString *)path;

- (void)run;

- (NSImage *)generateFrame;
@end