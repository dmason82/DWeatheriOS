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
    }
}
@end
