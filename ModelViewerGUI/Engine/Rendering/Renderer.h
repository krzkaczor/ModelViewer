//
// Created by Krzysztof Kaczor on 1/9/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Scene;
@class Camera;

@protocol Renderer <NSObject>
@property (strong) Scene* scene;
@property (strong) Camera* camera;

- (NSImage*) renderScene:(Scene*) scene;
@end