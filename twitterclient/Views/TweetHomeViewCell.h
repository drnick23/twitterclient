//
//  TweetHomeViewCell.h
//  twitterclient
//
//  Created by Nicolas Halper on 3/28/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetHomeViewCell : UITableViewCell

@property (nonatomic,strong) Tweet *tweet;

-(void) animateFlash;

@end
