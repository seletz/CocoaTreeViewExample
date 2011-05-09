//
//  TreeListModel.m
//  TreeList
//
//  Created by Stephan Eletzhofer on 09.05.11.
//  Copyright 2011 Nexiles GmbH. All rights reserved.
//

#import "TreeListModel.h"
#import "NSString+SBJSON.h"

static int dbg = 0;

@interface TreeListModel ()

@property (nonatomic, retain) NSMutableArray *lookup;
@property (nonatomic, retain) NSMutableArray *level;

-(void)recalculate;
-(int)recalculateWithItem:(NSMutableDictionary *)item andLevel:(int)lvl;

@end

@implementation TreeListModel

@synthesize cellCount;
@synthesize items;
@synthesize level;
@synthesize lookup;

#pragma mark -
#pragma mark accessors

-(NSInteger)cellCount
{
    return cell_count;
}


-(void)setItems:(NSMutableDictionary *)newItems;
{
    DBGS;
    @synchronized (self) {
        if (items != newItems) {
            [items release];
            items = nil;
            if (newItems) {
                items = [newItems retain];
                [self recalculate];
            }
        }
    }
}

#pragma mark -
#pragma mark model item data access

-(NSMutableDictionary *)itemForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBG(@"indexPath=%@", indexPath);
    NSMutableDictionary *item = [self.lookup objectAtIndex:indexPath.row+1];
    return item;
}

-(NSInteger)levelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBG(@"indexPath=%@", indexPath);
    return [[self.level objectAtIndex:indexPath.row+1] intValue] - 1;
}

-(BOOL)isCellOpenForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBG(@"indexPath=%@", indexPath);
    NSMutableDictionary *item = [self itemForRowAtIndexPath:indexPath];
    return [[item objectForKey:@"isOpen"] boolValue];
}

-(void)setOpenClose:(BOOL)state forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBG(@"state=%d", state);
    NSMutableDictionary *item = [self itemForRowAtIndexPath:indexPath];
    [item setObject:[NSNumber numberWithBool:state] forKey:@"isOpen"];
    [self recalculate];
}

#pragma mark -
#pragma mark internal model housekeeping

-(void)recalculate
{
    DBGS;
    self.lookup = [NSMutableArray array];
    self.level = [NSMutableArray array];
    cell_count = [self recalculateWithItem:self.items
                                  andLevel:0] - 1;
#ifdef DEBUG
    for (NSMutableDictionary *item in self.lookup) {
        DBG(@"item.key=%@", [item objectForKey:@"key"]);
        
    }
#endif
    DBG(@"cell_count=%d", cell_count);
    
}

-(int)recalculateWithItem:(NSMutableDictionary *)dict andLevel:(int)lvl;
{
    //DBG(@"dict.key, isopen=%@, %@", [dict objectForKey:@"key"], [dict objectForKey:@"isOpen"]);

    int count = 1;

    [self.lookup addObject: dict];
    [self.level addObject: [NSNumber numberWithInt:lvl]];

    BOOL isOpen = [[dict objectForKey:@"isOpen"] boolValue];

    if (isOpen) {
        for (NSMutableDictionary *child in [dict objectForKey:@"value"]) {
            DBGX(2, @"count=%d, child.key=%@ child.isOpen=%@",
                    count,
                    [child objectForKey:@"key"],
                    [child objectForKey:@"isOpen"]);

            count += [self recalculateWithItem:child andLevel:lvl + 1];
        }
    }

    DBGX(2, @"===> level %d: count=%d for dict.key=%@", lvl, count, [dict objectForKey:@"key"]);
    return count;
}

#pragma mark -
#pragma mark init and dealloc

-(id)initWithDictionary:(NSMutableDictionary *)dict
{
	self = [super init];
	if (self) {
        self.lookup = [NSMutableArray array];
        self.level = [NSMutableArray array];
        self.items = dict;
		return self;
	}
	return nil;
}

-(id)initWithJSONString:(NSString *)jsonString
{
    return [self initWithDictionary:[jsonString JSONValue]];
}

-(id)initWithJSONFilePath:(NSString *)filePath
{
    DBG(@"filePath=%@", filePath);
    NSString *data = [NSString stringWithContentsOfFile:filePath];
    return [self initWithJSONString:data];
}

-(void)dealloc
{
	self.items = nil;
	self.lookup = nil;
	self.level = nil;
	[super dealloc];
}


@end
// vim: set sw=4 ts=4 expandtab:
