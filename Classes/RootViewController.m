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


@synthesize items;
@synthesize lookup;
@synthesize level;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    DBGS;
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"contents" ofType:@"json"];
    NSString *data = [NSString stringWithContentsOfFile:filePath];

    self.lookup = [NSMutableArray array];
    self.level = [NSMutableArray array];

    self.items = [data JSONValue];
    DBGX(2, @"self.items=%@", self.items);

#if 0
    int cell_count = [self getCellCount:self.items];
    DBGX(2, @"cell_count=%d", cell_count);

    DBGX(2, @"self.lookup=%@", self.lookup);

    for (int i=0; i<cell_count; i++) {
        NSLog(@"Cell %d: %@", i, [[self.lookup objectAtIndex:i] objectForKey:@"key"]);
    }
#endif
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(int)getCellCount:(NSMutableDictionary *)dict level:(int)lvl;
{
    //DBG(@"dict.key, isopen=%@, %@", [dict objectForKey:@"key"], [dict objectForKey:@"isOpen"]);

    int count = 1;

    [self.lookup addObject: dict];
    [self.level addObject: [NSNumber numberWithInt:lvl]];

    BOOL isOpen = [[dict objectForKey:@"isOpen"] boolValue];

    if (isOpen) {
        for (NSMutableDictionary *child in [dict objectForKey:@"value"]) {
            DBGX(2, @"count=%d, child.key=%@ child.isOpen=%@",
                    count,
                    [child objectForKey:@"key"],
                    [child objectForKey:@"isOpen"]);

            count += [self getCellCount:child level:lvl + 1];
        }
    }

    DBGX(2, @"===> level %d: count=%d for dict.key=%@", lvl, count, [dict objectForKey:@"key"]);
    return count;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.lookup = [NSMutableArray array];
    self.level = [NSMutableArray array];
    return [self getCellCount:items level:0] - 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DBG(@"indexPath=%@", indexPath);
    
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    NSMutableDictionary *item = [self.lookup objectAtIndex:indexPath.row+1];

    cell.indentationLevel = [[self.level objectAtIndex:indexPath.row+1] intValue] - 1;
    cell.textLabel.text = [NSString stringWithFormat:@"%d: %@", cell.indentationLevel, [item objectForKey:@"key"]];

    BOOL isOpen = [[item valueForKeyPath:@"isOpen"] boolValue];
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
    NSMutableDictionary *item = [self.lookup objectAtIndex:indexPath.row+1];
    DBGX(2, @"item.key=%@ item.isOpen=%@", [item objectForKey:@"key"], [item objectForKey:@"isOpen"]);

    BOOL newState = NO;
    if (NO == [[item valueForKeyPath:@"isOpen"] boolValue]) {
         newState = YES;
    } else {
         newState = NO;
    }
    [item setObject:[NSNumber numberWithBool:newState] forKey:@"isOpen"];

    DBGX(2, @"item.key=%@ item.isOpen=%@", [item objectForKey:@"key"], [item objectForKey:@"isOpen"]);

    [tableView beginUpdates];
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
    self.items = nil;
    self.lookup = nil;
    self.level = nil;
}


@end
// vim: set sw=4 ts=4 expandtab:
