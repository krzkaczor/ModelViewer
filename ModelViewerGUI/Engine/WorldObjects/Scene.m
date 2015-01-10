//
// Created by Krzysztof Kaczor on 12/29/14.
//

#import "Scene.h"
#import "YCMatrix.h"
#import "Camera.h"
#import "SceneModel.h"
#import "LightSource.h"
#import "Vector.h"


@implementation Scene
- (instancetype)initWithSceneModels:(NSMutableArray *)sceneModels {
    self = [super init];
    if (self) {
        self.sceneModels = sceneModels;
        self.origin = [Vector vectorWithX:0 y:0 z:0];
    }

    return self;
}

+ (instancetype)sceneWithSceneModels:(NSMutableArray *)sceneModels {
    return [[self alloc] initWithSceneModels:sceneModels];
}

- (void)addSceneModel:(SceneModel *)model {
    [self.sceneModels addObject:model];
}

+ (instancetype)emptyScene {
    return [self sceneWithSceneModels:[NSMutableArray array]];
}


@end