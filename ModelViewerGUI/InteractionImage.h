//
//  InteractionImage.h
//  ModelViewerGUI
//
//  Created by Krzysztof Kaczor on 1/11/15.
//  Copyright (c) 2015 kaczor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Engine;
@class Camera;

@interface InteractionImage : NSImageView
@property (weak) Engine* engine;
@property(nonatomic, strong) Camera *assignedCamera;
@end
