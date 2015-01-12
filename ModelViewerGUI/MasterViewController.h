//
//  MasterViewController.h
//  ModelViewerGUI
//
//  Created by Krzysztof Kaczor on 1/9/15.
//  Copyright (c) 2015 kaczor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Engine;
@class InteractionImage;

@interface MasterViewController : NSViewController

@property (weak) IBOutlet NSImageView *topLeftImage;
@property (weak) IBOutlet InteractionImage *bottomLeftImage;
@property (weak) IBOutlet InteractionImage *topRightImage;
@property (weak) IBOutlet InteractionImage *bottomRightImage;
- (IBAction)loadNewModelClicked:(NSButton *)sender;

- (IBAction)orthoProjectionZoomChanged:(NSSlider*)sender;
@property (weak) IBOutlet NSTextField *orthoProjectionZoomLabel;

- (IBAction)tiltChanged:(NSSlider *)sender;

- (void)updateModelInfo:(int)verticesNo and:(int)trianglesNo;

@property (weak) IBOutlet NSTextField *tiltLabel;

@property (weak) IBOutlet NSTextField *vertcesNoLabel;
@property (weak) IBOutlet NSTextField *trianglesNoLabel;

@property (strong) Engine* engine;
@end
