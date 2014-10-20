//
//  IMDateScrollViewDataSource.h
//  DateScroll
//
//  Created by Ian McDowell on 10/19/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IMDateScrollViewController;

@protocol IMDateScrollViewDataSource <NSObject>

@optional
- (UICollectionViewCell *)dateScrollView:(IMDateScrollViewController *)dateScrollView headerCellForDate:(NSDate *)date;
- (UITableViewCell *)dateScrollView:(IMDateScrollViewController *)dateScrollView cellForEvent:(NSInteger)event onDate:(NSDate *)date;
- (NSString *)dateScrollView:(IMDateScrollViewController *)dateScrollView titleForDate:(NSDate *)date;
- (void)dateScrollView:(IMDateScrollViewController *)dateScrollView didSelectEventOnDate:(NSDate *)date;

@end