//
//  AppDelegate.m
//  OSXApplicationTemplate
//
//  Created by Darcy Liu on 6/19/16.
//  Copyright © 2016 Darcy Liu. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

static NSString *const kToolbarIdentifier = @"com.example.macos.kToolbarIdentifier";
static NSString *const kToolbarItemSettingsIdentifier = @"com.example.macos.toolbar.settings";
static NSString *const kToolbarItemPlayIdentifier = @"com.example.macos.toolbar.play";
static NSString *const kToolbarItemStopIdentifier = @"com.example.macos.toolbar.stop";
static NSString *const kToolbarItemSidebarLeftIdentifier = @"com.example.macos.toolbar.sidebar.left";

static NSString *const kWindowFrameAutosaveName = @"com.example.macos.window.frameautosave";

@interface AppDelegate ()<NSToolbarDelegate>
@property (nonatomic, strong) IBOutlet NSWindow *window;
@property (nonatomic, strong) MainViewController *mainVC;
@property (nonatomic, strong) NSToolbar *toolbar;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    // create the window
    NSRect contentRect = NSMakeRect(CGRectGetWidth([[NSScreen mainScreen] frame])/2 - 320, CGRectGetHeight([[NSScreen mainScreen] frame])/2-200, 640.0, 400.0);
    
    _window = [[NSWindow alloc] initWithContentRect: contentRect
                                          styleMask: NSWindowStyleMaskTitled
                                                       |NSWindowStyleMaskClosable
                                                       |NSWindowStyleMaskMiniaturizable
                                                       |NSWindowStyleMaskResizable
                                                       |NSWindowStyleMaskFullSizeContentView
                                            backing: NSBackingStoreBuffered
                                              defer: YES];
    [_window setTitle:@"OS X application without xib/storyboard"];
    
    _mainVC = [MainViewController new];
    [_mainVC.view setFrameSize:NSMakeSize(640, 400)];
    _window.contentViewController = _mainVC;
    // remember last location
    //_window.frameAutosaveName = kWindowFrameAutosaveName;
    //[_window setFrameFromString:kWindowFrameAutosaveName];
    
    [_window makeKeyAndOrderFront: self];
    
    [self setupToolbar];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)setupToolbar {
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier: kToolbarIdentifier];
    
    [toolbar setAllowsUserCustomization: YES];
    [toolbar setAutosavesConfiguration: YES];
    [toolbar setDisplayMode: NSToolbarDisplayModeIconOnly];
    [toolbar setDelegate: self];
    
    [_window setToolbar:toolbar];
    _toolbar = toolbar;
    
    //_window.titleVisibility = NSWindowTitleVisible;
    //_window.titlebarAppearsTransparent = YES;
    //_window.titlebarSeparatorStyle = NSTitlebarSeparatorStyleNone;
}

#pragma mark - Toolbar delegates
- (NSArray *) toolbarAllowedItemIdentifiers: (NSToolbar *) toolbar {
    return @[kToolbarItemSettingsIdentifier,
             kToolbarItemPlayIdentifier,
             kToolbarItemStopIdentifier,
             kToolbarItemSidebarLeftIdentifier,
             NSToolbarFlexibleSpaceItemIdentifier,
             NSToolbarSpaceItemIdentifier];
}

- (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar *)toolbar
{
    return @[NSToolbarFlexibleSpaceItemIdentifier,
             kToolbarItemSidebarLeftIdentifier,
             kToolbarItemPlayIdentifier,
             kToolbarItemStopIdentifier,
             kToolbarItemSettingsIdentifier];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
     itemForItemIdentifier:(NSString *)itemIdentifier
 willBeInsertedIntoToolbar:(BOOL)flag
{
    NSToolbarItem *toolbarItem = nil;
    
    if ([itemIdentifier isEqualTo:kToolbarItemSidebarLeftIdentifier]) {
        toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        [toolbarItem setLabel:@"Sidebar"];
        [toolbarItem setPaletteLabel:[toolbarItem label]];
        [toolbarItem setToolTip:@"Sidebar"];
        [toolbarItem setImage:[NSImage imageWithSystemSymbolName:@"sidebar.left" accessibilityDescription:@"sidebar"]];
        [toolbarItem setTarget:self];
        [toolbarItem setAction:@selector(customAction:)];
        toolbarItem.navigational = YES;
    } else if ([itemIdentifier isEqualTo:kToolbarItemPlayIdentifier]) {
        toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        [toolbarItem setLabel:@"Play"];
        [toolbarItem setPaletteLabel:[toolbarItem label]];
        [toolbarItem setToolTip:@"play"];
        [toolbarItem setImage:[NSImage imageWithSystemSymbolName:@"play.circle" accessibilityDescription:@"play"]];
        [toolbarItem setTarget:self];
        [toolbarItem setAction:@selector(customAction:)];
    }else if ([itemIdentifier isEqualTo:kToolbarItemStopIdentifier]) {
        toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        [toolbarItem setLabel:@"Stop"];
        [toolbarItem setPaletteLabel:[toolbarItem label]];
        [toolbarItem setToolTip:@"Stop"];
        [toolbarItem setImage:[NSImage imageWithSystemSymbolName:@"stop.circle" accessibilityDescription:@"stop"]];
        [toolbarItem setTarget:self];
        [toolbarItem setAction:@selector(customAction:)];
    } else if ([itemIdentifier isEqualTo:kToolbarItemSettingsIdentifier]) {
        toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        [toolbarItem setLabel:@"Settings"];
        [toolbarItem setPaletteLabel:[toolbarItem label]];
        [toolbarItem setToolTip:@"Settings"];
        [toolbarItem setImage:[NSImage imageWithSystemSymbolName:@"gear.circle" accessibilityDescription:@"settings"]];
        [toolbarItem setTarget:self];
        [toolbarItem setAction:@selector(customAction:)];
    }
    
    return toolbarItem;
}

#pragma mark - toolbar actions
- (void)customAction:(id)sender {
    NSLog(@"customAction: %@", sender);
    
    NSToolbarItem *toolbarItem = (NSToolbarItem *)sender;
    if ([toolbarItem.itemIdentifier isEqualTo:kToolbarItemSidebarLeftIdentifier]) {
        [_mainVC toggleSidebar:sender];
    }
}
@end
