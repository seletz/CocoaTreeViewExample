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

-(int)getCellCount:(NSDictionary *)dict level:(int)lvl;
{
    //DBG(@"dict.key, isopen=%@, %@", [dict objectForKey:@"key"], [dict objectForKey:@"isOpen"]);

    int count = 1;

    [self.lookup addObject: dict];
    [self.level addObject: [NSNumber numberWithInt:lvl]];

    BOOL isOpen = [[dict objectForKey:@"isOpen"] boolValue];

    if (isOpen) {
        for (NSDictionary *child in [dict objectForKey:@"value"]) {
            DBGX(2, @"count=%d, child.key=%@ child.isOpen=%@",
                    count,
                    [child objectForKey:@"key"],
                    [child objectForKey:@"isOpen"]);

            count += [self getCellCount:child level:lvl + 1];
        }
    }

    DBG(@"===> level %d: count=%d for dict.key=%@", lvl, count, [dict objectForKey:@"key"]);
    return count;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DBGS;
    NSInteger count = [self getCellCount:items level:0] - 1;

    DBG(@"self.lookup=%@", self.lookup);
    DBG(@"self.level=%@", self.level);
    
    return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DBGS;
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    NSDictionary *item = [self.lookup objectAtIndex:indexPath.row+1];

    cell.indentationLevel = [[self.level objectAtIndex:indexPath.row+1] intValue] - 1;
    cell.textLabel.text = [NSString stringWithFormat:@"%d: %@", cell.indentationLevel, [item objectForKey:@"key"]];

    NSLog(@"value.@count = %@", [item valueForKeyPath:@"value.@count"]);

    if ([[item valueForKeyPath:@"value.@count"] intValue] > 0) {
        cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType        = UITableViewCellAccessoryNone;
    }

    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
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
