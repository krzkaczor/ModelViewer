//
// Created by Krzysztof Kaczor on 12/29/14.
//

#import <Foundation/Foundation.h>

@class YCMatrix;
@class Vector;


@interface Model : NSObject
@property (strong) NSArray* vertices;
@property (strong) NSArray* triangles;
@property (strong) Vector* pointInside;

- (instancetype)initWithVertices:(NSArray *)vertices triangles:(NSArray *)triangles pointInside:(Vector *)pointInside;

+ (instancetype)modelWithVertices:(NSArray *)vertices triangles:(NSArray *)triangles pointInside:(Vector *)pointInside;


- (void)calculateTriangleNormals;

- (void)calculateVerticlesNormals;
@end