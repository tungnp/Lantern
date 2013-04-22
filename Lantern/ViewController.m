//
//  ViewController.m
//  Lantern
//
//  Created by stevie nguyen on 4/22/13.
//  Copyright (c) 2013 tung nguyen. All rights reserved.
//

#import "ViewController.h"
#import "LanternView.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    LanternView* lanternView = [[LanternView alloc]init];
    [self.view addSubview:lanternView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
