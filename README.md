# IMDateScroll

[![CI Status](http://img.shields.io/travis/ian mcdowell/IMDateScroll.svg?style=flat)](https://travis-ci.org/ian mcdowell/IMDateScroll)
[![Version](https://img.shields.io/cocoapods/v/IMDateScroll.svg?style=flat)](http://cocoadocs.org/docsets/IMDateScroll)
[![License](https://img.shields.io/cocoapods/l/IMDateScroll.svg?style=flat)](http://cocoadocs.org/docsets/IMDateScroll)
[![Platform](https://img.shields.io/cocoapods/p/IMDateScroll.svg?style=flat)](http://cocoadocs.org/docsets/IMDateScroll)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Check out the sample view controller in the example project. There are a few delegate methods you can implement if you wish (none are required), including:

	- (UICollectionViewCell *)dateScrollView:(IMDateScrollViewController *)dateScrollView headerCellForDate:(NSDate *)date
	- (UITableViewCell *)dateScrollView:(IMDateScrollViewController *)dateScrollView cellForEventOnDate:(NSDate *)date
	- (NSString *)dateScrollView:(IMDateScrollViewController *)dateScrollView titleForDate:(NSDate *)date
	- (void)dateScrollView:(IMDateScrollViewController *)dateScrollView didSelectEventOnDate:(NSDate *)date

This library uses two data sets:
* Events - An NSdictionary of NSDates mapped to an NSArray of event objects (whatever you like)
* Dates - An NSArray of the keys of the dictionary, sorted in whatever order you want to display them in.

## Requirements

Only tested on iOS 7+
Requires ARC

## Installation

IMDateScroll is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "IMDateScroll"

## Author

Ian McDowell, mcdow.ian@gmail.com

## License

IMDateScroll is available under the MIT license. See the LICENSE file for more info.

