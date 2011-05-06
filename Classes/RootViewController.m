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

    NSString *data = @"[ \
    { \
      \"key\": \"Chapter 1\", \
      \"value\": [ \
          \"Subchapter 1.1\", \
          \"Subchapter 1.2\", \
          \"Subchapter 1.3\" \
      ] \
    }, \
    { \
      \"key\": \"Chapter 2\", \
      \"value\": [ \
          \"Subchapter 2.1\", \
          \"Subchapter 2.2\", \
          \"Subchapter 2.3\" \
      ] \
    }, \
    { \
      \"key\": \"Chapter 3\", \
      \"value\": [ \
          \"Subchapter 3.1\", \
          \"Subchapter 3.2\", \
          \"Subchapter 3.3\" \
      ] \
    } \
    ]";

    self.items = [data JSONValue];
    DBG(@"self.items=%@", self.items);
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

    NSDictionary *item = [self.items objectAtIndex:indexPath.row];

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

-(id)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle
{
    DBGS;
    self = [super initWithNibName:name bundle:bundle];
    if (self) {

    NSString *data = @"[ \
            { \
                'key': 'Chapter 1', \
                'value': [ \
                    'Subchapter 1.1', \
                    'Subchapter 1.2', \
                    'Subchapter 1.3', \
                ] \
            }, \
            { \
                'key': 'Chapter 2', \
                'value': [ \
                    'Subchapter 2.1', \
                    'Subchapter 2.2', \
                    'Subchapter 2.3', \
                ] \
            }, \
            { \
                'key': 'Chapter 3', \
                'value': [ \
                    'Subchapter 3.1', \
                    'Subchapter 3.2', \
                    'Subchapter 3.3', \
                ] \
            } \
        ]";

        self.items = [data JSONValue];
        DBG(@"self.items=%@", self.items);

        return self;
    }
    return nil;
}

- (void)dealloc {
    [super dealloc];
    self.items = nil;
}


@end
// vim: set sw=4 ts=4 expandtab:
