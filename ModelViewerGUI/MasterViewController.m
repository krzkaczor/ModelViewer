//
//  MasterViewController.m
//  ModelViewerGUI
//
//  Created by Krzysztof Kaczor on 1/9/15.
//  Copyright (c) 2015 kaczor. All rights reserved.
//

#import "MasterViewController.h"
#import "TriangleRenderer.h"
#import "Triangle.h"
#import "Vertex.h"
#import "Color.h"
#import "Engine.h"
#import "Renderer.h"
#import "JsonModelLoader.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)loadView {
    [super loadView];

    self.topLeftImage.wantsLayer = YES;
    self.topLeftImage.layer.borderWidth = 1.0;
    self.bottomLeftImage.wantsLayer = YES;
    self.bottomLeftImage.layer.borderWidth = 1.0;

    id<Renderer> renderer = [[TriangleRenderer alloc] init];
    id<WorldObjectsLoader> modelLoader = [[JsonModelLoader alloc] init];

    self.engine = [[Engine alloc] initWithRenderer:renderer modelLoader:modelLoader];
    [self.engine loadModel:@"/Users/krzysztofkaczor/Workspace/ModelViewerGUI/SampleModels/2DTriangle.json"];

    [self requestFrame];
}

- (void)requestFrame {
    CGSize cgSize = CGSizeMake(400, 400);


    NSImage* frame = self.engine.generateFrame;

    self.topLeftImage.image = frame;
//    self.bottomLeftImage.image = [renderer renderTriangle:triangle onScreen:cgSize];
}

@end
