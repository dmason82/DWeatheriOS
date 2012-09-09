//
//  DWeatherViewController.h
//  DWeather
//
//  Created by Doug Mason on 9/8/12.
//  Copyright (c) 2012 Doug Mason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWeatherViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *weatherDays;

@end
