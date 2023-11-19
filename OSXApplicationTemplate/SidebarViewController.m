//
//  SidebarViewController.m
//  OSXApplicationTemplate
//
//  Created by Darcy Liu on 04/07/2022.
//  Copyright © 2022 Darcy Liu. All rights reserved.
//

#import "SidebarViewController.h"

#import "DBManager.h"
#import "Entity+CoreDataClass.h"
#import "Entity+CoreDataProperties.h"

@interface SidebarViewController ()<NSOutlineViewDelegate,NSOutlineViewDataSource, NSFetchedResultsControllerDelegate>
@property(nonatomic, strong) NSScrollView *scrollView;
@property(nonatomic, strong) NSOutlineView *outlineView;

@property (strong) NSTreeController *treeController;

@property (strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation SidebarViewController
- (void)loadView {
    self.view = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 150, 400)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Entity"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];

    NSManagedObjectContext *context = [DBManager sharedInstance].managedObjectContext;
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]
                                                            initWithFetchRequest:fetchRequest
                                                            managedObjectContext:context
                                                            sectionNameKeyPath:nil
                                                            cacheName:@"menu"];
    NSError *error;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"Fetch data failed with error: %@", error);
    }
    fetchedResultsController.delegate = self;
    _fetchedResultsController = fetchedResultsController;
    
    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:self.view.bounds];
    
    scrollView.hasVerticalScroller      = YES;
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
    outlineView.backgroundColor         = NSColor.purpleColor;
    outlineView.delegate                = self;
    outlineView.dataSource              = self;
    outlineView.autoresizesOutlineColumn= YES;
    outlineView.autoresizingMask        = NSViewWidthSizable | NSViewHeightSizable;
    NSTableColumn *column   = [[NSTableColumn alloc] initWithIdentifier:[self className]];
    column.resizingMask     = NSTableColumnAutoresizingMask;
    [outlineView addTableColumn:column];
    [outlineView expandItem:nil expandChildren:YES];
    
    [scrollView setDocumentView:outlineView];
    _outlineView = outlineView;
    
//    NSTreeController *treeController = [[NSTreeController alloc] init];
//    [treeController setLeafKeyPath:@"isLeaf"];
//    [treeController setChildrenKeyPath:@"children"];
//    [outlineView bind:@"content" toObject:treeController withKeyPath:@"arrangedObjects" options:nil];
//    [outlineView bind:@"sortDescriptors" toObject:treeController withKeyPath:@"sortDescriptors" options:nil];
//    [outlineView bind:@"selectionIndexPaths" toObject:treeController withKeyPath:@"selectionIndexPaths" options:nil];
//
//    _treeController = treeController;
    
//    MenuNode *menuNode = [[MenuNode alloc] init];
//    menuNode.name = @"aaa";
//    NSTreeNode *node = [[NSTreeNode alloc] initWithRepresentedObject:menuNode];
//    [treeController insertObject:node atArrangedObjectIndexPath:[NSIndexPath indexPathWithIndex:0]];
}

#pragma mark - OutlineView delegate
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if (item == nil) {
        return [[_fetchedResultsController fetchedObjects] count];
    }
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if (item == nil) {
        return [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];//@(0);//return an object
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
    textField.autoresizingMask  = NSViewWidthSizable | NSViewHeightSizable;
    textField.layer.backgroundColor = [NSColor clearColor].CGColor;
    NSManagedObject *entity = (NSManagedObject *)item;
    NSString *title = [entity valueForKey:@"title"];
    [textField setStringValue: title];
    [textField sizeToFit];
    
//    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 100, 30)];
//    [view setWantsLayer:YES];
//    view.layer.backgroundColor = [NSColor clearColor].CGColor;
//    view.autoresizingMask  = NSViewWidthSizable | NSViewHeightSizable;
//    [view addSubview:textField];
    
    return textField;
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
    return 30;
}

//- (CGFloat)outlineView:(NSOutlineView *)outlineView sizeToFitWidthOfColumn:(NSInteger)column {
//    return 100;
//}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item {
    return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
    return YES;
}

#pragma mark -
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    //
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
    atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
    newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [_outlineView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:indexPath.item] inParent:nil withAnimation:NSTableViewAnimationEffectFade];
            break;
        case NSFetchedResultsChangeDelete:
            //[_outlineView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:indexPath.item] inParent:nil withAnimation:NSTableViewAnimationEffectFade];
            break;
        case NSFetchedResultsChangeUpdate:
            //[_outlineView reloadDataForRowIndexes:<#(nonnull NSIndexSet *)#> columnIndexes:<#(nonnull NSIndexSet *)#>]
            break;
        case NSFetchedResultsChangeMove:
            [_outlineView moveItemAtIndex:indexPath.item inParent:nil toIndex:newIndexPath.item inParent:nil];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
}

- (void)outlineViewColumnDidResize:(NSNotification *)notification {
    NSLog(@"notify: %@", notification);
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    NSLog(@"notify: %@", notification);
}
@end
