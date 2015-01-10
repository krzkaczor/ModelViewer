//
// Created by Krzysztof Kaczor on 1/10/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LightSource;

@protocol LightSourceLoader <NSObject>
- (LightSource* )loadLightSourceFromFile:(NSString*)path;
@end