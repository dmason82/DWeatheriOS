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
@property (weak, nonatomic) IBOutlet UILabel *cityText;
@property (weak, nonatomic) IBOutlet UIImageView *conditionsImage;
@property (weak, nonatomic) IBOutlet UILabel *conditionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *forecastHighLabel;
@property (weak, nonatomic) IBOutlet UILabel *forecastLowLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageWindLabel;
@property (weak, nonatomic) IBOutlet UILabel *forecastPercipitationLabel;
@property (weak, nonatomic) IBOutlet UILabel *forecastAverageHumidityLabel;
@property (strong,nonatomic)NSString* cityLocation;
@property (strong,nonatomic)NSNumber* isMetric;
-(void)configureView;
@end
