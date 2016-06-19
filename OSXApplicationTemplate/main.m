//
//  main.m
//  OSXApplicationTemplate
//
//  Created by Darcy Liu on 6/19/16.
//  Copyright © 2016 Darcy Liu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AppDelegate.h"

static AppDelegate* _appDelegate;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [NSApplication sharedApplication];
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        
        // NSAPP do not retain the instance of delegate, we have to hold it by ourself.
        _appDelegate = [[AppDelegate alloc] init];
        [NSApp setDelegate:_appDelegate];
        //[NSApp activateIgnoringOtherApps:YES];
        [NSApp run];
    }
    return (EXIT_SUCCESS);
}
