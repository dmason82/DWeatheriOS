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
 JSONObject currentForecastDateObject = currentSimpleForecastObject.getJSONObject("date");
 newForecast.setIconPath(currentSimpleForecastObject.getString("icon_url"));
 newForecast.setCondition(currentSimpleForecastObject.getString("conditions"));
 newForecast.setDay(Integer.toString(currentForecastDateObject.getInt("month"))+"/"+Integer.toString(currentForecastDateObject.getInt("day"))+"/"+Integer.toString(currentForecastDateObject.getInt("year")) );
 newForecast.setHighTemp(Float.parseFloat(currentSimpleForecastObject.getJSONObject("high").getString("fahrenheit")));
 newForecast.setLowTemp(Float.parseFloat(currentSimpleForecastObject.getJSONObject("low").getString("fahrenheit")));
 newForecast.setDayOfWeek(currentForecastDateObject.getString("weekday_short"));
 */
#import <Foundation/Foundation.h>

@interface DWeatherWeatherForecastDay : NSObject
@property(nonatomic,strong)NSNumber *lowTemp;
@property(nonatomic,strong)NSNumber *highTemp;
@property(nonatomic,strong)NSNumber *currentTemp;
@property(nonatomic,strong)NSString *dayOfWeek;
@property(nonatomic,strong)NSString *forecastDay;
@property(nonatomic,strong)NSString *forecastIconPath;
@property(nonatomic,strong)NSString *forecastCondition;
@property(nonatomic,strong)NSString *forecastWindText;
@property(nonatomic,strong)NSString *currentLocation;
@end