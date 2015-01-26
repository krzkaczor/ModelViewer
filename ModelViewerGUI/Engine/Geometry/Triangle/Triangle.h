//
// Created by Krzysztof Kaczor on 12/29/14.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "Transformable.h"
#import "Vector.h"
#import "Vertex.h"

@class YCMatrix;
@class DoublePoint;



@interface Triangle : NSObject <Transformable, NSCopying>
@property Vertex *v1;
@property Vertex *v2;
@property Vertex *v3;
@property YCMatrix * normal; //not homogenous vector

@property(nonatomic, readonly) double z;

@property(nonatomic) double lambda1;

@property(nonatomic) double lambda2;

@property(nonatomic) double lambda3;

- (instancetype)initWithP1:(Vertex *)p1 p2:(Vertex *)p2 p3:(Vertex *)p3;

+ (instancetype)triangleWithP1:(Vertex *)p1 p2:(Vertex *)p2 p3:(Vertex *)p3;

- (void)calculateNormalKnowingPointInside:(Vector *)pointInside;

- (Triangle *)luminate;

- (NSArray*)split;

//- (void)setupBarycentricCoordinateSystem;

//- (YCMatrix *)getNormalVectorOnX:(double)x y:(double)y;

- (Color *)getColorVectorOnX:(double)x y:(double)y;

- (double *)findBarycentricX:(double)px y:(double)py;

- (Color *)findColorByBarLambdas:(double *)lambdas;

- (id)copyWithZone:(NSZone *)zone;

- (Color *)findColorByBarLambdasL1:(double)l1 L2:(double)l2 L3:(double)l3;

- (YCMatrix *)findNormByBarLambdasL1:(double)l1 L2:(double)l2 L3:(double)l3;
@end