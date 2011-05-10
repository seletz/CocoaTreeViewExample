//
//  TreeListTableViewCell.h
//  TreeList
//
//  Created by Stephan Eletzhofer on 09.05.11.
//  Copyright 2011 Nexiles GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TreeListTableViewCell : UITableViewCell {

}

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL hasChildren;

@property (nonatomic, retain) NSString *name;

@end
