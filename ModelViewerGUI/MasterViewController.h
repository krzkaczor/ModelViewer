//
//  MasterViewController.h
//  ModelViewerGUI
//
//  Created by Krzysztof Kaczor on 1/9/15.
//  Copyright (c) 2015 kaczor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Engine;

@interface MasterViewController : NSViewController

@property (weak) IBOutlet NSImageView *topLeftImage;
@property (weak) IBOutlet NSImageView *bottomLeftImage;

@property (strong) Engine* engine;

@end
