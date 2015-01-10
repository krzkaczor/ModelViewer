//
// Created by Krzysztof Kaczor on 12/29/14.
//

#import <Foundation/Foundation.h>

@class Camera;
@class SceneModel;
@class LightSource;
@class Vector;


@interface Scene : NSObject
@property (nonatomic) NSMutableArray* sceneModels;
@property (nonatomic) LightSource* lightSource;


@property(nonatomic, strong) Vector* origin;

- (instancetype)initWithSceneModels:(NSMutableArray *)sceneModels;

+ (instancetype)sceneWithSceneModels:(NSMutableArray *)sceneModels;

+ (instancetype)emptyScene;


- (void)addSceneModel:(SceneModel *)model;
@end