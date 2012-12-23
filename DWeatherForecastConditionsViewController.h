//
//  DWeatherForecastConditionsViewController.h
//  DWeather
//
//  Created by Doug Mason on 12/22/12.
//  Copyright (c) 2012 Doug Mason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DWeatherWeatherForecastDay;
@interface DWeatherForecastConditionsViewController : UIViewController
@property(weak,nonatomic)DWeatherWeatherForecastDay* detailItem;
-(void)configureView;
@end
