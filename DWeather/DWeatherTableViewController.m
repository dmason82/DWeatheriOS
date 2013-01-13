//
//  DWeatherTableViewController.m
//  DWeather
//
//  Created by Doug Mason on 1/8/13.
//  Copyright (c) 2013 Doug Mason. All rights reserved.
//
#import "DWeatherTableViewController.h"
#import "DWeatherCurrentWeatherCell.h"
#import "DWeatherForecastConditionsCell.h"
#import "DWeatherCurrentConditions.h"
#import "DWeatherWeatherForecastDay.h"
#import "DWeatherWUEngine.h"
@interface DWeatherTableViewController ()

@end

@implementation DWeatherTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/**We have 2 sections, current conditions and weather forecast.
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

/**Fairly self explanitory, creates a title for each section in our Table.
 */
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(section == 0)
    {
        return @"Current conditions";
    }
    else{
        return @"Forecasted conditions";
    }
}
/**Creates our cells for each object for the tableview
 */
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If we are in the current conditions section
    if(indexPath.section == 0){
        //So glad with the new XCode/iOS changes that we don't have to check against nil for this
        DWeatherCurrentWeatherCell* cell = [tableView dequeueReusableCellWithIdentifier:@"currentConditionsCell"];
        DWeatherCurrentConditions *current = [self.controller.currentWeather objectAtIndex:indexPath.row];
        cell.dateLabel.text = current.dateString;
        cell.iconView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:current.iconPath]]];
        cell.humidityLabel.text = current.humidityString;
        NSNumber* currentTemp = [self.controller.isMetric isEqualToNumber:@0]?current.currentTemperatureF:current.currentTemperatureC;
        cell.temperatureLabel.text = [[currentTemp stringValue] stringByAppendingFormat:@"°%@",[self.controller.isMetric isEqualToNumber:@0]?@"F":@"C" ];
        cell.conditionsLabel.text = current.conditionsString;
        //        cell.windLabel.text = current.windString;
        return cell;
    }
    //If we are in the weather forecast section
    else{
        DWeatherForecastConditionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forecastConditionsCell"];
        DWeatherWeatherForecastDay *day = [self.controller.forecastWeather objectAtIndex:indexPath.row];
        cell.dayOfWeekLabel.text = day.dayOfWeek;
        cell.forecastIcon.image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:day.forecastIconPath]]];
        NSNumber* highTemp = [self.controller.isMetric isEqualToNumber:@0]?day.highTempF:day.highTempC;
        NSNumber* lowTemp = [self.controller.isMetric isEqualToNumber:@0]?day.lowTempF:day.lowTempC;
        cell.highTempLabel.text = [NSString stringWithFormat:@"%@°%@",highTemp,[self.controller.isMetric isEqualToNumber:@0]?@"F":@"C"];
        cell.lowTempLabel.text = [NSString stringWithFormat:@"%@°%@",lowTemp,[self.controller.isMetric isEqualToNumber:@0]?@"F":@"C"];
        cell.conditionLabel.text = day.forecastCondition;
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.section) {
        case 0:
            [self performSegueWithIdentifier:@"currentDetailSegue" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"forecastDetailSegue" sender:indexPath];
            break;
        default:
            break;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section ==0){
        return [self.controller.currentWeather count];
        
    }
    else{
        return [self.controller.forecastWeather count];
    }
}
-(void)fetchWeather
{
    [self.controller.locationTextField resignFirstResponder];
    [self.controller.appDefaults setValue:self.controller.locationTextField.text forKey:@"savedLocation"];
    [self.controller.appDefaults synchronize];
//    self.controller.currentWeather = [self.controller.engine obtainCurrentConditions: self.controller.locationTextField.text];
    /**Case in which WUnderground Autocomplete API is instantiated.
     We will bring up a UI Actionsheet
     */
    if(self.controller.engine.isAutocomplete){
        self.controller.autoCompleteSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a City:" delegate:self.controller cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
        [self.controller.autoCompleteSheet setFrame:CGRectMake(0, 0, 320, 350)];
        UIPickerView *cityPicker = [[UIPickerView alloc] init];
        //        _autoComplete = [[((NSDictionary*)_currentWeather) objectForKey:@"response"] objectForKey:@"results"];
        cityPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 100, 320, 200)];
        cityPicker.delegate=_controller;
        cityPicker.dataSource=_controller;
        [self.controller.autoCompleteSheet addSubview:cityPicker];
        [self.controller.autoCompleteSheet showInView:self.view.window];
        [UIView beginAnimations:nil context:nil];
        [self.controller.autoCompleteSheet setBounds:CGRectMake(0, 0, 320, 400)];
        [UIView commitAnimations];
    }else{
        NSOperationQueue* queue = [NSOperationQueue new];
        NSInvocationOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fetchWeatherWithOperation) object:nil];
        [queue addOperation:operation];
    }
    
}

-(void)fetchWeatherWithOperation{
    self.controller.forecastWeather = [self.controller.engine obtainForecastConditions:self.controller.locationTextField.text];
    NSString* weatherString = @"Weather for:";
    weatherString = [weatherString stringByAppendingFormat:@" %@",((DWeatherCurrentConditions*)[self.controller.currentWeather objectAtIndex:0]).cityString];
    [self.controller.locationLabel performSelectorOnMainThread:@selector(setText:) withObject:weatherString waitUntilDone:YES];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    //        self.controller.locationLabel setText:self.
    [self.refreshControl performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:YES];
}
@end
