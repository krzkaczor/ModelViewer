//
// Created by Krzysztof Kaczor on 1/11/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import <YCMatrix/YCMatrix+Advanced.h>
#import "OrthographicCamera.h"
#import "YCMatrix+Affine3D.h"
#import "OrthographicProjection.h"
#import "Vector.h"

#define DEFAULT_ORTHOGRAPHIC_PROJECTION_SIZE 100

@implementation OrthographicCamera {

}
- (instancetype)initWithSize:(CGSize)screenSize lookAt:(CameraPosition)lookAt {
    id<Projection> projection = [OrthographicProjection projectionWithRight:DEFAULT_ORTHOGRAPHIC_PROJECTION_SIZE left:-DEFAULT_ORTHOGRAPHIC_PROJECTION_SIZE top:DEFAULT_ORTHOGRAPHIC_PROJECTION_SIZE bottom:-DEFAULT_ORTHOGRAPHIC_PROJECTION_SIZE far:1 near:10];
    self = [super initWithHeight:screenSize.height width:screenSize.width projection:projection];
    if (self) {
        self.lookAt = lookAt;

        switch(lookAt) {
            case front : break;
            case side : self.worldToViewMatrix = [YCMatrix rotateXWithAngle:M_PI / 2]; break;
            case top : self.worldToViewMatrix = [YCMatrix rotateYWithAngle:M_PI / 2]; break;
        }
    }
    return self;
}

+ (instancetype)initWithSize:(CGSize)size cameraWithLookAt:(CameraPosition)lookAt {
    return [[self alloc] initWithSize:size lookAt:lookAt];
}

- (Vector*) transform:(Vector*)inputVector fromClickedVector:(Vector*)clicked {
    YCMatrix *modelViewProjectionMatrix = [YCMatrix assembleFromRightToLeft:@[
            self.viewportMatrix,
            self.projection.projectionMatrix,
            self.worldToViewMatrix
    ]];
    YCMatrix* invertedMatrix = [modelViewProjectionMatrix pseudoInverse];

//    if (self.lookAt == oYZ) {
//        clicked. = Vector  clicked.x;
//    }
    //self.scene.lightSource.position = [Vector vectorWithX:self.scene.lightSource.position.x y:transformedVector.y z:transformedVector.z];

    Vector* transformedVector = [clicked applyTransformation:invertedMatrix];

    Vector* ret;
    switch(self.lookAt) {
        case front : ret = [Vector vectorWithX:transformedVector.x y:transformedVector.y z:inputVector.z]; break;
        case side : ret = [Vector vectorWithX:transformedVector.x y:inputVector.y z:transformedVector.z]; break;
        case top : ret = [Vector vectorWithX:inputVector.x y:transformedVector.y z:transformedVector.z]; break;
    }


    return ret;
}

@end