//
//  HomeViewController.m
//  twitterclient
//
//  Created by Nicolas Halper on 3/28/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "HomeViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "TweetList.h"

@interface HomeViewController ()

- (IBAction)onSignOutButton:(id)sender;

@property (nonatomic,strong) TweetList *tweetList;

@end

@implementation HomeViewController

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
    [[TwitterClient instance] homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"HomeViewController:viewDidLoad got timeline");
        self.tweetList = [[TweetList alloc] initFromDictionary:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HomeViewController:viewDidLoad could not get timeline");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSignOutButton:(id)sender {
    [User setCurrentUser:nil];
    NSLog(@"Sign out");
}
@end
