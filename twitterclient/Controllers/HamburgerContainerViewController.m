//
//  HamburgerContainerViewController.m
//  twitterclient
//
//  Created by Nicolas Halper on 4/5/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "HamburgerContainerViewController.h"
#import "MenuViewController.h"

@interface HamburgerContainerViewController ()

- (IBAction)onPan:(UIPanGestureRecognizer *)sender;

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (assign,nonatomic) BOOL menuOpen;
@property (assign,nonatomic) CGAffineTransform menuOriginTransform;
@property (assign,nonatomic) CGPoint startPanPoint;

@end

@implementation HamburgerContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]
         addObserverForName:MenuViewControllerDidSelectControllerNotification
         object:nil
         queue:nil
         usingBlock:^(NSNotification *notification) {
             NSLog(@"Hamburger Container received notification: %@",notification.userInfo[@"controller"]);
             [self switchContentWithViewController:notification.userInfo[@"controller"]];
             [UIView animateWithDuration:0.5 animations:^{
                 [self setMenuWithOpen:NO];
             }];
         }
         ];
    }
    return self;
}

- (void)switchContentWithViewController:(UIViewController *)viewController {
    NSLog(@"switching content view to new view controller %@",viewController);
    if (self.contentViewController) {
        [self.contentViewController removeFromParentViewController];
        [self.contentViewController.view removeFromSuperview];
        
        [self addChildViewController:viewController];
        [self.contentView addSubview:viewController.view];
        
        viewController.view.frame = self.contentView.frame;
        
    }
    [self.view bringSubviewToFront:self.menuView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.contentViewController) {
        
        [self addChildViewController:self.contentViewController];
        [self.contentView addSubview:self.contentViewController.view];
        
        self.contentViewController.view.frame = self.contentView.frame;
    } else {
        NSLog(@"warning: add contentViewController");
        self.contentView.backgroundColor = [UIColor greenColor];
    }
    
    if (self.menuViewController) {
        [self addChildViewController:self.menuViewController];
        [self.menuView addSubview:self.menuViewController.view];
        self.menuViewController.view.frame = self.menuView.frame;
    } else {
        self.menuView.backgroundColor = [UIColor blueColor];
    }
    [self.view bringSubviewToFront:self.menuView];
    
    [self setMenuWithOpen:NO];
    
}

- (void)setMenuWithOpen:(BOOL)open {
    CGRect menuFrame = self.menuView.frame;
    self.menuOpen = open;
    if (open) {
        self.menuOriginTransform = CGAffineTransformIdentity;
    } else {
        self.menuOriginTransform = CGAffineTransformMakeTranslation(-menuFrame.size.width+0,0);
    }
    self.menuView.transform = self.menuOriginTransform;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    //CGPoint point = [tapGestureRecognizer locationInView:self.view];
}

- (IBAction)onPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    CGPoint point = [panGestureRecognizer locationInView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Start point: %f",point.x);
        self.startPanPoint = point;
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        //NSLog(@"changed transform point: %f distance:%f",point.x, point.x - self.startPanPoint.x);
        self.menuView.transform = CGAffineTransformTranslate(self.menuOriginTransform, point.x - self.startPanPoint.x, 0);
        //self.menuView.transform = CGAffineTransformMakeTranslation(point.x - self.startPanPoint.x, 0);
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
        
        // todo: upgrade to ui view dynamics
        // http://www.teehanlax.com/blog/introduction-to-uikit-dynamics/
        [UIView animateWithDuration:0.5 animations:^{
            NSLog(@"Do anaimtiong");
            if (velocity.x <= 0) {
                [self setMenuWithOpen:NO];
            } else {
                [self setMenuWithOpen:YES];
            }
            
        } completion:^(BOOL finished) {
            NSLog(@"done");
        }];
        
    }
}


@end
