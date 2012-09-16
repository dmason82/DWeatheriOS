//
//  DWeatherWUEngine.m
//  DWeather
//
//  Created by Doug Mason on 9/8/12.
//  Copyright (c) 2012 Doug Mason. All rights reserved.
//

#import "DWeatherWUEngine.h"
#import "DWeatherWeatherForecastDay.h"
#import "DWeatherCurrentConditions.h"
/*
 String requestURL = "http://api.wunderground.com/api/"+API_KEY+"/conditions/q/"+location.replace(" ", "%20")+".json";
 String forecastURL = "http://api.wunderground.com/api/"+API_KEY+"/forecast/q/"+location.replace(" ", "%20")+".json";
 */

@implementation DWeatherWUEngine
-(id)init{
    self = [super init];
    _API_KEY = @"26cbe5d65c74086f" ;
    return self;
}
@synthesize JSONData;
-(NSArray*)obtainCurrentConditions:(NSString *)weatherLocation
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    self.JSONData = [[NSMutableData alloc] init];
    NSString* locationRequestString = [weatherLocation stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
   NSString* weatherRequestCurrentString = [@"http://api.wunderground.com/api/" stringByAppendingFormat:@"%@/conditions/q/%@.json",_API_KEY,locationRequestString];

    NSDictionary *JSONResponse = [self obtainJSONForURL:weatherRequestCurrentString];
    NSDictionary *currentObservations = [JSONResponse objectForKey:@"current_observation"];
    NSDictionary *currentLocation = [JSONResponse objectForKey:@"observation_location"];
    NSLog(@"%@",JSONResponse);
    DWeatherCurrentConditions* current = [[DWeatherCurrentConditions alloc] init];
    current.dateString = [[currentObservations objectForKey:@"local_time_rfc822"] substringToIndex:3];
    current.currentTemperature = [currentObservations objectForKey:@"temp_f"];
    current.iconPath = [currentObservations objectForKey:@"icon_url"];
    current.cityString = [currentLocation objectForKey:@"full"];
    current.windString = [currentObservations objectForKey:@"wind_string"];
    current.humidityString = [currentObservations objectForKey:@"relative_humidity"];
    current.conditionsString = [NSString stringWithFormat:@"%@",[[currentObservations objectForKey:@"weather"] description]];
    [array addObject:current];
    return array;
}
/**
 JSONArray forecastArray = forecastObject.getJSONObject("txt_forecast").getJSONArray("forecastday");
 JSONArray simpleForecastArray = forecastObject.getJSONObject("simpleforecast").getJSONArray("forecastday");
 
 ForecastWeather newForecast = new ForecastWeather();
 JSONObject currentSimpleForecastObject = simpleForecastArray.getJSONObject(i);
 JSONObject currentForecastDateObject = currentSimpleForecastObject.getJSONObject("date");
 newForecast.setIconPath(currentSimpleForecastObject.getString("icon_url"));
 newForecast.setCondition(currentSimpleForecastObject.getString("conditions"));
 newForecast.setDay(Integer.toString(currentForecastDateObject.getInt("month"))+"/"+Integer.toString(currentForecastDateObject.getInt("day"))+"/"+Integer.toString(currentForecastDateObject.getInt("year")) );
 newForecast.setHighTemp(Float.parseFloat(currentSimpleForecastObject.getJSONObject("high").getString("fahrenheit")));
 newForecast.setLowTemp(Float.parseFloat(currentSimpleForecastObject.getJSONObject("low").getString("fahrenheit")));
 newForecast.setDayOfWeek(currentForecastDateObject.getString("weekday_short"));
 forecastArrayList.add(newForecast);
 */
-(NSArray *)obtainForecastConditions:(NSString*)weatherLocation
{
    
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
     NSString* locationRequestString = [weatherLocation stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString* weatherForecastRequestString = [@"http://api.wunderground.com/api/" stringByAppendingFormat:@"%@/forecast/q/%@.json",_API_KEY,locationRequestString];
    
    NSDictionary *JSONResponse = [self obtainJSONForURL:weatherForecastRequestString];
    NSArray *forecastTxtArray = [[JSONResponse objectForKey:@"txt_forecast"] objectForKey:@"forecastday"];
    NSArray* forecastSimpleArray = [[JSONResponse objectForKey:@"simpleforecast"] objectForKey:@"forecastday"];
//    NSLog(@"%@",JSONResponse);
    for (int i = 0; i < [forecastTxtArray count] ;i++) {
        NSDictionary * forecastConditions = [forecastTxtArray objectAtIndex:i];
        NSDictionary * forecastSimpleConditions = [forecastSimpleArray objectAtIndex:i];
        DWeatherWeatherForecastDay *newDay = [[DWeatherWeatherForecastDay alloc] init];
        newDay.forecastDay = [@"" stringByAppendingFormat:@"%@/%@/%@",[forecastConditions objectForKey:@"month"],[forecastConditions objectForKey:@"day"],[forecastConditions objectForKey:@"year"]];
        newDay.forecastCondition = [forecastSimpleConditions objectForKey:@"conditions"];
        newDay.highTemp = [[forecastSimpleConditions objectForKey:@"high"] objectForKey:@"fahrenheit"];
        newDay.lowTemp = [[forecastSimpleConditions objectForKey:@"low"] objectForKey:@"fahrenheit"];
        newDay.dayOfWeek = [forecastConditions objectForKey:@"weekday_short"];
        [returnArray addObject:newDay];
    }
    return returnArray;
    
}
-(id)obtainJSONForURL:(NSString *)URL
{
   NSURL* weatherRequestURL = [NSURL URLWithString:URL];
    NSData* data = [NSData dataWithContentsOfURL:weatherRequestURL];
    self.JSONData = [data mutableCopy];
    id returnJSONObject = nil;
    returnJSONObject = [NSJSONSerialization JSONObjectWithData:self.JSONData options:NSJSONReadingMutableContainers error:nil];
    return returnJSONObject;
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.JSONData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Unable to connect." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end
