//
//  DWeatherWUEngine.h
//  DWeather
//
//  Created by Doug Mason on 9/8/12.
//  Copyright (c) 2012 Doug Mason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWeatherWUEngine : NSObject <NSURLConnectionDelegate>
+(NSArray*)obtainWeather:(NSString*)weatherLocation;

@end
