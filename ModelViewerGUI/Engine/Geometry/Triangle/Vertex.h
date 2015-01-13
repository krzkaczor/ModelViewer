//
// Created by Krzysztof Kaczor on 1/6/15.
//

#import <Foundation/Foundation.h>
#import "DoublePoint.h"

@class Vector;
@class Color;
@class Triangle;
@class YCMatrix;

@interface Vertex : NSObject <NSCopying, Transformable>

@property Vector* position;
@property (strong) Color* color;
@property (strong) Color* luminescence;
@property YCMatrix* normal;
@property(nonatomic) NSMutableArray *triangles;


@property(nonatomic, strong) YCMatrix *vectorToLightSource;

@property(nonatomic, strong) YCMatrix *mirroredVectorToCamera;

- (id)copyWithZone:(NSZone *)zone;
- (instancetype)initWithPosition:(Vector *)position color:(Color *)color;

+ (instancetype)vertexWithPosition:(Vector *)position color:(Color *)color;

- (void)connectedTo:(Triangle *)triangle;

- (void)calculateNormal;

- (Vertex *)luminate;

- (NSString *)description;

@end