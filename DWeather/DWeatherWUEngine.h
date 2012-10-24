//
//  DWeatherWUEngine.h
//  DWeather
//
//  Created by Doug Mason on 9/8/12.
//  Copyright (c) 2012 Doug Mason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWeatherWUEngine : NSObject <NSURLConnectionDelegate>

@property (strong)NSMutableData* JSONData;
@property(strong) NSString* API_KEY;
@property(nonatomic)BOOL isAutocomplete;
-(NSArray*)obtainCurrentConditions:(NSString *)weatherLocation;
-(NSArray *)obtainForecastConditions:(NSString*)weatherLocation;
-(id)obtainJSONForURL:(NSString*) URL;

@end
