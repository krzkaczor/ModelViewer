//
//  InteractionImage.m
//  ModelViewerGUI
//
//  Created by Krzysztof Kaczor on 1/11/15.
//  Copyright (c) 2015 kaczor. All rights reserved.
//

#import <objc/objc-api.h>
#import "InteractionImage.h"
#import "Engine.h"
#import "Vector.h"

#define DRAG_RADIUS 10

@implementation InteractionImage

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent {
    Vector *pointClickedOnBitmapByVector = [self getVectorInBitmapCoordinates:theEvent];
    printf("Drag point: %f x %f\n", _lightSourceDragPoint.x, _lightSourceDragPoint.y);
    self.draggedLight = [self.lightSourceDragPoint isInRadiusOf:DRAG_RADIUS withVector:pointClickedOnBitmapByVector];
    if (!self.draggedLight) {
        self.draggedCamera = [self.cameraDragPoint isInRadiusOf:DRAG_RADIUS withVector:pointClickedOnBitmapByVector];
    }
    if (!self.draggedCamera) {
        self.draggedEye = [self.eyeDragPoint isInRadiusOf:DRAG_RADIUS withVector:pointClickedOnBitmapByVector];
    }
}

- (void)mouseDragged:(NSEvent *)theEvent {
    Vector *pointClickedOnBitmapByVector = [self getVectorInBitmapCoordinates:theEvent];

    if (self.draggedLight){
        [self.engine lightMovedTo:pointClickedOnBitmapByVector onViewShownBy:self.assignedCamera];
    }
    if (self.draggedCamera){
        [self.engine cameraMovedTo:pointClickedOnBitmapByVector onViewShownBy:self.assignedCamera];
    }
    if (self.draggedEye){
        [self.engine eyeMovedTo:pointClickedOnBitmapByVector onViewShownBy:self.assignedCamera];
    }
}

-(void)mouseUp:(NSEvent *)theEvent {
    self.draggedLight = self.draggedCamera = self.draggedEye = NO;
}

- (Vector *)getVectorInBitmapCoordinates:(NSEvent *)theEvent {
    NSPoint p = [self convertPoint:theEvent.locationInWindow fromView:nil];
    NSPoint pointClickedOnBitmap = CGPointMake(p.x, _frame.size.height - p.y); //transform to the same coordinate system as used in engine
    Vector* pointClickedOnBitmapByVector = [Vector vectorWithX:pointClickedOnBitmap.x y:pointClickedOnBitmap.y z:0];
    return pointClickedOnBitmapByVector;
}

@end
