//
//  ViewController.m
//  DateScroll
//
//  Created by Ian McDowell on 10/19/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

#import "IMDateScrollViewController.h"
#import "IMDateScrollHeaderDateCell.h"
#import "IMDateScrollHeaderMonthCell.h"

@interface IMDateScrollViewController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UICollectionView *headerDateView;
@property (nonatomic, strong) UICollectionView *headerMonthView;
@property NSInteger currentSelectedDay;
@property NSInteger currentSelectedMonth;
@property BOOL scrollingToDay;
@property BOOL scrollingToMonth;

@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSDictionary *days;

@end

@implementation IMDateScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.headerDayHeight = self.view.frame.size.height / 8.0;
    self.headerMonthHeight = 50.0f;
    self.currentSelectedDay = -1;
    self.currentSelectedMonth = -1;
    
    CGFloat headerHeight = self.headerDayHeight + self.headerMonthHeight;
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, headerHeight)];
    [self.headerView setBackgroundColor:[UIColor clearColor]];
    
    
    // setup the header date view (circles)
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(self.view.bounds.size.width / 5.0, self.headerDayHeight);
    
    self.headerDateView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.headerMonthHeight, self.view.bounds.size.width, self.headerDayHeight) collectionViewLayout:layout];
    
    self.headerDateView.dataSource = self;
    self.headerDateView.delegate = self;
    [self.headerDateView registerClass:[IMDateScrollHeaderDateCell class] forCellWithReuseIdentifier:@"IMDateScrollHeaderDateCell"];
    
    //self.headerDateView.pagingEnabled = YES;
    self.headerDateView.showsHorizontalScrollIndicator = NO;
    self.headerDateView.scrollsToTop = NO;
    
    [self.headerDateView setBackgroundColor:[UIColor clearColor]];
    
    
    // setup the header month view (months)
    UICollectionViewFlowLayout *monthLayout = [[UICollectionViewFlowLayout alloc] init];
    [monthLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    monthLayout.minimumInteritemSpacing = 0;
    monthLayout.minimumLineSpacing = 0;
    monthLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.headerMonthHeight);
    
    self.headerMonthView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.headerMonthHeight) collectionViewLayout:monthLayout];
    self.headerMonthView.dataSource = self;
    self.headerMonthView.delegate = self;
    [self.headerMonthView registerClass:[IMDateScrollHeaderMonthCell class] forCellWithReuseIdentifier:@"IMDateScrollHeaderMonthCell"];
    
    self.headerMonthView.showsHorizontalScrollIndicator = NO;
    self.headerMonthView.scrollsToTop = NO;
    
    [self.headerMonthView setBackgroundColor:[UIColor clearColor]];
    [self.headerMonthView setPagingEnabled:YES];
    [self.headerMonthView setAllowsSelection:NO];
    
    [self.headerView addSubview:self.headerMonthView];
    [self.headerView addSubview:self.headerDateView];
    
    [self.view addSubview:self.headerView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerHeight, self.view.bounds.size.width, self.view.bounds.size.height - headerHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    [self scrollViewDidScroll:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDates:(NSArray *)dates {
    // split dates array into a dictionary month by month (self.months is a sorted array of the dictionary's keys)
    _dates = dates;
    NSMutableDictionary *days = [NSMutableDictionary dictionary];
    NSMutableArray *months = [NSMutableArray array];
    for (NSDate *date in dates) {
        NSDate *month = [self getMonthForDate:date];
        if ([days objectForKey:month] == nil) {
            [months addObject:month];
            [days setObject:[NSMutableArray array] forKey:month];
        }
        [(NSMutableArray *)[days objectForKey:month] addObject:date];
    }
    self.days = days;
    self.months = months;
}

- (void)reloadData {
    // resets errything
    [self.tableView reloadData];
    [self.headerDateView reloadData];
    [self.headerMonthView reloadData];
    [self setScrollingToMonth:NO];
    [self setScrollingToDay:NO];
    [self setCurrentSelectedDay:-1];
    [self setCurrentSelectedMonth:-1];
    
    // select first item
    [self scrollViewDidScroll:self.tableView];
}

# pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dates.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDate *date = [self.dates objectAtIndex:section];
    return [[self.events objectForKey:date] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDate *date = [self.dates objectAtIndex:section];
    
    if ([self.delegate respondsToSelector:@selector(dateScrollView:titleForDate:)]) {
        return [self.delegate dateScrollView:self titleForDate:date];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eeee, MMM dd, yyyy"];
    
    return [dateFormatter stringFromDate:date];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = [self.dates objectAtIndex:indexPath.section];
    NSString *event = [[self.events objectForKey:date] objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(dateScrollView:cellForEvent:onDate:)]) {
        return [self.delegate dateScrollView:self cellForEvent:indexPath.row onDate:date];
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.text = event;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = [self.dates objectAtIndex:indexPath.section];
    if ([self.delegate respondsToSelector:@selector(dateScrollView:didSelectEventOnDate:)]) {
        [self.delegate dateScrollView:self didSelectEventOnDate:date];
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.dates.count == 0 || self.months.count == 0 || self.days.count == 0) {
        return;
    }
    if (scrollView == self.tableView) {
		
		NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
		if ([visibleIndexPaths count] > 10) {
			return;
		}
        
        NSIndexPath *topIndexPath = [visibleIndexPaths firstObject];
        
        NSInteger day = topIndexPath.section;
        NSDate *month = [self getMonthForDate:[self.dates objectAtIndex:day]];
        NSInteger monthIndex = [self.months indexOfObject:month];
        NSInteger dayInMonth = [[self.days objectForKey:[self.months objectAtIndex:monthIndex]] indexOfObject:[self.dates objectAtIndex:day]];
        if (self.currentSelectedDay != day && !self.scrollingToDay && self.dates.count > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:dayInMonth inSection:monthIndex];
            [self.headerDateView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            self.currentSelectedDay = day;
        }
        if (self.currentSelectedMonth != monthIndex && !self.scrollingToMonth) {
            //NSLog(@"Should scroll month");
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:monthIndex inSection:0];
            [self.headerMonthView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
            self.currentSelectedMonth = monthIndex;
            [self setScrollingToMonth:YES];
        }
    } else if (scrollView == self.headerDateView) {
        NSNumber *mostCommon;
        NSDecimalNumber *curMax = [NSDecimalNumber zero];
        NSMutableDictionary *words = [NSMutableDictionary dictionary];
        
        NSArray *visibleIndexPaths = [self.headerDateView indexPathsForVisibleItems];
        if ([visibleIndexPaths count] > 10) {
            return;
        }
        
        for (NSIndexPath *i in visibleIndexPaths) {
            NSUInteger sectionPath = [i indexAtPosition:0];
            NSNumber *key = [NSNumber numberWithInteger:sectionPath];
            if (!words[key]) {
                [words setObject:[NSDecimalNumber zero] forKey:key];
            }
            
            words[key] = [words[key] decimalNumberByAdding:[NSDecimalNumber one]];
            
            if ([words[key] compare:curMax] == NSOrderedDescending) {
                mostCommon = key;
                curMax = words[key];
            }
        }
        NSInteger month = [mostCommon integerValue];
        if (self.currentSelectedMonth != month && !self.scrollingToMonth) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:month inSection:0];
            //NSLog(@"Scrolling header month view to row %ld", month);
            self.currentSelectedMonth = month;
            [self.headerMonthView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
            [self setScrollingToMonth:YES];
        }

    } else if (scrollView == self.headerMonthView) {
        CGPoint centerPoint = CGPointMake(self.headerMonthView.frame.size.width / 2 + scrollView.contentOffset.x, self.headerMonthView.frame.size.height /2 + scrollView.contentOffset.y);
        NSIndexPath *firstIndex = [self.headerMonthView indexPathForItemAtPoint:centerPoint];
        if (self.currentSelectedMonth != firstIndex.row && !self.scrollingToMonth) {
            self.currentSelectedMonth = firstIndex.row;
            //NSLog(@"Scrolling header date view to section %ld", firstIndex.row);
            [self.headerDateView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:firstIndex.row] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
            [self setScrollingToMonth:YES];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.headerMonthView) {
        [self setScrollingToMonth:YES];
    } else if (scrollView == self.headerDateView) {
        [self setScrollingToDay:YES];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self setScrollingToDay:NO];
    [self setScrollingToMonth:NO];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    if (collectionView == self.headerDateView) {
        return self.months.count;
    } else {
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.headerDateView) {
        return [[self.days objectForKey:[self.months objectAtIndex:section]] count];
    } else {
        return [self.months count];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.headerDateView) {
        //NSLog(@"Header date view clicked. Index path: %li %li", (long)indexPath.section, (long)indexPath.row);
        NSDate *date = [(NSArray *)[self.days objectForKey:[self.months objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        NSInteger index = [self.dates indexOfObject:date];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        //[self.headerDateView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self setScrollingToDay:YES];
        [self setScrollingToMonth:YES];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.headerDateView) {
        NSDate *date = [(NSArray *)[self.days objectForKey:[self.months objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
        if ([self.delegate respondsToSelector:@selector(dateScrollView:headerCellForDate:)]) {
            return [self.delegate dateScrollView:self headerCellForDate:date];
        }
    
    
        IMDateScrollHeaderDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IMDateScrollHeaderDateCell" forIndexPath:indexPath];
    
        NSDateFormatter *weekdayFormatter = [[NSDateFormatter alloc] init];
        [weekdayFormatter setDateFormat:@"eee"];
    
        NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
        [monthFormatter setDateFormat:@"MMM"];
    
        NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
        [dayFormatter setDateFormat:@"dd"];
    
    
    
        cell.weekdayLabel.text = [[weekdayFormatter stringFromDate:date] uppercaseString];
        cell.dayLabel.text = [dayFormatter stringFromDate:date];
        cell.monthLabel.text = [[monthFormatter stringFromDate:date] uppercaseString];
    
        return cell;
    } else {
        IMDateScrollHeaderMonthCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IMDateScrollHeaderMonthCell" forIndexPath:indexPath];
        
        NSDate *date = [self.months objectAtIndex:indexPath.row];
        
        NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
        [monthFormatter setDateFormat:@"MMMM yyyy"];
        cell.monthLabel.text = [monthFormatter stringFromDate:date];
        
        return cell;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (scrollView == self.headerDateView) {
        [self setScrollingToDay:NO];
    }
    if (scrollView == self.headerMonthView) {
        [self setScrollingToMonth:NO];
    }
    
    
    if (scrollView == self.headerDateView) {
        CGPoint point = *targetContentOffset;
    
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.headerDateView.collectionViewLayout;
    
        // This assumes that the values of `layout.sectionInset.left` and
        // `layout.sectionInset.right` are the same with `layout.minimumInteritemSpacing`.
        // Remember that we're trying to snap to one item at a time. So one
        // visible item comprises of its width plus the left margin.
        CGFloat visibleWidth = layout.minimumInteritemSpacing + layout.itemSize.width;
    
        // It's either we go forwards or backwards.
        int indexOfItemToSnap = round(point.x / visibleWidth);
    
        // The only exemption is the last item.
        if (indexOfItemToSnap + 1 == [self.headerDateView numberOfItemsInSection:0]) { // last item
            *targetContentOffset = CGPointMake(self.headerDateView.contentSize.width -
                                               self.headerDateView.bounds.size.width, 0);
        } else {
            *targetContentOffset = CGPointMake(indexOfItemToSnap * visibleWidth, 0);
        }
    }
}

- (NSDate *)getMonthForDate:(NSDate *)inputDate {
    if (inputDate == nil) {
        return nil;
    }
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfMonth = [calendar dateFromComponents:dateComps];
    return beginningOfMonth;
}

@end
