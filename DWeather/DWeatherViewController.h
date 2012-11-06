//
//  DWeatherViewController.h
//  DWeather
//
//  Created by Doug Mason on 9/8/12.
//  Copyright (c) 2012 Doug Mason. All rights reserved.
//

#import <UIKit/UIKit.h>
NSString* const CITY_KEY = @"city";
@class DWeatherWUEngine;
@interface DWeatherViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)NSArray *weatherDays;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITableView *weatherConditionsTable;
@property(strong,nonatomic)NSArray* currentWeather;
@property(strong,nonatomic)NSArray* forecastWeather;
@property(retain,nonatomic)UIActionSheet* autoCompleteSheet;
@property(nonatomic,strong)DWeatherWUEngine *engine;
@property(nonatomic,weak)IBOutlet UITextField *locationTextField;
-(IBAction)fetchWeather;

@end
