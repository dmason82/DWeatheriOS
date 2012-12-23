//
//  DWeatherCurrentConditions.h
//  DWeather
//
//  Created by Doug Mason on 9/15/12.
//  Copyright (c) 2012 Doug Mason. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 String currentDate = currentObject.getString("observation_time_rfc822");
 currentConditions.setDayOfWeek(currentDate.substring(0, currentDate.indexOf(",")));
 currentConditions.setTemp(Float.parseFloat(currentObject.getString("temp_f")));
 currentConditions.setIconPath(currentObject.getString("icon_url"));
 currentConditions.setCity(currentLocation.getString("full"));
 currentConditions.setHumidity(currentObject.getString("relative_humidity"));
 currentConditions.setWind(currentObject.getString("wind_string"));*/
@interface DWeatherCurrentConditions : NSObject
@property(nonatomic,strong)NSString* dateString;
@property(nonatomic,strong)NSNumber* currentTemperature;
@property(nonatomic,strong)NSString* iconPath;
@property(nonatomic,strong)NSString* cityString;
@property(nonatomic,strong)NSString* humidityString;
@property(nonatomic,strong)NSNumber* windMPH;
@property(nonatomic,strong)NSString* windDirection;
@property(nonatomic,strong)NSString* conditionsString;
@property(nonatomic,strong)NSNumber* feelsLikeTemperature;
@property(nonatomic,strong)NSNumber* windGustMPH;
@property(nonatomic,strong)NSNumber* visibilityMi;
@property(nonatomic,strong)NSNumber* percipitationTodayIn;
@end
