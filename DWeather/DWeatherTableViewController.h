//
//  DWeatherTableViewController.h
//  DWeather
//
//  Created by Doug Mason on 1/8/13.
//  Copyright (c) 2013 Doug Mason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWeatherViewController.h"
@interface DWeatherTableViewController : UITableViewController
@property(nonatomic,weak)DWeatherViewController* controller;
-(void)fetchWeatherWithOperation;
@end
