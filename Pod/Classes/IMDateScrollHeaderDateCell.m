//
//  IMDateScrollHeaderDateCell.m
//  DateScroll
//
//  Created by Ian McDowell on 10/19/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

#import "IMDateScrollHeaderDateCell.h"

@implementation IMDateScrollHeaderDateCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:frame];
    }
    return self;
}

- (void)setup:(CGRect)frame {
    [self setBackgroundColor:[UIColor clearColor]];
    
    CGFloat width = MIN(frame.size.width, frame.size.height) - 20;
    
    CGFloat centerYOffset = (frame.size.height - width) / 2 + 5;
    CGFloat centerXOffset = (frame.size.width - width) / 2;
    
    
    self.circleView = [[UIView alloc] initWithFrame:CGRectMake(centerXOffset, centerYOffset, width, width)];
    [self.circleView setBackgroundColor:[UIColor colorWithWhite:0.6f alpha:0.5f]];
    
    self.weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5.0f, frame.size.width, 10.0f)];
    self.weekdayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f];
    self.weekdayLabel.textAlignment = NSTextAlignmentCenter;
    self.weekdayLabel.textColor = [UIColor darkGrayColor];
    
    self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.circleView.frame.size.height / 2) - 20.0f, self.circleView.frame.size.width, 40.0f)];
    self.dayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:self.circleView.frame.size.height / 2.0];
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:self.weekdayLabel];
    [self.circleView addSubview:self.dayLabel];
    
    [self.circleView.layer setCornerRadius:(self.circleView.frame.size.height / 2)];
    
    [self addSubview:self.circleView];
}

- (void)setSelected:(BOOL)selected {
    self.backgroundColor = [UIColor clearColor];
    self.circleView.backgroundColor = selected ? [UIColor colorWithRed:203/255.0f green:53/255.0f blue:56/255.0f alpha:1.0f] : [UIColor colorWithWhite:0.6f alpha:0.5f];
    [super setSelected:selected];
}

@end
