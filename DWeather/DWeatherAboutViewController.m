//
//  DWeatherAboutViewController.m
//  DWeather
//
//  Created by Doug Mason on 12/25/12.
//  Copyright (c) 2012 Doug Mason. All rights reserved.
//

#import "DWeatherAboutViewController.h"

@interface DWeatherAboutViewController ()
{
    
}

@end

@implementation DWeatherAboutViewController

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
    [super viewDidLoad];
    NSDictionary* fontAtributes = @{NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Oblique" size:17.0]};
    NSDictionary* titleAtributes = @{NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:19.0]};
    
    NSAttributedString* versionString = [[NSAttributedString alloc] initWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] attributes:fontAtributes];
    NSAttributedString* appNameString = [[NSAttributedString alloc] initWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] attributes:titleAtributes];
    
    [_appVersionLabel setAttributedText:versionString];
    [_appNameLabel setAttributedText:appNameString];
    [_appNameLabel setTextAlignment:NSTextAlignmentCenter];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Utility functions
-(IBAction)goToWunderground:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.wunderground.com"]];
}
@end
