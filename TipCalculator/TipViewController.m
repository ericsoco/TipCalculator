//
//  TipViewController.m
//  TipCalculator
//
//  Created by Eric Socolofsky on 2/23/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;

@property (strong, atomic) NSArray *tipValues;

- (IBAction)onTap:(id)sender;
- (void)updateValues;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tip Calculator";
		self.tipValues = @[@(0.10), @(0.15), @(0.20)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateValues];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
}

- (void)viewWillAppear:(BOOL)animated {
	[self loadDefaults];
	[self updateValues];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadDefaults {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	// set default tip control to default
	float defaultTip = [defaults floatForKey:@"default_tip"];
	if (defaultTip == [[self.tipValues objectAtIndex:0] floatValue]) {
		[self.tipControl setSelectedSegmentIndex:0];
	} else if (defaultTip == [[self.tipValues objectAtIndex:1] floatValue]) {
		[self.tipControl setSelectedSegmentIndex:1];
	} else if (defaultTip == [[self.tipValues objectAtIndex:2] floatValue]) {
		[self.tipControl setSelectedSegmentIndex:2];
	}
	
	// set background color and control if default stored
	if ([defaults valueForKey:@"bkgd_color"]) {
		NSData *colorData = [defaults objectForKey:@"bkgd_color"];
		UIColor *backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
		self.view.backgroundColor = backgroundColor;
	}
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    [self updateValues];
}

- (void)updateValues {
    float billAmount = [self.billTextField.text floatValue];
    
    float tipAmount = billAmount * [self.tipValues[self.tipControl.selectedSegmentIndex] floatValue];
    float totalAmount = billAmount + tipAmount;
    
    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
}

- (void)onSettingsButton {
	[self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

@end
