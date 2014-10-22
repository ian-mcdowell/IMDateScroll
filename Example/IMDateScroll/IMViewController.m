//
//  IMViewController.m
//  IMDateScroll
//
//  Created by ian mcdowell on 10/19/2014.
//  Copyright (c) 2014 ian mcdowell. All rights reserved.
//

#import "IMViewController.h"

@interface IMViewController ()

@end

@implementation IMViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
	
	[self initSampleDates];
	[self setDelegate:self];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)initSampleDates {
	NSMutableDictionary *events = [NSMutableDictionary dictionary];
	NSMutableArray *dates = [NSMutableArray array];
	for (int i = 0; i < 100; i++) {
		NSDate *date = [NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60 * i];
		[dates addObject:date];
		[events setObject:[NSArray arrayWithObjects:@"Event 1", @"Event 2", @"Event 3", @"Event 4", nil] forKey:date];
	}
	
	self.dates = dates;
	self.events = events;
}

/*
 - (UICollectionViewCell *)dateScrollView:(IMDateScrollViewController *)dateScrollView headerCellForDate:(NSDate *)date {
	
 }*/
/*
 - (UITableViewCell *)dateScrollView:(IMDateScrollViewController *)dateScrollView cellForEvent:(NSInteger)event onDate:(NSDate *)date {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
	
	// do cell configuration here
	
	return cell;
 }*/
/*
 - (NSString *)dateScrollView:(IMDateScrollViewController *)dateScrollView titleForDate:(NSDate *)date {
	
 }*/

- (void)dateScrollView:(IMDateScrollViewController *)dateScrollView didSelectEventOnDate:(NSDate *)date {
	NSLog(@"Selected");
}

@end

