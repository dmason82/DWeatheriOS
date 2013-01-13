//
//  DWeatherForecastConditionsViewController.m
//  DWeather
//
//  Created by Doug Mason on 12/22/12.
//  Copyright (c) 2012 Doug Mason. All rights reserved.
//

#import "DWeatherForecastConditionsViewController.h"
#import "DWeatherWeatherForecastDay.h"
#import "DWeatherViewController.h"
@interface DWeatherForecastConditionsViewController ()

@end

@implementation DWeatherForecastConditionsViewController

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
    [self configureView];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureView{
    if(self.detailItem){
        [self setTitle:self.detailItem.forecastDay];
        [self.conditionsImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.detailItem.forecastIconPath]]]];
        //Font attributes
        NSDictionary* fontAtributes = @{NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Oblique" size:17.0]};
        NSDictionary* boldFontAtributes = @{NSFontAttributeName : [UIFont fontWithName:@"Helvetica-BoldOblique" size:17.0]};
        //AttributedText strings
        NSAttributedString* conditionString = [[NSAttributedString alloc] initWithString:self.detailItem.forecastCondition attributes:boldFontAtributes];
        NSNumber* highTemp = [self.isMetric isEqualToNumber:@0]?self.detailItem.highTempF:self.detailItem.highTempC;
        NSNumber* lowTemp = [self.isMetric isEqualToNumber:@0]?self.detailItem.lowTempF:self.detailItem.lowTempC;
        NSString* windText = [self.isMetric isEqualToNumber:@0]?self.detailItem.forecastWindTextEnglish:self.detailItem.forecastWindTextMetric;
        NSString* precipitation = [self.isMetric isEqualToNumber:@0]?self.detailItem.forecastPercipitationIn:self.detailItem.forecastPercipitationCm;
        NSAttributedString* highTempString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d\u00B0%@",[highTemp intValue],[self.isMetric isEqualToNumber:@0]?@"F":@"C"] attributes:fontAtributes];
        NSAttributedString* lowTempString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d\u00B0%@",[lowTemp intValue],[self.isMetric isEqualToNumber:@0]?@"F":@"C"] attributes:fontAtributes];
        NSAttributedString* cityAttributedText = [[NSAttributedString alloc] initWithString:self.cityLocation attributes:fontAtributes];
        NSAttributedString* windAttributedString = [[NSAttributedString alloc] initWithString:windText attributes:fontAtributes];
        NSAttributedString* percipitationString = [[NSAttributedString alloc] initWithString:precipitation attributes:fontAtributes];
        NSAttributedString* humidityString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f%%",[self.detailItem.averageHumidity floatValue]] attributes:fontAtributes];
        
        //Label assignments
        [_conditionsLabel setAttributedText:conditionString];
        [_conditionsLabel setTextAlignment:NSTextAlignmentCenter];
        [_forecastHighLabel setAttributedText:highTempString];
        [_forecastLowLabel setAttributedText:lowTempString];
        [_cityText setAttributedText:cityAttributedText];
        [_cityText setTextAlignment:NSTextAlignmentCenter];
        [_averageWindLabel setAttributedText:windAttributedString];
        [_forecastPercipitationLabel setAttributedText:percipitationString];
        [_forecastAverageHumidityLabel setAttributedText:humidityString];
    }
}
- (void)viewDidUnload {
    [self setCityText:nil];
    [self setConditionsImage:nil];
    [self setConditionsImage:nil];
    [self setConditionsLabel:nil];
    [self setForecastHighLabel:nil];
    [self setForecastLowLabel:nil];
    [self setAverageWindLabel:nil];
    [self setForecastPercipitationLabel:nil];
    [self setForecastAverageHumidityLabel:nil];
    [super viewDidUnload];
}
@end
