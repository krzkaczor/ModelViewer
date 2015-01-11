//
//  InteractionImage.m
//  ModelViewerGUI
//
//  Created by Krzysztof Kaczor on 1/11/15.
//  Copyright (c) 2015 kaczor. All rights reserved.
//

#import "InteractionImage.h"
#import "Engine.h"
#import "Vector.h"
#import "Camera.h"

@implementation InteractionImage

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint p = [self convertPoint:theEvent.locationInWindow fromView:nil];
    NSPoint pointClickedOnBitmap = CGPointMake(p.x, _frame.size.height - p.y); //transform to the same coordinate system as used in engine
    printf("Clicked %f x %f\n", pointClickedOnBitmap.x, pointClickedOnBitmap.y);
    Vector* pointClickedOnBitmapByVector = [Vector vectorWithX:pointClickedOnBitmap.x y:pointClickedOnBitmap.y z:0];

    [self.engine mouseDown:pointClickedOnBitmapByVector onViewShownBy:self.assignedCamera ];
}

@end
