//
//  TweetComposeViewController.m
//  twitterclient
//
//  Created by Nicolas Halper on 3/29/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "TweetComposeViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface TweetComposeViewController ()

-(void)onCancelButton:(id)sender;
-(void)onTweetButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;

@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@property (strong,nonatomic) UILabel *charactersLeftCounter;

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
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    CGFloat width = self.view.frame.size.width;
    self.charactersLeftCounter = [[UILabel alloc] initWithFrame:CGRectMake(width-rightButton.width-120, 10, 50, 20)];
    self.charactersLeftCounter.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.charactersLeftCounter.text = @"140";
    self.charactersLeftCounter.backgroundColor = [UIColor clearColor];
    self.charactersLeftCounter.font = [UIFont systemFontOfSize:12];
    [self.navigationController.navigationBar addSubview:self.charactersLeftCounter];
    
    // get current user
    User *user = [User currentUser];
    self.userNameLabel.text = user.name;
    self.userScreenNameLabel.text = [NSString stringWithFormat:@"@%@",user.screenName];
    [self.userProfileImageView setImageWithURL:user.profileImageURL];
    
    self.tweetTextView.delegate = self;
    self.tweetTextView.text = @"";
    self.tweetTextView.keyboardType = UIKeyboardTypeTwitter;
    [self.tweetTextView becomeFirstResponder];

}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"textViewShouldBeginEditing");
    [self adjustNavigationBarToTextView:textView];
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing");
    //textView.backgroundColor = [UIColor greenColor];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"textViewShouldEndEditing:");
    //textView.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"textViewDidEndEditing: %@",textView.text);
}

- (void)textViewDidChange:(UITextView *)textView{
    
    NSLog(@"textViewDidChange:");
    
    [self adjustNavigationBarToTextView:textView];
}

-(void)adjustNavigationBarToTextView:(UITextView *)textView {
    NSUInteger length = [textView.text length];
    
    if ((length > 0) && (length<=140)) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    self.charactersLeftCounter.text = [NSString stringWithFormat:@"%d",(140-length)];

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
    
    [[TwitterClient instance] updateStatus:self.tweetTextView.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"success tweet %@",responseObject);
        NSDictionary *dictionary;
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *response = responseObject;
            NSLog(@"WARNING: in developer test mode tweets not actually posted");
            dictionary = [response objectAtIndex:0];
        } else {
            dictionary = responseObject;
        }
        //NSLog(@"tweet to init with dict: %@",dictionary);
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        // callback to delegate
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate updatedWithStatus:tweet];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"onTweetButton: could not tweet %@",error);
    }];
    
    
    
    
}

@end
