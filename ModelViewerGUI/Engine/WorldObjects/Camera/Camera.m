//
// Created by Krzysztof Kaczor on 12/29/14.
//

#import "Camera.h"
#import "Vector.h"
#import "YCMatrix.h"
#import "Scene.h"
#import "SceneModel.h"
#import "Model.h"
#import "Triangle.h"
#import "Projection.h"
#import "YCMatrix+Affine3D.h"

@implementation Camera {

}
- (void)setPosition:(Vector *)position {
    YCMatrix* delta = [[position toMatrix] matrixBySubtracting: [_position toMatrix]];
    _eyePosition = [Vector vectorFromMatrix:[[_eyePosition toMatrix] matrixByAdding:delta]];
    _position = position;

}

- (instancetype)initWithHeight:(int)height width:(int)width projection:(id <Projection>)projection {
    self = [super init];
    if (self) {
        self.height = height;
        self.width = width;
        self.projection = projection;

        self.worldToViewMatrix = [YCMatrix identityOfRows:4 Columns:4];

        YCMatrix *offset = [YCMatrix translationX:width/2 Y:height/2 Z:0];
        YCMatrix *scale = [YCMatrix scaleX:width y:height z:1];
        self.viewportMatrix = [YCMatrix assembleFromRightToLeft:@[offset, scale]];

        self.tilt = 0;
    }
    return self;
}



- (void)updateMatrix {
    // 1step
    YCMatrix* translation  = [YCMatrix translationX:-self.position.x Y:-self.position.y Z:-self.position.z];
    //2 step
    Vector* et = [self.eyePosition applyTransformation:translation];
    double angle = M_PI - atan2(et.x, et.z);
    YCMatrix* rot1  = [YCMatrix rotateYWithAngle:angle];
    //3step
    YCMatrix* currentTransform = [YCMatrix assembleFromRightToLeft: @[rot1, translation]];
    Vector* et2 = [self.eyePosition applyTransformation:currentTransform];
    double angle2 = -M_PI/2 - atan2(et2.z, et2.y);
    YCMatrix* rot2  = [YCMatrix rotateXWithAngle:angle2];
    double angle3 = self.tilt;
    YCMatrix* rot3 = [YCMatrix rotateZWithAngle:angle3];
    currentTransform = [YCMatrix assembleFromRightToLeft: @[rot3, rot2, rot1, translation]];

    self.worldToViewMatrix = currentTransform;
}

+ (instancetype)cameraWithHeight:(int)height width:(int)width projection:(id <Projection>)projection {
    return [[self alloc] initWithHeight:height width:width projection:projection];
}


@end