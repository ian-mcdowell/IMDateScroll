//
//  ViewController.h
//  DateScroll
//
//  Created by Ian McDowell on 10/19/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMDateScrollViewDataSource.h"

@interface IMDateScrollViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) id<IMDateScrollViewDataSource> delegate;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, strong) NSDictionary *events;

@property CGFloat headerHeight;

@end

