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

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    DBGS;
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"contents" ofType:@"json"];
    NSString *data = [NSString stringWithContentsOfFile:filePath];

    self.items = [data JSONValue];
    DBG(@"self.items=%@", self.items);

    int cell_count = [self getCellCount:self.items];
    DBG(@"cell_count=%d", cell_count);

    NSDictionary *item = nil;
    item = [self getItemForCellCount:1 dict:self.items count:NULL];
    DBG(@"item=%@", item);

    item = [self getItemForCellCount:2 dict:self.items count:NULL];
    DBG(@"item=%@", item);

    item = [self getItemForCellCount:4 dict:self.items count:NULL];
    DBG(@"item=%@", item);

    for (int i=0; i<cell_count; i++) {
        item = [self getItemForCellCount:i dict:self.items count:NULL];
        NSLog(@"Cell %d: %@", i, [item objectForKey:@"key"]);
    }
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(int)getCellCount:(NSDictionary *)dict
{
    DBG(@"dict.key, isopen=%@, %@", [dict objectForKey:@"key"], [dict objectForKey:@"isOpen"]);

    int count = 1;

    BOOL isOpen = [[dict objectForKey:@"isOpen"] boolValue];

    if (isOpen) {
        for (NSDictionary *child in [dict objectForKey:@"value"]) {
            DBGX(2, @"count=%d, child.key=%@ child.isOpen=%@",
                    count,
                    [child objectForKey:@"key"],
                    [child objectForKey:@"isOpen"]);

            count += [self getCellCount:child];
        }
    }

    DBG(@"===> count=%d for dict.key=%@", count, [dict objectForKey:@"key"]);
    return count;
}

-(NSDictionary *)getItemForCellCount:(int)index dict:(NSDictionary *)dict count:(int *)start
{
    DBGX(2, @"index=%d", index);
    DBGX(2, @"dict=%@", dict);
    DBGX(2, @"start=%p", start);

    int count = 0;
    NSDictionary *found = nil;

    if (start != NULL)
        count = *start;

    for (NSDictionary *child in [dict objectForKey:@"value"]) {
        count += 1;

        DBGX(3, @"count=%d", count);
        DBGX(3, @"child=%@", child);

        if (count == index)
            return child;

        if ([child objectForKey:@"isOpen"]) {
            found = [self getItemForCellCount:index
                                         dict:child
                                        count:&count];
            if (found)
                return found;
        }
    }

    return nil;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DBGS;
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    NSDictionary *item = [self.items objectForKey:@"root"];

    cell.textLabel.text = [item objectForKey:@"key"];

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
}


@end
// vim: set sw=4 ts=4 expandtab:
