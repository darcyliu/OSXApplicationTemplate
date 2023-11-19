//
//  AppDelegate.m
//  OSXApplicationTemplate
//
//  Created by Darcy Liu on 6/19/16.
//  Copyright © 2016 Darcy Liu. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DBManager.h"

static NSString *const kToolbarIdentifier = @"com.example.macos.kToolbarIdentifier";
static NSString *const kToolbarItemSettingsIdentifier = @"com.example.macos.toolbar.settings";
static NSString *const kToolbarItemPlayIdentifier = @"com.example.macos.toolbar.play";
static NSString *const kToolbarItemStopIdentifier = @"com.example.macos.toolbar.stop";
static NSString *const kToolbarItemAddIdentifier = @"com.example.macos.toolbar.add";
static NSString *const kToolbarItemSidebarLeftIdentifier = @"com.example.macos.toolbar.sidebar.left";

static NSString *const kWindowFrameAutosaveName = @"com.example.macos.window.frameautosave";

@interface AppDelegate ()<NSToolbarDelegate>
@property (nonatomic, strong) IBOutlet NSWindow *window;
@property (nonatomic, strong) MainViewController *mainVC;
@property (nonatomic, strong) NSToolbar *toolbar;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // create the window
    NSSize windowSize      = NSMakeSize(640, 400);
    NSRect windowFrame      = NSMakeRect((CGRectGetWidth([[NSScreen mainScreen] frame]) - windowSize.width) * 0.5,
                                         (CGRectGetHeight([[NSScreen mainScreen] frame]) - windowSize.height) * 0.5,
                                         windowSize.width,
                                         windowSize.height);
    
    _window = [[NSWindow alloc] initWithContentRect: windowFrame
                                          styleMask: NSWindowStyleMaskTitled
                                                       |NSWindowStyleMaskClosable
                                                       |NSWindowStyleMaskMiniaturizable
                                                       |NSWindowStyleMaskResizable
                                                       |NSWindowStyleMaskFullSizeContentView
                                            backing: NSBackingStoreBuffered
                                              defer: YES];
    [_window setTitle:@"OS X application without xib/storyboard"];
    
    _mainVC = [MainViewController new];
    [_mainVC.view setFrameSize: windowSize];
    _window.contentViewController = _mainVC;
    // remember last location
    //_window.frameAutosaveName = kWindowFrameAutosaveName;
    //[_window setFrameFromString:kWindowFrameAutosaveName];
    
    [_window makeKeyAndOrderFront: self];
    
    [self setupToolbar];
    
    //[self createSampleData];
    [self dumpDataToConsole];
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
    [toolbar setSizeMode: NSToolbarSizeModeRegular];
    [toolbar setDelegate: self];
    
    [_window setToolbar:toolbar];
    _toolbar = toolbar;
    
    //_window.titleVisibility = NSWindowTitleHidden;
    //_window.titlebarAppearsTransparent = YES;
    //_window.titlebarSeparatorStyle = NSTitlebarSeparatorStyleNone;
}

#pragma mark - Toolbar delegates
- (NSArray *) toolbarAllowedItemIdentifiers: (NSToolbar *) toolbar {
    return @[kToolbarItemSettingsIdentifier,
             kToolbarItemPlayIdentifier,
             kToolbarItemStopIdentifier,
             kToolbarItemAddIdentifier,
             //kToolbarItemSidebarLeftIdentifier,
             NSToolbarToggleSidebarItemIdentifier,
             NSToolbarSidebarTrackingSeparatorItemIdentifier,
             NSToolbarFlexibleSpaceItemIdentifier,
             NSToolbarSpaceItemIdentifier];
}

- (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar *)toolbar
{
    return @[NSToolbarToggleSidebarItemIdentifier,
             //NSToolbarSidebarTrackingSeparatorItemIdentifier,
             //NSToolbarFlexibleSpaceItemIdentifier,
             //kToolbarItemSidebarLeftIdentifier,
             kToolbarItemAddIdentifier,
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
    } else if ([itemIdentifier isEqualTo:kToolbarItemAddIdentifier]) {
        toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        [toolbarItem setLabel:@"Add"];
        [toolbarItem setPaletteLabel:[toolbarItem label]];
        [toolbarItem setToolTip:@"Add"];
        [toolbarItem setImage:[NSImage imageWithSystemSymbolName:@"plus" accessibilityDescription:@"add"]];
        [toolbarItem setTarget:self];
        [toolbarItem setAction:@selector(addAction:)];
        toolbarItem.navigational = YES;
    }  else if ([itemIdentifier isEqualTo:kToolbarItemSettingsIdentifier]) {
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

- (void)addAction:(id)sender {
    NSManagedObjectContext *context = [DBManager sharedInstance].managedObjectContext;
    NSManagedObject *newEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:context];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss ZZZ yyyy"];
    NSString *name = [dateFormatter stringFromDate:[NSDate new]];
    
    [newEntity setValue:name forKey:@"title"];
    [newEntity setValue:@(YES) forKey:@"isLeaf"];
    [newEntity setValue:[NSDate new] forKey:@"created"];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Error saving the managedObjectContext: %@", error);
    } else {
        NSLog(@"managedObjectContext successfully saved!");
    }
}

#pragma mark -
- (void)createSampleData {
    NSManagedObjectContext *context = [DBManager sharedInstance].managedObjectContext;
    NSManagedObject *newEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:context];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *name = [dateFormatter stringFromDate:[NSDate new]];
    
    [newEntity setValue:name forKey:@"title"];
    [newEntity setValue:@(YES) forKey:@"isLeaf"];
    [newEntity setValue:[NSDate new] forKey:@"created"];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Error saving the managedObjectContext: %@", error);
    } else {
        NSLog(@"managedObjectContext successfully saved!");
    }
}

- (void)dumpDataToConsole {
    NSManagedObjectContext *context = [DBManager sharedInstance].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Entity" inManagedObjectContext:context]];

    [request setSortDescriptors:[NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    
    NSError *error = nil;
    NSArray *entities = [context executeFetchRequest:request error:&error];

    if (error) {
        NSLog(@"Error fetching the person entities: %@", error);
    } else {
        for (NSManagedObject *entity in entities) {
            NSLog(@"Found: %@ %@", [entity valueForKey:@"title"],[entity valueForKey:@"created"]);
            [context deleteObject:entity];
        }
    }
    [context save:&error];
}
@end
