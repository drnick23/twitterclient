//
//  MenuProfileTableViewCell.m
//  twitterclient
//
//  Created by Nicolas Halper on 4/3/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "MenuProfileTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface MenuProfileTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;

@end

@implementation MenuProfileTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    _user = user;
    
    self.userNameLabel.text = user.name;
    self.userScreenNameLabel.text = user.screenName;
    [self.userProfileImageView setImageWithURL:user.profileImageURL];
}

@end
