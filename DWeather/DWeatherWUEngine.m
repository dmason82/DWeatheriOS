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
    NSDictionary *JSONAutoComplete = [JSONResponse objectForKey:@"response"];
    NSLog(@"%@",JSONAutoComplete);
    NSArray* cityList = [JSONAutoComplete objectForKey:@"results"];
    if(cityList !=nil){
        _isAutocomplete = YES;
        return cityList;
    }
    else{
//        NSDictionary *JSONResponse = [self obtainJSONForURL:weatherRequestCurrentString];
       NSLog(@"%@", JSONResponse);
        NSDictionary *currentObservations = [JSONResponse objectForKey:@"current_observation"];
        NSDictionary *currentLocation = [currentObservations objectForKey:@"display_location"];
        DWeatherCurrentConditions* current = [[DWeatherCurrentConditions alloc] init];
        current.dateString = [[currentObservations objectForKey:@"local_time_rfc822"] substringToIndex:3];
        current.currentTemperature = [currentObservations objectForKey:@"temp_f"];
        current.iconPath = [currentObservations objectForKey:@"icon_url"];
        current.cityString = [currentLocation objectForKey:@"full"];
        current.windMPH = [currentObservations objectForKey:@"wind_mph"];
        current.windDirection =[currentObservations objectForKey:@"wind_dir"];
        current.humidityString = [currentObservations objectForKey:@"relative_humidity"];
        current.visibilityMi = [currentObservations objectForKey:@"visibility_mi"];
        current.windGustMPH = [currentObservations objectForKey:@"wind_gust_mph"];
        current.percipitationTodayIn = [currentObservations objectForKey:@"parcip_today_in"];
        current.conditionsString = [NSString stringWithFormat:@"%@",[[currentObservations objectForKey:@"weather"] description]];
        [array addObject:current];
        _isAutocomplete = false;
        return array;
    }

}
/**
 */
-(NSArray *)obtainForecastConditions:(NSString*)weatherLocation
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
     NSString* locationRequestString = [weatherLocation stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString* weatherForecastRequestString = [@"http://api.wunderground.com/api/" stringByAppendingFormat:@"%@/forecast/q/%@.json",_API_KEY,locationRequestString];
    NSDictionary *JSONResponse = [[self obtainJSONForURL:weatherForecastRequestString] objectForKey:@"forecast"];
    NSArray *forecastTxtArray = [[JSONResponse objectForKey:@"txt_forecast"] objectForKey:@"forecastday"];
    NSArray* forecastSimpleArray = [[JSONResponse objectForKey:@"simpleforecast"] objectForKey:@"forecastday"];
    
    for (int i = 0; i < [forecastSimpleArray count] ;i++) {
        NSDictionary * forecastConditions = [forecastTxtArray objectAtIndex:i];
        NSDictionary * forecastSimpleConditions = [forecastSimpleArray objectAtIndex:i];
        DWeatherWeatherForecastDay *newDay = [[DWeatherWeatherForecastDay alloc] init];
        newDay.forecastDay = [@"" stringByAppendingFormat:@"%@/%@/%@",[forecastConditions objectForKey:@"month"],[forecastConditions objectForKey:@"day"],[forecastConditions objectForKey:@"year"]];
        newDay.forecastIconPath = [forecastSimpleConditions objectForKey:@"icon_url"];
        newDay.forecastCondition = [[forecastSimpleConditions objectForKey:@"conditions"] description];
        newDay.highTemp = [[forecastSimpleConditions objectForKey:@"high"] objectForKey:@"fahrenheit"];
        newDay.lowTemp = [[forecastSimpleConditions objectForKey:@"low"] objectForKey:@"fahrenheit"];
        newDay.dayOfWeek = [[forecastSimpleConditions objectForKey:@"date"] objectForKey:@"weekday_short"] ;
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
