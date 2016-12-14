//
//  ViewController.m
//  ARGIFLoader
//
//  Created by Asif Raza on 25/11/16.
//  Copyright © 2016 Codes Logic. All rights reserved.
//

#import "ViewController.h"
#import "ARGIFLoader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [ARGIFLoader setLoaderImage:[UIImage imageNamed:@"Loader"] imageSizeInPercentageOfDeviceWidth:0.25f];
    [ARGIFLoader showLoaderWithOverlay];
    
    [self performSelector:@selector(hideLoader) withObject:nil afterDelay:20.0];
}

-(void)hideLoader{
    [ARGIFLoader hideLoader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
