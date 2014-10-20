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
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20.0f)];
    self.weekdayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    self.weekdayLabel.textAlignment = NSTextAlignmentCenter;
    
    self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (frame.size.height / 2) - 20.0f, frame.size.width, 40.0f)];
    self.dayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:31];
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    
    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 20.0f, frame.size.width, 20.0f)];
    self.monthLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.weekdayLabel];
    [self addSubview:self.dayLabel];
    [self addSubview:self.monthLabel];
}

- (void)setSelected:(BOOL)selected {
    self.backgroundColor = selected ? [UIColor colorWithWhite:0.9 alpha:1.0] : [UIColor whiteColor];
    [super setSelected:selected];
}

@end
