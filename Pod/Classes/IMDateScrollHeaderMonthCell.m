//
//  IMdateScrollHeaderMonthCell.m
//  Pods
//
//  Created by McDowell, Ian J [ITACD] on 10/22/14.
//
//

#import "IMDateScrollHeaderMonthCell.h"

@implementation IMDateScrollHeaderMonthCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:frame];
    }
    return self;
}

- (void)setup:(CGRect)frame {
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height * 0.6f)];
    self.monthLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:frame.size.height * 0.5f];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    self.monthLabel.textColor = [UIColor darkGrayColor];
    
    self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height * 0.6f, frame.size.width, frame.size.height * 0.4f)];
    self.yearLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:frame.size.height * 0.3f];
    self.yearLabel.textAlignment = NSTextAlignmentCenter;
    self.yearLabel.textColor = [UIColor darkGrayColor];
    
    [self addSubview:self.monthLabel];
    [self addSubview:self.yearLabel];
}

@end
