//
//  ViewController.m
//  DateScroll
//
//  Created by Ian McDowell on 10/19/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

#import "IMDateScrollViewController.h"
#import "IMDateScrollHeaderDateCell.h"

@interface IMDateScrollViewController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UICollectionView *headerDateView;
@property NSInteger currentSelectedDay;
@property BOOL scrollingToDay;

@end

@implementation IMDateScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.headerHeight = 80.0f;
    self.currentSelectedDay = -1;
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.headerHeight)];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(self.view.bounds.size.width / 5.0, self.headerHeight);
    
    self.headerDateView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.headerHeight) collectionViewLayout:layout];
    
    self.headerDateView.dataSource = self;
    self.headerDateView.delegate = self;
    [self.headerDateView registerClass:[IMDateScrollHeaderDateCell class] forCellWithReuseIdentifier:@"IMDateScrollHeaderDateCell"];
    
    self.headerDateView.pagingEnabled = YES;
    self.headerDateView.showsHorizontalScrollIndicator = NO;
    
    [self.headerDateView setBackgroundColor:[UIColor darkGrayColor]];
    
    [self.headerView addSubview:self.headerDateView];
    
    [self.view addSubview:self.headerView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerHeight, self.view.bounds.size.width, self.view.bounds.size.height - self.headerHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    [self scrollViewDidScroll:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData {
    [self.tableView reloadData];
    [self.headerDateView reloadData];
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
    if (scrollView == self.tableView) {
        NSNumber *mostCommon;
        NSDecimalNumber *curMax = [NSDecimalNumber zero];
        NSMutableDictionary *words = [NSMutableDictionary dictionary];
        
        for (NSIndexPath *i in [self.tableView indexPathsForVisibleRows]) {
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
        
        NSInteger day = [mostCommon integerValue];
        if (self.currentSelectedDay != day && !self.scrollingToDay && self.dates.count > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:day inSection:0];
            //[self.headerDateView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            [self.headerDateView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            self.currentSelectedDay = day;
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self setScrollingToDay:NO];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dates.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.headerDateView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self setScrollingToDay:YES];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = [self.dates objectAtIndex:indexPath.row];
    
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
}



@end
