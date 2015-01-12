//
// Created by Krzysztof Kaczor on 1/11/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Camera.h"

@class Vector;

typedef enum CameraPosition : NSUInteger {
    front,
    top,
    side
} CameraPosition;

@interface OrthographicCamera : Camera
@property CameraPosition lookAt;

- (instancetype)initWithSize:(CGSize)size lookAt:(CameraPosition)lookAt;

- (Vector *)transform:(Vector *)inputVector fromClickedVector:(Vector *)clicked;

+ (instancetype)initWithSize:(CGSize)size cameraWithLookAt:(CameraPosition)lookAt;

@end