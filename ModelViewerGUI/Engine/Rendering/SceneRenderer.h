//
// Created by Krzysztof Kaczor on 1/9/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Renderer.h"

@class Scene;
@class Camera;
@class TriangleRenderer;


@interface SceneRenderer : NSObject
@property(nonatomic, strong) TriangleRenderer* triangleRenderer;

- (NSImage *)renderScene:(Scene *)scene usingCamera:(Camera *)camera putAdditionalInfo:(BOOL)additionalInfo;
@end