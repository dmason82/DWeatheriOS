//
//  DWeatherCurrentDetailsViewController.h
//  DWeather
//
//  Created by Doug Mason on 12/22/12.
//  Copyright (c) 2012 Doug Mason. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWeatherCurrentConditions,DWeatherViewController;
@interface DWeatherCurrentDetailsViewController : UIViewController
@property(nonatomic,weak)DWeatherCurrentConditions* detailItem;
@property (weak, nonatomic) IBOutlet UILabel *currentCityLabel;
@property(weak,nonatomic)IBOutlet UILabel* currentTemperatureLabel;
@property(weak,nonatomic)IBOutlet UILabel* currentHumidityLabel;
@property(weak,nonatomic)IBOutlet UILabel* currentFeelsLikeLabel;
@property(weak,nonatomic)IBOutlet UILabel* currentWindLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentVisibilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentWindGustsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *currentConditionsPicture;
@property (weak, nonatomic) IBOutlet UILabel *currentRainfallTodayLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentConditionsLabel;
@property (nonatomic,retain)NSNumber* isMetric;
-(void)configureDisplay;
@end
