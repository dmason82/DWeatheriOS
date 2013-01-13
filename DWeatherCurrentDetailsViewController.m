//
//  DWeatherCurrentDetailsViewController.m
//  DWeather
//
//  Created by Doug Mason on 12/22/12.
//  Copyright (c) 2012 Doug Mason. All rights reserved.
//

#import "DWeatherCurrentDetailsViewController.h"
#import "DWeatherViewController.h"
#import "DWeatherCurrentConditions.h"
@interface DWeatherCurrentDetailsViewController ()

@end

@implementation DWeatherCurrentDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self configureDisplay];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)configureDisplay{
    if(self.detailItem){
        //font attribute configurations
        NSDictionary* fontAtributes = @{NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Oblique" size:17.0]};
        NSDictionary* boldFontAtributes = @{NSFontAttributeName : [UIFont fontWithName:@"Helvetica-BoldOblique" size:17.0]};
        //Attributed text
        
        NSAttributedString* tempAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\u00B0F",self.detailItem.currentTemperatureF.description] attributes:fontAtributes];
        NSAttributedString* cityAttributedString = [[NSAttributedString alloc] initWithString:self.detailItem.cityString attributes:fontAtributes];
        NSAttributedString* humidityAttributedString = [[NSAttributedString alloc] initWithString:self.detailItem.humidityString attributes:fontAtributes];
        NSAttributedString* windAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ MPH to the %@",self.detailItem.windMPH,self.detailItem.windDirection] attributes:fontAtributes];
        NSAttributedString* conditionAttributedString = [[NSAttributedString alloc] initWithString:self.detailItem.conditionsString attributes:boldFontAtributes];
        NSAttributedString* precipitationAttributedString = [self.detailItem.precipitationTodayIn floatValue]!=-999.00?[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f inches",[self.detailItem.precipitationTodayIn floatValue]] attributes:fontAtributes]:[[NSAttributedString alloc] initWithString:@"No data" attributes:fontAtributes];
        NSAttributedString* feelsLikeAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d\u00B0F ",[self.detailItem.feelsLikeTemperature intValue]] attributes:fontAtributes];
        NSAttributedString* windGustsAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f MPH",[self.detailItem.windGustMPH floatValue]] attributes:fontAtributes];
        NSAttributedString* visibilityAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f miles",[self.detailItem.visibilityMi floatValue]] attributes:fontAtributes];
        //Assignment for attributed text objects
        [_currentTemperatureLabel setAttributedText:tempAttributedString];
        [_currentCityLabel setAttributedText:cityAttributedString];
        [_currentCityLabel setTextAlignment:NSTextAlignmentCenter];
        [_currentHumidityLabel setAttributedText:humidityAttributedString];
        [_currentWindLabel setAttributedText:windAttributedString];
        [_currentConditionsLabel setAttributedText:conditionAttributedString];
        [_currentConditionsLabel setTextAlignment:NSTextAlignmentCenter];
        [_currentRainfallTodayLabel setAttributedText:precipitationAttributedString];
        [_currentFeelsLikeLabel setAttributedText:feelsLikeAttributedString];
        [_currentWindGustsLabel setAttributedText:windGustsAttributedString];
        [_currentVisibilityLabel setAttributedText:visibilityAttributedString];
        //Image assignment
        [_currentConditionsPicture setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.detailItem.iconPath]]]];
        
    }
}
- (void)viewDidUnload {
    [self setCurrentCityLabel:nil];
    [self setCurrentVisibilityLabel:nil];
    [self setCurrentWindGustsLabel:nil];
    [self setCurrentConditionsPicture:nil];
    [self setCurrentRainfallTodayLabel:nil];
    [self setCurrentConditionsLabel:nil];
    [super viewDidUnload];
}
@end
