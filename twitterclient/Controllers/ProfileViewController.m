//
//  ProfileViewController.m
//  twitterclient
//
//  Created by Nicolas Halper on 4/3/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenName;

@property (weak, nonatomic) IBOutlet UILabel *userStatusesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *userFollowingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *userFriendsCountLabel;
@end

@implementation ProfileViewController

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
    self.navigationItem.title = @"Profile";
    [self setupView];
}

- (void)setUser:(User *)user {
    NSLog(@"ProfileViewController:setUser %@",user);
    _user = user;
    [self setupView];
    
}

- (void)setupView {
    self.userNameLabel.text = self.user.name;
    self.userScreenName.text = self.user.screenName;
    [self.userProfileImageView setImageWithURL:self.user.profileImageURL];
    NSLog(@"user data %@",self.user);
    self.userStatusesCountLabel.text = [NSString stringWithFormat:@"%@",self.user.statusesCount];
    self.userFollowingCountLabel.text = [NSString stringWithFormat:@"%@",self.user.followersCount];
    self.userFriendsCountLabel.text = [NSString stringWithFormat:@"%@",self.user.friendsCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
