//
//  MenuLinkTableViewCell.m
//  twitterclient
//
//  Created by Nicolas Halper on 4/3/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "MenuLinkTableViewCell.h"

@interface MenuLinkTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation MenuLinkTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setName:(NSString *)name {
    self.nameLabel.text = name;
}

- (void) setIcon:(NSString *)icon {
    self.iconImageView.image = [UIImage imageNamed:icon];
}

@end
