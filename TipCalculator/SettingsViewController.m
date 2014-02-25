//
//  SettingsViewController.m
//  TipCalculator
//
//  Created by Eric Socolofsky on 2/23/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTipControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *backgroundColorControl;

@property (strong, atomic) NSArray *tipValues;
@property (strong, atomic) NSArray *backgroundColors;

- (IBAction)defaultTipChanged:(id)sender;
- (IBAction)backgroundColorChanged:(id)sender;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
		self.tipValues = @[@(0.10), @(0.15), @(0.20)];
		self.backgroundColors = @[
			[UIColor colorWithRed:24.0/255.0 green:174.0/255.0 blue:235.0/255.0 alpha:1],
			[UIColor colorWithRed:246.0/255.0 green:111.0/255.0 blue:147.0/255.0 alpha:1],
			[UIColor colorWithRed:117.0/255.0 green:83.0/255.0 blue:212.0/255.0 alpha:1],
			[UIColor colorWithRed:102.0/255.0 green:212.0/255.0 blue:93.0/255.0 alpha:1],
			[UIColor colorWithRed:246.0/255.0 green:212.0/255.0 blue:101.0/255.0 alpha:1]
		];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	// tint backgroundColorControl segments.
	// note that UISegments seem to be indexed backwards...
	int i;
	int len = [self.backgroundColors count];
	for (i=0; i<len; i++) {
		[[self.backgroundColorControl.subviews objectAtIndex:i] setBackgroundColor:[self.backgroundColors objectAtIndex:len-1-i]];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[self loadDefaults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadDefaults {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	float defaultTip = [defaults floatForKey:@"default_tip"];
	
	// can't get indexOfObject to work for NSNumbers...
	//	NSLog(@"index of default:%i", [self.tipValues indexOfObject:[NSNumber numberWithFloat:defaultTip]]);
	
	// set default tip control to default
	if (defaultTip == [[self.tipValues objectAtIndex:0] floatValue]) {
		[self.defaultTipControl setSelectedSegmentIndex:0];
	} else if (defaultTip == [[self.tipValues objectAtIndex:1] floatValue]) {
		[self.defaultTipControl setSelectedSegmentIndex:1];
	} else if (defaultTip == [[self.tipValues objectAtIndex:2] floatValue]) {
		[self.defaultTipControl setSelectedSegmentIndex:2];
	}
	
	// set background color and control if default stored
	if ([defaults valueForKey:@"bkgd_color"]) {
		NSData *colorData = [defaults objectForKey:@"bkgd_color"];
		UIColor *backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
		self.view.backgroundColor = backgroundColor;
		
		[self.backgroundColorControl setSelectedSegmentIndex:[self.backgroundColors indexOfObject:backgroundColor]];
	}
}

- (IBAction)defaultTipChanged:(id)sender {
	float defaultTip = [self.tipValues[self.defaultTipControl.selectedSegmentIndex] floatValue];
	[self setDefaultTip:defaultTip];
}

- (void)setDefaultTip:(float)defaultTip {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setFloat:defaultTip forKey:@"default_tip"];
	[defaults synchronize];
}

- (IBAction)backgroundColorChanged:(id)sender {
	UIColor *color = [self.backgroundColors objectAtIndex:self.backgroundColorControl.selectedSegmentIndex];
	[UIView animateWithDuration:0.3 animations:^{
		self.view.backgroundColor = color;
	}];
	[self setDefaultBackgroundColor:color];
}

- (void)setDefaultBackgroundColor:(UIColor*)color {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
	[defaults setObject:colorData forKey:@"bkgd_color"];
	[defaults synchronize];
}

@end
