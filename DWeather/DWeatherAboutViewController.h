//
//  DWeatherAboutViewController.h
//  DWeather
//
//  Created by Doug Mason on 12/25/12.
//  Copyright (c) 2012 Doug Mason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWeatherAboutViewController : UIViewController
@property(nonatomic,weak)IBOutlet UILabel* appNameLabel;
@property(nonatomic,weak)IBOutlet UILabel* appVersionLabel;
@property(nonatomic,weak)IBOutlet UIImageView* appIconImage;
@property(nonatomic,weak)IBOutlet UIImageView* wundergroundImage;
-(IBAction)goToWunderground:(id)sender;
@end
