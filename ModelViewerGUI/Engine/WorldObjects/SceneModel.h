//
// Created by Krzysztof Kaczor on 12/30/14.
//

#import <Foundation/Foundation.h>

@class Model;
@class YCMatrix;
@class LightSource;


@interface SceneModel : NSObject
@property (strong) Model* model;
@property (strong) YCMatrix* modelToWorldMatrix;

- (instancetype)initWithModel:(Model *)model modelToWorldMatrix:(YCMatrix *)modelToWorldMatrix;

+ (instancetype)modelOnSceneWithModel:(Model *)model modelToWorldMatrix:(YCMatrix *)modelToWorldMatrix;
@end