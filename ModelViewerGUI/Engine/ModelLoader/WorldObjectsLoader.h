//
// Created by Krzysztof Kaczor on 1/2/15.
//

#import <Foundation/Foundation.h>

@class SceneModel;
@class LightSource;

@protocol WorldObjectsLoader <NSObject>
- (SceneModel* )loadModelFromFile:(NSString*)path;
- (LightSource* )loadLightSourceFromFile:(NSString*)path;
@end