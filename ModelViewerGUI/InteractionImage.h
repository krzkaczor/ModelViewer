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
@class DoublePoint;
@class Vector;

@interface InteractionImage : NSImageView
@property (weak) Engine* engine;
@property(nonatomic, strong) Camera *assignedCamera;
@property(nonatomic, strong) Vector *lightSourceDragPoint;
@property(nonatomic) BOOL draggedLight;
@property(nonatomic, strong) Vector *cameraDragPoint;
@property(nonatomic) BOOL draggedCamera;
@property(nonatomic) BOOL draggedEye;
@property(nonatomic, strong) id eyeDragPoint;
@end
