//
//  ShowKitViewController.m
//  ShowKit-PhoneGapPlugin
//
//  Created by Yue Chang Hu on 5/20/13.
//
//

#import "ShowKitViewController.h"

@interface ShowKitViewController ()

@end

@implementation ShowKitViewController

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
    [self.navigationController.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
