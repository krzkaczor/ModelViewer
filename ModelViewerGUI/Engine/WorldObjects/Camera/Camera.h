//
// Created by Krzysztof Kaczor on 12/29/14.
//

#import <Foundation/Foundation.h>

@class Vector;
@class YCMatrix;
@class Scene;
@protocol Projection;

@interface Camera : NSObject

@property YCMatrix* worldToViewMatrix;
@property YCMatrix* viewportMatrix;


@property id<Projection> projection;
@property int width, height;

- (instancetype)initWithHeight:(int)height width:(int)width projection:(id <Projection>)projection;

+ (instancetype)cameraWithHeight:(int)height width:(int)width projection:(id <Projection>)projection;


@end