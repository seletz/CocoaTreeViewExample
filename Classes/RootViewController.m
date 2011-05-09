//
//  RootViewController.m
//  TreeList
//
//  Created by Stephan Eletzhofer on 06.05.11.
//  Copyright 2011 Nexiles GmbH. All rights reserved.
//

#import "NSString+SBJSON.h"
#import "RootViewController.h"

static int dbg = 1;
@implementation RootViewController


@synthesize model;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    DBGS;
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"contents" ofType:@"json"];

    self.model = [[TreeListModel alloc] initWithJSONFilePath:filePath];
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    DBGS;
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DBGS;
    return self.model.cellCount;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DBG(@"indexPath=%@", indexPath);

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    NSMutableDictionary *item = [self.model itemForRowAtIndexPath:indexPath];

    cell.indentationLevel = [self.model levelForRowAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [item objectForKey:@"key"]];

    BOOL isOpen = [self.model isCellOpenForRowAtIndexPath:indexPath];
    int item_count = [[item valueForKeyPath:@"value.@count"] intValue];
    if (isOpen == NO && item_count > 0) {
        cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType        = UITableViewCellAccessoryNone;
    }

    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBG(@"indexPath=%@", indexPath);

    BOOL newState = NO;
    BOOL isOpen = [self.model isCellOpenForRowAtIndexPath:indexPath];
    if (NO == isOpen) {
         newState = YES;
    } else {
         newState = NO;
    }
    [self.model setOpenClose:newState forRowAtIndexPath:indexPath];

    [tableView beginUpdates];
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
             withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
    DBGS;
    self.model = nil;
    [super dealloc];
}


@end
// vim: set sw=4 ts=4 expandtab:
