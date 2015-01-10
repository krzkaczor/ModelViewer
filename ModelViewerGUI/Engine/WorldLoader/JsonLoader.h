//
// Created by Krzysztof Kaczor on 1/2/15.
//

#import <Foundation/Foundation.h>
#import "SceneModelLoader.h"
#import "LightSourceLoader.h"

@class SceneModel;

@interface JsonLoader : NSObject <SceneModelLoader, LightSourceLoader>
@end