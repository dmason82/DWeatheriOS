//
//  DWeatherViewController.h
//  DWeather
//
//  Created by Doug Mason on 9/8/12.
//  Copyright (c) 2012 Doug Mason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
//NSString* const CITY_KEY = @"city";
@class DWeatherWUEngine,DWeatherTableViewController;
@interface DWeatherViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,NSURLConnectionDelegate,CLLocationManagerDelegate>
@property(nonatomic,strong)NSArray *weatherDays;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITableView *weatherConditionsTable;
@property(strong,nonatomic)NSArray* currentWeather;
@property(strong,nonatomic)NSArray* forecastWeather;
@property(retain,nonatomic)UIActionSheet* autoCompleteSheet;
@property(nonatomic,strong)DWeatherWUEngine *engine;
@property(nonatomic,weak)IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitsSegment;
@property (weak, nonatomic) IBOutlet UIButton *unitsButton;
@property (weak, nonatomic) IBOutlet UIButton *fetchButton;
@property(nonatomic,strong)NSUserDefaults* appDefaults;
@property(nonatomic,retain)NSNumber* isMetric;
@property(nonatomic,retain)CLLocationManager *manager;
@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,retain)CLLocation* lastKnownLocation;
@property(nonatomic,strong)DWeatherTableViewController* controller;
@property (weak, nonatomic) IBOutlet UILabel *enterLocationLabel;
-(IBAction)fetchWeather;
- (IBAction)toggleUnits:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;
- (IBAction)toggleLocation:(id)sender;
-(IBAction)aboutApp:(id)sender;
-(void)obtainWeatherWithOperation;
@end
