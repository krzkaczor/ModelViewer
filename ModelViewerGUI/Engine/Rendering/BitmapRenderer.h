//
// Created by Krzysztof Kaczor on 1/9/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Triangle.h"
#import "ScreenRenderer.h"


@interface BitmapRenderer : NSObject <ScreenRenderer>
- (instancetype)initWithScreenSize:(CGSize)aSize;

+ (instancetype)rendererWithScreenSize:(CGSize)aSize;

- (void)startSceneRendering;

- (void)renderTriangle:(Triangle *)triangle;

- (void)renderPoint:(DoublePoint *)v;

- (NSImage *)finishRendering;
@end