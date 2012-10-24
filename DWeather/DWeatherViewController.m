//
//  DWeatherViewController.m
//  DWeather
//
//  Created by Doug Mason on 9/8/12.
//  Copyright (c) 2012 Doug Mason. All rights reserved.
//

#import "DWeatherViewController.h"
#import "DWeatherWUEngine.h"
#import "DWeatherCurrentConditions.h"
#import "DWeatherWeatherForecastDay.h"
#import "DWeatherCurrentWeatherCell.h"
#import "DWeatherForecastConditionsCell.h"
@interface DWeatherViewController ()
@property(nonatomic,retain)NSArray *autoComplete;
@end

@implementation DWeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _engine = [[DWeatherWUEngine alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setLocationLabel:nil];
    [self setWeatherConditionsTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

/** fetches our weather information and then places them within the model enclosed with this controller. Being at this point two NSArray* objects to describe our current conditions and forecast conditions.. This also allows us to use our UITableViewDatasource methods to bind between the weather info and our UITableView.
 */
-(IBAction)fetchWeather
{
    [self.locationTextField resignFirstResponder];
    self.currentWeather = [self.engine obtainCurrentConditions:self.locationTextField.text];
    /**Case in which WUnderground Autocomplete API is instantiated.
     We will bring up a UI Actionsheet 
     */
    if(self.engine.isAutocomplete){
        NSLog(@"%@",self.currentWeather);
        UIActionSheet *autoCompleteSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a City:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"OK", nil];
        UIPickerView *cityPicker = [[UIPickerView alloc] init];
        _autoComplete = [(NSDictionary*)_currentWeather objectForKey:@"results"];
        NSLog(@"%@",_autoComplete);
        cityPicker.delegate=self;
        cityPicker.dataSource=self;
        [autoCompleteSheet addSubview:cityPicker];
        [autoCompleteSheet showFromRect:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height/2) inView:self.view animated:YES];
        
        
    }else{
        self.forecastWeather = [self.engine obtainForecastConditions:self.locationTextField.text];
        self.locationLabel.text = [@"Weather for:" stringByAppendingFormat:@" %@",((DWeatherCurrentConditions*)[_currentWeather objectAtIndex:0]).cityString];
        [_weatherConditionsTable reloadData];
        
    }

}

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
        DWeatherCurrentConditions *current = [_currentWeather objectAtIndex:indexPath.row];
        cell.dateLabel.text = current.dateString;
        cell.iconView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:current.iconPath]]];
        cell.humidityLabel.text = current.humidityString;
        cell.temperatureLabel.text = [[current.currentTemperature stringValue] stringByAppendingFormat:@"%@",@"°F" ];
        cell.conditionsLabel.text = current.conditionsString;
        cell.windLabel.text = current.windString;
        return cell;
    }
    //If we are in the weather forecast section
    else{
        DWeatherForecastConditionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forecastConditionsCell"];
        DWeatherWeatherForecastDay *day = [_forecastWeather objectAtIndex:indexPath.row];
        cell.dayOfWeekLabel.text = day.dayOfWeek;
        cell.forecastIcon.image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:day.forecastIconPath]]];
        cell.highTempLabel.text = [NSString stringWithFormat:@"%@°F",day.highTemp];
        cell.lowTempLabel.text = [NSString stringWithFormat:@"%@°F",day.lowTemp];
        cell.conditionLabel.text = day.forecastCondition;
        return cell;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section ==0){
        return [_currentWeather count];
        
    }
    else{
        NSLog(@"%d",_forecastWeather.count);
        return [_forecastWeather count];
    }
}



#pragma mark -UITextFieldDelegate Methods
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self fetchWeather];
    return YES;
}



#pragma mark - UIPickerViewDatasource methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return [_autoComplete count];
    }
    else{
        return 1;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component{
//    return [[[_autoComplete objectAtIndex:row] objectForKey:@"City"] stringByAppendingFormat:@",%@",[[_autoComplete objectAtIndex:row] objectForKey:@"State"] ];
//    return [self.currentWeather ];
    NSString* returnString = @"";
    return [returnString stringByAppendingFormat:@"%@, %@",[(NSDictionary*)[_autoComplete objectAtIndex:row] objectForKey:@"city"],[(NSDictionary*)[_autoComplete objectAtIndex:row] objectForKey:@"state"]  ];
}
@end
