//
// Created by Krzysztof Kaczor on 1/9/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Scene;
@class Camera;
@class Triangle;
@class DoublePoint;

@protocol ScreenRenderer <NSObject>
@property (strong) Scene* scene;
@property (strong) Camera* camera;

- (void)startSceneRendering;

- (void)renderTriangle:(Triangle *)triangle;
- (void)renderPoint:(DoublePoint *)v;

- (id) finishRendering;
@end