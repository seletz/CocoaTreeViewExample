//
//  RootViewController.h
//  TreeList
//
//  Created by Stephan Eletzhofer on 06.05.11.
//  Copyright 2011 Nexiles GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TreeListModel.h"

@interface RootViewController : UITableViewController {
}

@property (nonatomic, retain) TreeListModel *model;

@end
