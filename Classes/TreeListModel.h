//
//  TreeListModel.h
//  TreeList
//
//  Created by Stephan Eletzhofer on 09.05.11.
//  Copyright 2011 Nexiles GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TreeListModel : NSObject {
    NSInteger cell_count;

}

@property (nonatomic, retain) NSMutableDictionary *items;
@property (nonatomic, readonly) NSInteger cellCount;

// designated initializer
-(id)initWithDictionary:(NSMutableDictionary *)dict;
-(id)initWithJSONString:(NSString *)jsonString;
-(id)initWithJSONFilePath:(NSString *)filePath;

// item and item level access
-(NSMutableDictionary *)itemForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)levelForRowAtIndexPath:(NSIndexPath *)indexPath;

// open/close state
-(BOOL)isCellOpenForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)setOpenClose:(BOOL)state forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
