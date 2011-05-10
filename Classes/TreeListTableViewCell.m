//
//  TreeListTableViewCell.m
//  TreeList
//
//  Created by Stephan Eletzhofer on 09.05.11.
//  Copyright 2011 Nexiles GmbH. All rights reserved.
//

#import "TreeListTableViewCell.h"

static int dbg = 1;

#define RADIUS (5.0)
#define MARGIN_TOP (7.5)
#define MARGIN_BOTTOM (7.5)
#define MARGIN_LEFT (10.0)

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
@interface IndentView : UIView
{
}

@property (assign) int indentationLevel;
@property (assign) CGFloat indentationWidth;
@property (assign) BOOL hasChildren;
@property (assign) BOOL isOpen;

@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UIImageView *imageView;

- (id)initWithFrame:(CGRect)frame;

@end

@implementation IndentView

@synthesize nameLabel;
@synthesize imageView;

@synthesize indentationLevel;
@synthesize indentationWidth;
@synthesize isOpen;
@synthesize hasChildren;

#pragma mark -
#pragma mark custom drawing

- (void) drawRect:(CGRect)rect
{
	DBGS;
	[super drawRect:rect];

    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;

    CGFloat indent = self.indentationLevel * self.indentationWidth;

    DBG(@"height=%g", height);
    DBG(@"width=%g", width);
    DBG(@"indent=%g", indent);

	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSaveGState(context);

	UIColor *col = [UIColor greenColor];

	CGContextSetFillColorWithColor(context, [col CGColor]);

    // name label
    CGRect nameLabelFrame = CGRectZero;
    nameLabelFrame.origin.x = indent + MARGIN_LEFT*2;
    nameLabelFrame.origin.y = MARGIN_TOP;
    nameLabelFrame.size.width = width/2;
    nameLabelFrame.size.height = height - MARGIN_TOP - MARGIN_BOTTOM;
    self.nameLabel.frame = nameLabelFrame;

    if (self.indentationLevel > 0) {
        for (int level = self.indentationLevel; level>0; level--) {
            CGFloat indent = (level - 1) * self.indentationWidth;
            CGContextBeginPath(context);

            CGContextMoveToPoint(context, indent + MARGIN_LEFT, 0);
            CGContextAddLineToPoint(context, indent + MARGIN_LEFT, height);

            //CGContextClosePath(context);
            CGContextStrokePath(context);
        }
    }

    if (self.hasChildren && self.isOpen) {
        CGContextBeginPath(context);

        CGContextMoveToPoint(context, indent + MARGIN_LEFT, height);
        CGContextAddArcToPoint(context, indent + MARGIN_LEFT, height - MARGIN_BOTTOM,
                                        width,                height - MARGIN_BOTTOM,
                                        RADIUS);
        CGContextAddLineToPoint(context, width, height - MARGIN_BOTTOM);

        CGContextStrokePath(context);

    }

	CGContextRestoreGState(context);

    CGContextSetBlendMode(context, kCGBlendModeClear);
}

- (id)initWithFrame:(CGRect)frame
{
    DBG(@"frame=%@", NSStringFromCGRect(frame));
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];

        self.nameLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.nameLabel setTextColor:[UIColor orangeColor]];
        [self.nameLabel setTextAlignment:UITextAlignmentLeft];

        [self addSubview:self.nameLabel];

        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        [self addSubview:self.imageView];
    }
    return self;
}

-(void)dealloc
{
    self.nameLabel = nil;
    self.imageView = nil;
    [super dealloc];
}

@end

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

@interface TreeListTableViewCell ()

@property (nonatomic,retain) IndentView *indentView;

@end

@implementation TreeListTableViewCell

@synthesize indentView;
@synthesize isOpen;
@synthesize hasChildren;
@synthesize name;

#pragma mark -
#pragma mark accessors

- (void) layoutSubviews
{
    DBGS;
    self.indentView.indentationLevel = self.indentationLevel;
    self.indentView.indentationWidth = self.indentationWidth;
    self.indentView.hasChildren = self.hasChildren;
    self.indentView.isOpen = self.isOpen;

    CGRect frame = self.indentView.frame;
    DBG(@"self.frame=%@", NSStringFromCGRect(frame));
    frame.size.width = self.frame.size.width;
    frame.size.height = self.frame.size.height;
    self.indentView.frame = frame;
    DBG(@"self.indentView.frame=%@", NSStringFromCGRect(self.indentView.frame));

    self.indentView.nameLabel.text = self.name;

    [self.indentView setNeedsDisplay];
	[super layoutSubviews];
}

#pragma mark -
#pragma mark init and dealloc


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.indentationWidth = 20.0;
        self.name = @"foo";

        self.indentView = [[[IndentView alloc] initWithFrame:self.frame] autorelease];
        [[self contentView] addSubview:self.indentView];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
}


- (void)dealloc {
    self.indentView = nil;
    [super dealloc];
}

@end

// vim: set sw=4 ts=4 expandtab:
