//
//  TreeListAppDelegate.h
//  TreeList
//
//  Created by Stephan Eletzhofer on 06.05.11.
//  Copyright 2011 Nexiles GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TreeListAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

