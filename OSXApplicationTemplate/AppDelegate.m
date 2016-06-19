//
//  AppDelegate.m
//  OSXApplicationTemplate
//
//  Created by Darcy Liu on 6/19/16.
//  Copyright © 2016 Darcy Liu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (nonatomic, strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    // create the window
    NSRect contentRect = NSMakeRect(CGRectGetWidth([[NSScreen mainScreen] frame])/2 - 200, CGRectGetHeight([[NSScreen mainScreen] frame])/2-200, 400.0, 400.0);
    
    _window = [[NSWindow alloc] initWithContentRect: contentRect
                                          styleMask: NSTitledWindowMask
               |NSClosableWindowMask
               |NSMiniaturizableWindowMask
               |NSResizableWindowMask
                                            backing: NSBackingStoreBuffered
                                              defer: YES];
    [_window setTitle:@"OS X application without xib/storyboard"];
    [_window makeKeyAndOrderFront: self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}
@end
