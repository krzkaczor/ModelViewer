//
//  AppDelegate.h
//  ModelViewerGUI
//
//  Created by Krzysztof Kaczor on 1/9/15.
//  Copyright (c) 2015 kaczor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MasterViewController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic,strong) IBOutlet MasterViewController *masterViewController;


@end

