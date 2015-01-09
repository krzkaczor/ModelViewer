//
//  MasterViewController.m
//  ModelViewerGUI
//
//  Created by Krzysztof Kaczor on 1/9/15.
//  Copyright (c) 2015 kaczor. All rights reserved.
//

#import "MasterViewController.h"
#import "TriangleRenderer.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)loadView {
    [super loadView];

    CGSize cgSize = CGSizeMake(300, 300);
    TriangleRenderer* renderer = [[TriangleRenderer alloc] init];
    self.topLeftImage.image = [renderer renderTriangle:0 onScreen:cgSize];
    self.bottomLeftImage.image = [renderer renderTriangle:0 onScreen:cgSize];
}

@end
