//
//  TreeListTableViewCell.m
//  TreeList
//
//  Created by Stephan Eletzhofer on 09.05.11.
//  Copyright 2011 Nexiles GmbH. All rights reserved.
//

#import "TreeListTableViewCell.h"

static int dbg = 0;

#define MAX_LEVEL 3.0
#define RADIUS (5.0)
#define MARGIN_TOP (5.0)
#define MARGIN_BOTTOM (5.0)
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

-(UIColor *)colorForLevel:(int)level
{

    level = level>3?3:level;
    return [UIColor colorWithHue:98.0/360
                      saturation:(level*0.2/MAX_LEVEL)
                      brightness:0.95
                           alpha:1.0];
}

- (void) drawRect:(CGRect)rect
{
	DBGS;
	[super drawRect:rect];

    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;

    CGFloat indent = self.indentationLevel * self.indentationWidth;

    UIColor *strokeColor = [UIColor darkGrayColor];

    DBG(@"height=%g", height);
    DBG(@"width=%g", width);
    DBG(@"indent=%g", indent);

    [self setBackgroundColor:[self colorForLevel:self.indentationLevel]];

	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSaveGState(context);

    CGContextSetFillColorWithColor(context, [[self colorForLevel:self.indentationLevel] CGColor]);

    CGContextFillRect(context, self.frame);

    // name label
    CGRect nameLabelFrame = CGRectZero;
    nameLabelFrame.origin.x = indent + MARGIN_LEFT*2;
    nameLabelFrame.origin.y = MARGIN_TOP;
    nameLabelFrame.size.width = width/2;
    nameLabelFrame.size.height = height - MARGIN_TOP - MARGIN_BOTTOM;
    self.nameLabel.frame = nameLabelFrame;

    if (self.indentationLevel > 0) {
        for (int level = self.indentationLevel; level>0; level--) {
            CGContextSetFillColorWithColor(context, [[self colorForLevel:level - 1] CGColor]);
            CGFloat indent = (level - 1) * self.indentationWidth;
            CGContextBeginPath(context);

            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, 0, height);                             // top right
            CGContextAddLineToPoint(context, indent + MARGIN_LEFT, height);     // bottom right
            CGContextAddLineToPoint(context, indent + MARGIN_LEFT, 0);             // bottom left


            CGContextClosePath(context);
            CGContextFillPath(context);
            CGContextStrokePath(context);


            // left hand border lines
            CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, indent + MARGIN_LEFT, height);     // bottom right
            CGContextAddLineToPoint(context, indent + MARGIN_LEFT, 0);             // bottom left
            CGContextStrokePath(context);


        }
    }

    if (self.hasChildren && self.isOpen) {
        CGContextSetFillColorWithColor(context, [[self colorForLevel:self.indentationLevel + 1] CGColor]);

        CGContextBeginPath(context);

        // bottom left
        CGContextMoveToPoint(context, indent + MARGIN_LEFT, height);
        CGContextAddArcToPoint(context, indent + MARGIN_LEFT, height - MARGIN_BOTTOM,
                                        width,                height - MARGIN_BOTTOM,
                                        RADIUS);
        CGContextAddLineToPoint(context, width, height - MARGIN_BOTTOM);
        CGContextAddLineToPoint(context, width, height);

        CGContextClosePath(context);
        CGContextFillPath(context);


        // draw the border, bottom with arc
        CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, indent + MARGIN_LEFT, height);
        CGContextAddArcToPoint(context, indent + MARGIN_LEFT, height - MARGIN_BOTTOM,
                                        width,                height - MARGIN_BOTTOM,
                                        RADIUS);
        CGContextAddLineToPoint(context, width, height - MARGIN_BOTTOM);

        CGContextStrokePath(context);

    }

    // draw the bottom line
    if (!self.isOpen) {
        int level = self.indentationLevel;
        CGFloat indent = (level-1) * self.indentationWidth;
        CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
        CGContextBeginPath(context);
        if (level>0) {
            CGContextMoveToPoint(context, indent + MARGIN_LEFT, height);
            CGContextAddLineToPoint(context, width, height);
        } else {
            CGContextMoveToPoint(context, 0, height);
            CGContextAddLineToPoint(context, width, height);
        }
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
        [self.nameLabel setTextColor:[UIColor blackColor]];
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
        self.indentationWidth = MARGIN_LEFT;
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
