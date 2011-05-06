//
//  RootViewController.h
//  TreeList
//
//  Created by Stephan Eletzhofer on 06.05.11.
//  Copyright 2011 Nexiles GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
}

@property (nonatomic, retain) NSMutableDictionary *items;
@property (nonatomic, retain) NSMutableArray *lookup;
@property (nonatomic, retain) NSMutableArray *level;

-(int)getCellCount:(NSMutableDictionary *)dict level:(int)lvl;

@end
