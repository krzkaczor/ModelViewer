//
// Created by Krzysztof Kaczor on 1/9/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TriangleRenderer : NSObject
- (NSImage*)renderTriangle:(void *)triangle onScreen:(CGSize)size;
@end