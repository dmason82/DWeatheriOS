//
//  DWeatherForecastConditionsCell.h
//  DWeather
//
//  Created by Doug Mason on 9/15/12.
//  Copyright (c) 2012 Doug Mason. All rights reserved.
//
/*
 JSONObject currentForecastDateObject = currentSimpleForecastObject.getJSONObject("date");
 newForecast.setIconPath(currentSimpleForecastObject.getString("icon_url"));
 newForecast.setCondition(currentSimpleForecastObject.getString("conditions"));
 newForecast.setDay(Integer.toString(currentForecastDateObject.getInt("month"))+"/"+Integer.toString(currentForecastDateObject.getInt("day"))+"/"+Integer.toString(currentForecastDateObject.getInt("year")) );
 newForecast.setHighTemp(Float.parseFloat(currentSimpleForecastObject.getJSONObject("high").getString("fahrenheit")));
 newForecast.setLowTemp(Float.parseFloat(currentSimpleForecastObject.getJSONObject("low").getString("fahrenheit")));
 newForecast.setDayOfWeek(currentForecastDateObject.getString("weekday_short"));
 */
#import <UIKit/UIKit.h>

@interface DWeatherForecastConditionsCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *highTempLabel;
@property(nonatomic,weak)IBOutlet UILabel *lowTempLabel;
@property(nonatomic,weak)IBOutlet UIImageView *forecastIcon;
@property(nonatomic,weak)IBOutlet UILabel *conditionLabel;
@property(nonatomic,weak)IBOutlet UILabel *dayOfWeekLabel;
@end
