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


-(int)getCellCount:(NSDictionary *)dict;
-(NSDictionary *)getItemForCellCount:(int)index dict:(NSDictionary *)dict count:(int *)start;

@end
