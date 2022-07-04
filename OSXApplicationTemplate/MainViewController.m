//
//  MainViewController.m
//  OSXApplicationTemplate
//
//  Created by Darcy Liu on 04/07/2022.
//  Copyright © 2022 Darcy Liu. All rights reserved.
//

#import "MainViewController.h"

#import "SidebarViewController.h"
#import "ContentViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

//- (NSSize)preferredContentSize {
//    return NSMakeSize(640, 400);
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSSplitViewItem *sidebarItem = [NSSplitViewItem sidebarWithViewController:[[SidebarViewController alloc] init]];
    sidebarItem.titlebarSeparatorStyle = NSTitlebarSeparatorStyleNone;
    
    NSSplitViewItem *contentItem = [NSSplitViewItem splitViewItemWithViewController:[ContentViewController new]];
    contentItem.titlebarSeparatorStyle = NSTitlebarSeparatorStyleAutomatic;
    self.splitViewItems = @[
        sidebarItem,
        contentItem
    ];
    
    self.splitView.dividerStyle = NSSplitViewDividerStyleThin;
}

@end
