//
//  LoginViewController.m
//  twitterclient
//
//  Created by Nicolas Halper on 3/27/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"

@interface LoginViewController ()
- (IBAction)onLogin:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *twitterIconImageView;

@end

@implementation LoginViewController

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
    
    // Animate the twitter image to come up from bottom.
    [self animateEaseInImageFromBottom:self.twitterIconImageView duration:1.0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    [[TwitterClient instance] login];
}

- (void)animateEaseInImageFromBottom:(UIImageView *)image duration:(NSTimeInterval)duration {
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 600);
    image.transform = transform;
    
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    image.transform = CGAffineTransformMakeTranslation(0, 0);
    // Commit the changes
    [UIView commitAnimations];
}


@end
