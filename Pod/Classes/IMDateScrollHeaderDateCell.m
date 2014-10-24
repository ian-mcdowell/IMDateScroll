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
    
    CGFloat centerOffset = (frame.size.height - frame.size.width) / 2 + 5;
    
    self.circleView = [[UIView alloc] initWithFrame:CGRectMake(5, centerOffset, frame.size.width - 10, frame.size.width - 10)];
    [self.circleView setBackgroundColor:[UIColor lightGrayColor]];
    
    self.weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.circleView.frame.size.width, 20.0f)];
    self.weekdayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:self.circleView.frame.size.height / 5];
    self.weekdayLabel.textAlignment = NSTextAlignmentCenter;
    self.weekdayLabel.textColor = [UIColor whiteColor];
    
    self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.circleView.frame.size.height / 2) - 20.0f, self.circleView.frame.size.width, 40.0f)];
    self.dayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:self.circleView.frame.size.height / 2.0];
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel.textColor = [UIColor whiteColor];
    
    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.circleView.frame.size.height - 20.0f, self.circleView.frame.size.width, 20.0f)];
    self.monthLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:self.circleView.frame.size.height / 5];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    self.monthLabel.textColor = [UIColor whiteColor];
    
    [self.circleView addSubview:self.weekdayLabel];
    [self.circleView addSubview:self.dayLabel];
    [self.circleView addSubview:self.monthLabel];
    
    [self.circleView.layer setCornerRadius:(self.circleView.frame.size.height / 2)];
    
    [self addSubview:self.circleView];
}

- (void)setSelected:(BOOL)selected {
    self.backgroundColor = [UIColor clearColor];
    self.circleView.backgroundColor = selected ? [UIColor grayColor] : [UIColor lightGrayColor];
    [super setSelected:selected];
}

@end
