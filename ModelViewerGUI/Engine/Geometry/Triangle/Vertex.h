//
// Created by Krzysztof Kaczor on 1/6/15.
//

#import <Foundation/Foundation.h>
#import "DoublePoint.h"

@class Vector;
@class Color;
@class Triangle;

@interface Vertex : NSObject <NSCopying, Transformable>

@property Vector* position;
@property Color* color;
@property Color* luminescence;
@property YCMatrix* normal;
@property(nonatomic) NSMutableArray *triangles;


- (id)copyWithZone:(NSZone *)zone;
- (instancetype)initWithPosition:(Vector *)position color:(Color *)color;

+ (instancetype)vertexWithPosition:(Vector *)position color:(Color *)color;

- (void)connectedTo:(Triangle *)triangle;

- (void)calculateNormal;

- (NSString *)description;

@end