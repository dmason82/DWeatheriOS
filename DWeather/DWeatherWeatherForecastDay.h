//
//  DWeatherWeatherForecastDay.h
//  DWeather
//
//  Created by Doug Mason on 9/8/12.
//  Copyright (c) 2012 Doug Mason. All rights reserved.
//
/*
 private float lowTemp,highTemp;
 private String day,icon,condition;
 */

/*
 */
#import <Foundation/Foundation.h>

@interface DWeatherWeatherForecastDay : NSObject
@property(nonatomic,strong)NSNumber *lowTempF;
@property(nonatomic,strong)NSNumber *highTempF;
@property(nonatomic,strong)NSNumber *lowTempC;
@property(nonatomic,strong)NSNumber *highTempC;
@property(nonatomic,strong)NSString *dayOfWeek;
@property(nonatomic,strong)NSString *forecastDay;
@property(nonatomic,strong)NSString *forecastIconPath;
@property(nonatomic,strong)NSString *forecastCondition;
@property(nonatomic,strong)NSString *forecastWindTextEnglish;
@property(nonatomic,strong)NSString *forecastWindTextMetric;
@property(nonatomic,strong)NSNumber *averageHumidity;
@property(nonatomic,strong)NSString *forecastPercipitationIn;
@property(nonatomic,strong)NSString *forecastPercipitationCm;
@end
