//
//  TreeListModel.m
//  TreeList
//
//  Created by Stephan Eletzhofer on 09.05.11.
//  Copyright 2011 Nexiles GmbH. All rights reserved.
//

#import "TreeListModel.h"
#import "NSString+SBJSON.h"

static int dbg = 1;

@interface TreeListModel ()

@property (nonatomic, retain) NSMutableArray *lookup;
@property (nonatomic, retain) NSMutableArray *level;

-(void)recalculate;
-(int)recalculateWithItem:(id)item andLevel:(int)lvl;

@end

@implementation TreeListModel

@synthesize cellCount;
@synthesize root;
@synthesize level;
@synthesize lookup;

@synthesize keyKeyPath;
@synthesize childKeyPath;
@synthesize isOpenKeyPath;

#pragma mark -
#pragma mark accessors

-(NSInteger)cellCount
{
    return cell_count;
}


-(void)setRoot:(id)newRoot;
{
    DBG(@"newRoot=%@", newRoot);
    @synchronized (self) {
        if (root != newRoot) {
            [root release];
            root = nil;
            if (newRoot) {
                root = [newRoot retain];
                [self recalculate];
            }
        }
    }
}

#pragma mark -
#pragma mark model item data access

-(id)itemForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBG(@"indexPath=%@", indexPath);
    return [self.lookup objectAtIndex:indexPath.row+1];
}

-(NSInteger)levelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBG(@"indexPath=%@", indexPath);
    return [[self.level objectAtIndex:indexPath.row+1] intValue] - 1;
}

-(BOOL)isCellOpenForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBG(@"indexPath=%@", indexPath);
    id item = [self itemForRowAtIndexPath:indexPath];
    return [[item valueForKeyPath:self.isOpenKeyPath] boolValue];
}

-(void)setOpenClose:(BOOL)state forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBG(@"state=%d", state);
    id item = [self itemForRowAtIndexPath:indexPath];
    [item setValue:[NSNumber numberWithBool:state] forKey:self.isOpenKeyPath];
    [self recalculate];
}

#pragma mark -
#pragma mark internal model housekeeping

-(void)recalculate
{
    DBGS;
    self.lookup = [NSMutableArray array];
    self.level = [NSMutableArray array];
    cell_count = [self recalculateWithItem:self.root
                                  andLevel:0] - 1;
#ifdef DEBUG
    for (id item in self.lookup) {
        DBG(@"item.key=%@", [item valueForKeyPath:self.keyKeyPath]);

    }
#endif
    DBG(@"cell_count=%d", cell_count);

}

-(int)recalculateWithItem:(id)item andLevel:(int)lvl;
{
    DBG(@"item.key, isopen=%@, %@", [item valueForKeyPath:self.keyKeyPath], [item valueForKeyPath:self.isOpenKeyPath]);

    int count = 1;

    [self.lookup addObject: item];
    [self.level addObject: [NSNumber numberWithInt:lvl]];

    BOOL isOpen = [[item valueForKeyPath:self.isOpenKeyPath] boolValue];

    if (isOpen) {
        for (id child in [item valueForKeyPath:self.childKeyPath]) {
            DBGX(2, @"count=%d, child.key=%@ child.isOpen=%@",
                    count,
                    [child valueForKeyPath:self.keyKeyPath],
                    [child valueForKeyPath:self.isOpenKeyPath]);

            count += [self recalculateWithItem:child andLevel:lvl + 1];
        }
    }

    DBGX(2, @"===> level %d: count=%d for item.key=%@", lvl, count, [item valueForKeyPath:self.keyKeyPath]);
    return count;
}

#pragma mark -
#pragma mark init and dealloc

-(id)init
{
	self = [super init];
	if (self) {
        // initialize key paths for model access
        self.keyKeyPath = @"key";
        self.isOpenKeyPath = @"isOpen";
        self.childKeyPath = @"value";

        self.lookup = [NSMutableArray array];
        self.level = [NSMutableArray array];
    }
    return nil;
}

-(id)initWithDictionary:(NSMutableDictionary *)dict
{
	self = [self init];
    if (self) {
        self.root = dict;
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
    NSString *data = [NSString stringWithContentsOfFile:filePath
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
    return [self initWithJSONString:data];
}

-(void)dealloc
{
	self.root         = nil;
	self.lookup        = nil;
	self.level         = nil;
	self.isOpenKeyPath = nil;
	self.keyKeyPath    = nil;
	self.childKeyPath  = nil;
	[super dealloc];
}


@end
// vim: set sw=4 ts=4 expandtab:
