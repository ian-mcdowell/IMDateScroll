//
//  IMDateScrollHeaderDateCell.h
//  DateScroll
//
//  Created by Ian McDowell on 10/19/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMDateScrollHeaderDateCell : UICollectionViewCell

@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *weekdayLabel;

@end
