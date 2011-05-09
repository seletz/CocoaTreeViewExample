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

@property (nonatomic, retain) id root;
@property (nonatomic, readonly) NSInteger cellCount;


// key paths for accessing the model object
@property (nonatomic, retain) NSString *isOpenKeyPath;
@property (nonatomic, retain) NSString *keyKeyPath;
@property (nonatomic, retain) NSString *childKeyPath;

// designated initializer
-(id)init;
-(id)initWithDictionary:(NSMutableDictionary *)dict;
-(id)initWithJSONString:(NSString *)jsonString;
-(id)initWithJSONFilePath:(NSString *)filePath;

// item and item level access
-(id)itemForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)levelForRowAtIndexPath:(NSIndexPath *)indexPath;

// open/close state
-(BOOL)isCellOpenForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)setOpenClose:(BOOL)state forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
