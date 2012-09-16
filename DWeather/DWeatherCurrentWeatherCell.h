//
//  DWeatherCurrentWeatherCell.h
//  DWeather
//
//  Created by Doug Mason on 9/15/12.
//  Copyright (c) 2012 Doug Mason. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 String currentDate = currentObject.getString("observation_time_rfc822");
 currentConditions.setDayOfWeek(currentDate.substring(0, currentDate.indexOf(",")));
 currentConditions.setTemp(Float.parseFloat(currentObject.getString("temp_f")));
 currentConditions.setIconPath(currentObject.getString("icon_url"));
 currentConditions.setCity(currentLocation.getString("full"));
 currentConditions.setHumidity(currentObject.getString("relative_humidity"));
 currentConditions.setWind(currentObject.getString("wind_string"));*/

@interface DWeatherCurrentWeatherCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIImageView *iconView;
@property(nonatomic,weak)IBOutlet UILabel *temperatureLabel;
@property(nonatomic,weak)IBOutlet UILabel *windLabel;
@property(nonatomic,weak)IBOutlet UILabel *dateLabel;
@property(nonatomic,weak)IBOutlet UILabel *humidityLabel;
@property(nonatomic,weak)IBOutlet UILabel *conditionsLabel;
@end
