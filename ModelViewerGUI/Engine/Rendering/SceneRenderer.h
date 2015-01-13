//
// Created by Krzysztof Kaczor on 1/9/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScreenRenderer.h"

@class Scene;
@class Camera;
@class BitmapRenderer;

@interface SceneRenderer : NSObject
@property(nonatomic, strong) BitmapRenderer* renderer;

- (NSImage *)renderScene:(Scene *)scene usingCamera:(Camera *)camera putAdditionalInfo:(BOOL)additionalInfo;
@end