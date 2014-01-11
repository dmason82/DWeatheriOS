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
#import "DWeatherTableViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
@interface DWeatherViewController ()
@property(nonatomic,retain)NSArray *autoComplete;
-(void)updateLocationOnTimer:(NSTimer*)timer;
-(void)dismissKeyboard:(id)sender;
@end

@implementation DWeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _engine = [[DWeatherWUEngine alloc] init];
    _appDefaults = [NSUserDefaults standardUserDefaults];
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    [_locationTextField setDelegate:self];
    if ([_appDefaults objectForKey:@"savedLocation"]){
        [_locationTextField setText:[_appDefaults objectForKey:@"savedLocation"]];
    }
    if([_appDefaults integerForKey:@"savedUnits"] ==1){
        self.isMetric = [NSNumber numberWithInt:[_appDefaults integerForKey:@"savedUnits"]];
        [self.isMetric isEqualToNumber:@0]?[self.unitsSegment setSelectedSegmentIndex:0]:[self.unitsSegment setSelectedSegmentIndex:1];
    }
    else{
        self.isMetric = @0;
    }
    if([[_appDefaults objectForKey:@"currentLocation"] isEqualToString:@"Yes"]){
        [self.locationSwitch setOn:YES];
        [self toggleLocation:self.locationSwitch];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(updateLocationOnTimer:) userInfo:nil repeats:YES];
    }
    else{
        [self.locationSwitch setOn:NO];
    }
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl setTintColor:[UIColor blueColor]];
    [refreshControl addTarget:_controller action:@selector(fetchWeather) forControlEvents:UIControlEventValueChanged];
    self.controller = [[DWeatherTableViewController alloc] init];
    [self.controller setTableView:_weatherConditionsTable];
    [self.controller setRefreshControl:refreshControl];
    [self.controller setController:self];
    [self checkConnectivity];
    _fetchButton.layer.borderWidth=1.0f;
    _fetchButton.layer.borderColor=[[UIColor blackColor] CGColor];
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:recognizer];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setLocationLabel:nil];
    [self setWeatherConditionsTable:nil];
    [self setUnitsSegment:nil];
    [self setLocationSwitch:nil];
    [self setEnterLocationLabel:nil];
    [self setFetchButton:nil];
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
        NSOperationQueue* queue = [NSOperationQueue new];
        NSInvocationOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(obtainWeatherWithOperation) object:nil];
        [queue addOperation:operation];
        
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
        NSNumber* currentTemp = [self.isMetric isEqualToNumber:@0]?current.currentTemperatureF:current.currentTemperatureC;
        cell.temperatureLabel.text = [[currentTemp stringValue] stringByAppendingFormat:@"°%@",([self.isMetric isEqualToNumber:@1]?@"C":@"F") ];
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
        NSNumber* highTemp = [self.isMetric isEqualToNumber:@0]?day.highTempF:day.highTempC;
        NSNumber* lowTemp = [self.isMetric isEqualToNumber:@0]?day.lowTempF:day.lowTempC;
        cell.highTempLabel.text = [NSString stringWithFormat:@"%@°%@",highTemp,[self.isMetric isEqualToNumber:@0]?@"F":@"C"];
        cell.lowTempLabel.text = [NSString stringWithFormat:@"%@°%@",lowTemp,[self.isMetric isEqualToNumber:@0]?@"F":@"C"];
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

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView:(UIPickerView *)pickerView{
//    return 1;
//}

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
        [controller setIsMetric:_isMetric];
//        [(DWeatherCurrentDetailsViewController*)segue.destinationViewController setPrevious:self];
    }
    else if([[segue identifier] isEqualToString:@"forecastDetailSegue"]){
        NSIndexPath* index = (NSIndexPath*)sender;
        DWeatherWeatherForecastDay* day = (DWeatherWeatherForecastDay*)[self.forecastWeather objectAtIndex:index.row];
        DWeatherForecastConditionsViewController* controller =(DWeatherForecastConditionsViewController*)[segue destinationViewController];
        [controller setDetailItem:day];
        [controller setCityLocation:[NSString stringWithFormat:@"%@",[((DWeatherCurrentConditions*)[self.currentWeather objectAtIndex:0]) cityString]]];
        [controller setIsMetric:_isMetric];
    }
}
#pragma mark - UIActionSheetDelegate methods
-(void)actionSheetCancel:(UIActionSheet *)actionSheet{
    _locationTextField.text = @"";
}



