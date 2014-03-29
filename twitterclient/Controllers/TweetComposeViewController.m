//
//  TweetComposeViewController.m
//  twitterclient
//
//  Created by Nicolas Halper on 3/29/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "TweetComposeViewController.h"

@interface TweetComposeViewController ()

-(void)onCancelButton:(id)sender;
-(void)onTweetButton:(id)sender;

@end

@implementation TweetComposeViewController

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
    // Do any additional setup after loading the view from its nib.
    
    // Configure the navigation bar
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancelButton:(id)sender {
    NSLog(@"ComposeTweetViewController onCancelButton");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTweetButton:(id)sender {
    NSLog(@"ComposeTweetViewController onTweetButton");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
