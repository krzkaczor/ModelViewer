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
#import "JsonLoader.h"
#import "BrsSceneModelLoader.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)loadView {
    [super loadView];

    self.topLeftImage.wantsLayer = YES;
    self.topLeftImage.layer.borderWidth = 1.0;
    self.bottomLeftImage.wantsLayer = YES;
    self.bottomLeftImage.layer.borderWidth = 1.0;
    self.topRightImage.wantsLayer = YES;
    self.topRightImage.layer.borderWidth = 1.0;
    self.bottomRightImage.wantsLayer = YES;
    self.bottomRightImage.layer.borderWidth = 1.0;

    id<LightSourceLoader> jsonModelLoader = [[JsonLoader alloc] init];
    id<SceneModelLoader> brsSceneLoader = [[BrsSceneModelLoader alloc] init];

    self.engine = [[Engine alloc] initWithSceneModelLoader:brsSceneLoader lightSourceLoader:jsonModelLoader];
    [self.engine loadModel:@"/Users/krzysztofkaczor/Workspace/ModelViewerGUI/SampleModels/TEA.BRS"];
    [self.engine loadLightConfig:@"/Users/krzysztofkaczor/Workspace/ModelViewerGUI/SampleModels/LightSource1.json"];
    [self requestFrame];
}

- (void)requestFrame {
    NSArray* frames = self.engine.generateFrames;

    self.topLeftImage.image = frames[0];
    self.bottomLeftImage.image = frames[1];
    self.topRightImage.image = frames[2];
    self.bottomRightImage.image = frames[3];
}

- (IBAction)loadNewModelClicked:(NSButton *)sender {
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        for (NSURL *url in [panel URLs]) {
            [self.engine loadModel:url.path];
            [self.engine loadLightConfig:@"/Users/krzysztofkaczor/Workspace/ModelViewerGUI/SampleModels/LightSource1.json"];
            [self requestFrame];
        }
    }
    
}
@end
