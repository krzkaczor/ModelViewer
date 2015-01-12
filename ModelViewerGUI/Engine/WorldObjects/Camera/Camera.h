//
// Created by Krzysztof Kaczor on 12/29/14.
//

#import <Foundation/Foundation.h>
#import "InteractionImage.h"

@class Vector;
@class YCMatrix;
@class Scene;
@protocol Projection;

@interface Camera : NSObject

@property YCMatrix* worldToViewMatrix;
@property YCMatrix* viewportMatrix;
@property InteractionImage* view;

@property id<Projection> projection;
@property int width, height;

@property (nonatomic) Vector* position;
@property double tilt;
@property Vector* eyePosition;


- (instancetype)initWithHeight:(int)height width:(int)width projection:(id <Projection>)projection;

- (void)updateMatrix;

+ (instancetype)cameraWithHeight:(int)height width:(int)width projection:(id <Projection>)projection;


@end