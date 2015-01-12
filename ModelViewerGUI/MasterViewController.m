//
//  MasterViewController.m
//  ModelViewerGUI
//
//  Created by Krzysztof Kaczor on 1/9/15.
//  Copyright (c) 2015 kaczor. All rights reserved.
//

#import "MasterViewController.h"
#import "BitmapRenderer.h"
#import "Triangle.h"
#import "Vertex.h"
#import "Color.h"
#import "Engine.h"
#import "ScreenRenderer.h"
#import "JsonLoader.h"
#import "InteractionImage.h"
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
    self.engine.mainImage = self.topLeftImage;
    self.engine.topImage = self.bottomLeftImage;
    self.engine.frontImage = self.topRightImage;
    self.engine.sideImage = self.bottomRightImage;
    self.engine.vc = self;
    
    [self.engine loadModel:@"/Users/krzysztofkaczor/Workspace/ModelViewerGUI/SampleModels/TEA.BRS"];
    [self.engine loadLightConfig:@"/Users/krzysztofkaczor/Workspace/ModelViewerGUI/SampleModels/LightSource1.json"];
}

- (IBAction)loadNewModelClicked:(NSButton *)sender {
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        for (NSURL *url in [panel URLs]) {
            [self.engine loadModel:url.path];
        }
    }
}

- (IBAction)orthoProjectionZoomChanged:(NSSlider*)sender {
    int zoomValue = (int) sender.integerValue;
    self.orthoProjectionZoomLabel.stringValue = [NSString stringWithFormat:@"%i", zoomValue];
    NSLog(@"Ortho projection zoom changed to: %i", zoomValue);
    [self.engine changeOrthographicCamerasZoomTo: zoomValue];
}

- (IBAction)tiltChanged:(NSSlider *)sender {
    int tiltValueInDegrees = (int) sender.integerValue;
    self.tiltLabel.stringValue = [NSString stringWithFormat:@"%i", tiltValueInDegrees];
    NSLog(@"Tilt value changed to: %i", tiltValueInDegrees);

    double tiltValueInRadians = tiltValueInDegrees * (180 / M_PI);
    [self.engine mainCameraTiltChangedTo:tiltValueInRadians];
}

- (void)updateModelInfo:(int)verticesNo and:(int)trianglesNo {
    self.vertcesNoLabel.stringValue = [NSString stringWithFormat:@"%i", verticesNo];
    self.trianglesNoLabel.stringValue = [NSString stringWithFormat:@"%i", trianglesNo];
}
@end