#pragma mark - UIBarButtonItem responders
- (IBAction)toggleLocation:(UISwitch*)sender {
    NSLog(@"Location switch toggled");
    if(sender.on ==YES){
        [self.manager startUpdatingLocation];
        [_appDefaults setValue:@"Yes" forKey:@"currentLocation"];
        [_appDefaults synchronize];
        [_locationTextField setEnabled:NO];
        [_locationTextField setBackgroundColor:[UIColor grayColor]];
        [_fetchButton setHidden:YES];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:6000 target:self selector:@selector(updateLocationOnTimer:) userInfo:nil repeats:YES];
        NSLog(@"Starting location manager");
    }
    else{
        if(self.manager)
        {
            [self.manager stopUpdatingLocation];
            [_locationTextField setEnabled:YES];
            [_locationTextField setBackgroundColor:[UIColor whiteColor]];
            [_fetchButton setHidden:NO];
            [_locationTextField setHidden:NO];
            
        }
        [self.timer invalidate];
        [_appDefaults setValue:@"No" forKey:@"currentLocation"];
        [_appDefaults synchronize];
    }
}

-(IBAction)aboutApp:(id)sender{
    [self performSegueWithIdentifier:@"aboutAppSegue" sender:self];
}

- (IBAction)toggleUnits:(id)sender {
    if([self.unitsSegment selectedSegmentIndex]==1){
        self.isMetric = @1;
        [_appDefaults setInteger:1 forKey:@"savedUnits"];
        [self.weatherConditionsTable reloadData];
    }
    else{
        self.isMetric = @0;
        [_appDefaults setInteger:0 forKey:@"savedUnits"];
        [self.unitsButton setSelected:NO];
        [self.weatherConditionsTable reloadData];
    }
}


#pragma mark - Network diagnostics
-(void)checkConnectivity{
    //Commenting out code due to Apple bug 12443370 , this is erroneous for 3G/4G connections
//    CFNetDiagnosticRef diag;
//    diag = CFNetDiagnosticCreateWithURL(kCFAllocatorDefault, (__bridge CFURLRef)[NSURL URLWithString:@"http://www.wunderground.com"]);
//    CFNetDiagnosticStatus results = CFNetDiagnosticCopyNetworkStatusPassively(diag, NULL);
//    NSLog(@"%ld %d",results,kCFNetDiagnosticConnectionDown);
//    if(results == kCFNetDiagnosticConnectionUp){
//        return YES;
//    }
//    else if(results==kCFNetDiagnosticConnectionDown){
//        return NO;
//    }
//    else{
//        return YES;
//    }
    NSURL* url = [NSURL URLWithString:@"http://www.wunderground.com"];
    NSURLConnection* connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    NSLog(@"%@",connection);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Network connection error!" message:@"Application requires a network connection to fetch weather data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(void)updateTable{
    [_weatherConditionsTable reloadData];
    [_controller.refreshControl endRefreshing];
}

-(void)obtainWeatherWithOperation{
    self.forecastWeather = [self.engine obtainForecastConditions:self.locationTextField.text];
    NSString* weatherString = @"Weather for:";
    weatherString = [weatherString stringByAppendingFormat:@" %@",((DWeatherCurrentConditions*)[self.currentWeather objectAtIndex:0]).cityString];
    [self.locationLabel performSelectorOnMainThread:@selector(setText:) withObject:weatherString waitUntilDone:YES];
    [self.weatherConditionsTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.lastKnownLocation = newLocation;
    CLGeocoder* coder = [[CLGeocoder alloc] init];

    [coder reverseGeocodeLocation:newLocation completionHandler:^(NSArray* placemarks,NSError* error)
    {
        if(placemarks.count > 0)
        {
            [manager stopUpdatingLocation];
            CLPlacemark* place = [placemarks objectAtIndex:0];
            self.locationTextField.text = [NSString stringWithFormat:@"%@ %@",place.locality,place.administrativeArea];
            [self fetchWeather];
            
        }
        else{
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Location error!" message:@"I was unable to determine your location" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            [self.manager stopUpdatingLocation];
            [self.locationSwitch setOn:NO];
        }
    }];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"Locations: %@",locations.description);
    if (locations.count > 0) {
        CLLocation* newLoc = [locations objectAtIndex:0];
        CLGeocoder* coder = [[CLGeocoder alloc] init];
        [manager stopUpdatingLocation];
        [coder reverseGeocodeLocation:newLoc completionHandler:^(NSArray* placemarks,NSError* error)
         {
             if(placemarks.count > 0)
             {
                 CLPlacemark* place = [placemarks objectAtIndex:0];
                 self.locationTextField.text = [NSString stringWithFormat:@"%@ %@",place.locality,place.administrativeArea];
                 [self fetchWeather];
                 
             }
             else{
                 UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Location error!" message:@"I was unable to determine your location" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 [alertView show];
                 [self.manager stopUpdatingLocation];
             }
         }];
    }
}

-(void)updateLocationOnTimer:(NSTimer *)timer{
    [self.manager startUpdatingLocation];
}
-(void)dismissKeyboard:(id)sender{
    [self.locationTextField resignFirstResponder];
}
@end
