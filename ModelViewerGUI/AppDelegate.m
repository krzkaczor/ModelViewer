//
//  AppDelegate.m
//  ModelViewerGUI
//
//  Created by Krzysztof Kaczor on 1/9/15.
//  Copyright (c) 2015 kaczor. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];

    [self.window.contentView addSubview:self.masterViewController.view];
    self.masterViewController.view.frame = ((NSView*)self.window.contentView).bounds;
    
    CGSize fixedSize = self.window.frame.size;
    [self.window setMinSize:fixedSize];
    [self.window setMaxSize:fixedSize];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
