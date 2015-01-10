//
// Created by Krzysztof Kaczor on 1/1/15.
//

#import <Foundation/Foundation.h>

@class Scene;
@class Camera;

@protocol Renderer <NSObject>

@property (strong) Scene* scene;
@property (strong) Camera* camera;

- (void)render;

@optional
- (instancetype)initWithScene:(Scene*)scene camera:(Camera*)camera;
@end