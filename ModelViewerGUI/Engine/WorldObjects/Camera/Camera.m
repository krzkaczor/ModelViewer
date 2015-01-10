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
    }

    return self;
}

+ (instancetype)cameraWithHeight:(int)height width:(int)width projection:(id <Projection>)projection {
    return [[self alloc] initWithHeight:height width:width projection:projection];
}


@end