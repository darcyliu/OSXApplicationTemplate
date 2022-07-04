//
//  SidebarViewController.m
//  OSXApplicationTemplate
//
//  Created by Darcy Liu on 04/07/2022.
//  Copyright © 2022 Darcy Liu. All rights reserved.
//

#import "SidebarViewController.h"

@interface SidebarViewController ()<NSOutlineViewDelegate,NSOutlineViewDataSource>
@property(nonatomic, strong) NSScrollView *scrollView;
@property(nonatomic, strong) NSOutlineView *outlineView;
@end

@implementation SidebarViewController
- (void)loadView {
    self.view = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 150, 400)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:self.view.bounds];
    
    scrollView.hasVerticalScroller      = NO;
    scrollView.hasHorizontalScroller    = NO;
    scrollView.autohidesScrollers       = YES;
    scrollView.scrollerStyle            = NSScrollerStyleOverlay;
    scrollView.verticalScrollElasticity = YES;
    scrollView.automaticallyAdjustsContentInsets = YES;
    scrollView.contentInsets            = NSEdgeInsetsMake(0, 0, 0, 0);
    scrollView.drawsBackground          = NO;
    scrollView.autoresizingMask         = NSViewWidthSizable | NSViewHeightSizable;
    
    [self.view addSubview:scrollView];
    _scrollView = scrollView;

    NSOutlineView *outlineView = [[NSOutlineView alloc] initWithFrame:_scrollView.bounds];
    outlineView.headerView              = nil;
    outlineView.allowsEmptySelection    = NO;
    outlineView.focusRingType           = NSFocusRingTypeNone;
    outlineView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;
    outlineView.intercellSpacing        = NSMakeSize(10, 10);
    outlineView.backgroundColor         = NSColor.clearColor;
    outlineView.delegate                = self;
    outlineView.dataSource              = self;
    
    NSTableColumn *column   = [[NSTableColumn alloc] initWithIdentifier:[self className]];
    column.resizingMask     = NSTableColumnAutoresizingMask;
    [outlineView addTableColumn:column];
    [outlineView expandItem:nil expandChildren:YES];
    
    [scrollView setDocumentView:outlineView];
    _outlineView = outlineView;
}

#pragma mark - OutlineView delegate
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if (item == nil) {
        return 10;
    }
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if (item == nil) {
        return @(0);//return an object
    }
    return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if ([item isKindOfClass:[NSDictionary class]]) {
        return YES;
    }else {
        return NO;
    }
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    NSTextField *textField = [[NSTextField alloc] init];
    textField.editable          = NO;
    textField.selectable        = NO;
    textField.bordered          = NO;
    textField.drawsBackground   = NO;
    textField.backgroundColor   = [NSColor clearColor];
    textField.focusRingType     = NSFocusRingTypeNone;
    textField.bezelStyle        = NSTextFieldSquareBezel;
    textField.lineBreakMode     = NSLineBreakByTruncatingTail;
    textField.cell.scrollable   = NO;
    textField.wantsLayer        = YES;
    textField.layer.backgroundColor = [NSColor clearColor].CGColor;
    [textField setStringValue:@"Title"];
    [textField sizeToFit];
    
    //NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 100, 30)];
    //[view addSubview:textField];
    
    return textField;
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
    return 30;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item {
    return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
    return YES;
}
@end
