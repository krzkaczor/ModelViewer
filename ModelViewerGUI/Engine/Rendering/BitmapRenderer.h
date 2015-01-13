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

- (void)renderTriangle:(Triangle *)triangle forCamera:(Camera*)camera andScene:(Scene*)scene andTransformation:(YCMatrix*)modelViewProjectionMatrix;

- (void)renderPoint:(DoublePoint *)v;

- (NSImage *)finishRendering;

- (Vector *)calculateBarycentricFor;

- (id)calculateBarycentricV1;
@end