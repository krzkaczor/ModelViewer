//
// Created by Krzysztof Kaczor on 1/1/15.
//

#import <Foundation/Foundation.h>
#import "Renderer.h"

@class Scene;
@class Camera;
@protocol AllegroTriangleRenderer;

@interface AllegroRenderer : NSObject <Renderer>
@property id<AllegroTriangleRenderer> triangleRenderer;

@property Scene* scene;
@property Camera* camera;
@property NSMutableArray* helperCameras;

- (instancetype)initWithSize:(CGSize)size triangleRenderer:(id <AllegroTriangleRenderer>)triangleRenderer debug:(BOOL)debug;


@end