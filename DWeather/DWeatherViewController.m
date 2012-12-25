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
#import "DWeatherCurrentDetailsViewController.h"
#import "DWeatherForecastConditionsViewController.h"
@interface DWeatherViewController ()
@property(nonatomic,retain)NSArray *autoComplete;
@end

@implementation DWeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _engine = [[DWeatherWUEngine alloc] init];
    _appDefaults = [NSUserDefaults standardUserDefaults];
    [_locationTextField setDelegate:self];
    if ([_appDefaults objectForKey:@"savedLocation"]){
        [_locationTextField setText:[_appDefaults objectForKey:@"savedLocation"]];
        [self fetchWeather];
    }
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
    [_appDefaults setValue:_locationTextField.text forKey:@"savedLocation"];
    [_appDefaults synchronize];
    self.currentWeather = [self.engine obtainCurrentConditions:self.locationTextField.text];
    /**Case in which WUnderground Autocomplete API is instantiated.
     We will bring up a UI Actionsheet 
     */
    if(self.engine.isAutocomplete){
        _autoCompleteSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a City:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
        [_autoCompleteSheet setFrame:CGRectMake(0, 0, 320, 350)];
        UIPickerView *cityPicker = [[UIPickerView alloc] init];
//        _autoComplete = [[((NSDictionary*)_currentWeather) objectForKey:@"response"] objectForKey:@"results"];
        _autoComplete = _currentWeather;
        cityPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 100, 320, 200)];
        cityPicker.delegate=self;
        cityPicker.dataSource=self;
        [_autoCompleteSheet addSubview:cityPicker];
        [_autoCompleteSheet showInView:self.view.window];
        
        [UIView beginAnimations:nil context:nil];
        [_autoCompleteSheet setBounds:CGRectMake(0, 0, 320, 400)];
        [UIView commitAnimations];
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
//        cell.windLabel.text = current.windString;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        return [_currentWeather count];
        
    }
    else{
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

#pragma mark - UIPickerViewDelegate methods
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _locationTextField.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    _autoComplete = nil;
    self.engine.isAutocomplete = NO;
    [_autoCompleteSheet dismissWithClickedButtonIndex:0 animated:YES];
    [self fetchWeather];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString: @"currentDetailSegue"]){
        DWeatherCurrentConditions *current = [_currentWeather objectAtIndex:0];
        DWeatherCurrentDetailsViewController* controller = (DWeatherCurrentDetailsViewController*)segue.destinationViewController;
        [controller setDetailItem:current];
//        [(DWeatherCurrentDetailsViewController*)segue.destinationViewController setPrevious:self];
    }
    else if([[segue identifier] isEqualToString:@"forecastDetailSegue"]){
        NSIndexPath* index = (NSIndexPath*)sender;
        DWeatherWeatherForecastDay* day = (DWeatherWeatherForecastDay*)[self.forecastWeather objectAtIndex:index.row];
        DWeatherForecastConditionsViewController* controller =(DWeatherForecastConditionsViewController*)[segue destinationViewController];
        [controller setDetailItem:day];
        [controller setCityLocation:[NSString stringWithFormat:@"%@",[((DWeatherCurrentConditions*)[self.currentWeather objectAtIndex:0]) cityString]]];
    }
}
#pragma mark - UIActionSheetDelegate methods
-(void)actionSheetCancel:(UIActionSheet *)actionSheet{
    _locationTextField.text = @"";
}



#pragma mark - UIBarButtonItem responders
-(IBAction)aboutApp:(id)sender{
    [self performSegueWithIdentifier:@"aboutAppSegue" sender:self];
}
@end
