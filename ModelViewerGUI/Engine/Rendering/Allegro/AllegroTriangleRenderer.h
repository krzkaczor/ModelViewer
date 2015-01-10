//
// Created by Krzysztof Kaczor on 1/3/15.
//

#import <Foundation/Foundation.h>

@class Triangle;

@protocol AllegroTriangleRenderer <NSObject>

- (void)renderTriangle:(Triangle*)triangle;

- (void)startRenderCycle;
@end