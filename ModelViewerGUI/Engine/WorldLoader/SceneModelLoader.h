//
// Created by Krzysztof Kaczor on 1/2/15.
//

#import <Foundation/Foundation.h>

@class SceneModel;
@class LightSource;

@protocol SceneModelLoader <NSObject>
- (SceneModel* )loadModelFromFile:(NSString*)path;
@end