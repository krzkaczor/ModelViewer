//
// Created by Krzysztof Kaczor on 1/6/15.
//

#import <Foundation/Foundation.h>

@class YCMatrix;

@protocol Transformable <NSObject>
- (id)applyTransformation:(YCMatrix *)transformation;
@end