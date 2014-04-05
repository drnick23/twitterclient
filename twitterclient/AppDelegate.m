//
//  AppDelegate.m
//  twitterclient
//
//  Created by Nicolas Halper on 3/27/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetListViewController.h"
#import "MenuViewController.h"
#import "HamburgerContainerViewController.h"
#import "TwitterClient.h"
#import "User.h"


@implementation NSURL (dictionaryFromQueryString)

- (NSDictionary *)dictionaryFromQueryString
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];
    
    for(NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dictionary setObject:val forKey:key];
    }
    
    return dictionary;
}

@end

@interface AppDelegate()

@property (nonatomic,strong) UINavigationController *navigationController;
@property (nonatomic,strong) LoginViewController *loginViewController;
@property (nonatomic,strong) TweetListViewController *homeViewController;
@property (nonatomic,strong) TweetListViewController *mentionsViewController;
@property (nonatomic,strong) MenuViewController *menuViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"AppDelegate:didFinishLaunching");
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"User_currentUser"];
    if (dictionary) {
        NSLog(@"User:currentUser Loaded:%@ ", dictionary);
    }

    [self routeUserFlow];
    
    [self subscribeToNotifications];
    
    return YES;
}

- (void) routeUserFlow {
    NSLog(@"routeUserFlow");
    
    User *user = [User currentUser];
 
    NSLog(@"routeUserFlow: Current user %@",user.description);
    // if user is logged out flow to login view
    if (!user) {
        NSLog(@"setting to loginViewController");
        if (!self.loginViewController) {
            // on first login, flash the rootViewController in
            self.loginViewController = [[LoginViewController alloc] init];
        }
        self.window.rootViewController = self.loginViewController;
    }
    // if user is logged in, show the home view
    else {
        NSLog(@"setting to homeViewController");
        if (!self.homeViewController) {
            self.homeViewController = [[TweetListViewController alloc] init];
            self.homeViewController.feed = FT_HOME_TIMELINE;
        }
        UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
        
        if (!self.mentionsViewController) {
            self.mentionsViewController = [[TweetListViewController alloc] init];
            self.mentionsViewController.feed = FT_USER_MENTIONS;
        }
        UINavigationController *mentionsNavigationController = [[UINavigationController alloc] initWithRootViewController:self.mentionsViewController];
        
        
        if (!self.menuViewController) {
            self.menuViewController = [[MenuViewController alloc] init];
            
            [self.menuViewController addMenuItemWithParameters:@{@"type":@(MT_PROFILE)}];
            [self.menuViewController addMenuItemWithParameters:@{@"type":@(MT_LINK),@"name":@"Home Timeline", @"icon":@"TwitterIcon", @"controller":homeNavigationController}];
            [self.menuViewController addMenuItemWithParameters:@{@"type":@(MT_LINK),@"name":@"@mentions",@"icon":@"TwitterIcon",@"controller":mentionsNavigationController}];
            [self.menuViewController addMenuItemWithParameters:@{@"type":@(MT_ACTION),@"name":@"Log out",@"icon":@"TwitterIcon"}];
            
        }
        
        HamburgerContainerViewController *hamburgerContainerViewController = [[HamburgerContainerViewController alloc] init];
        hamburgerContainerViewController.menuViewController = self.menuViewController;
        hamburgerContainerViewController.contentViewController = homeNavigationController;
        
        self.window.rootViewController = hamburgerContainerViewController;
        
    }
}

- (void) subscribeToNotifications {
    NSLog(@"Subscribing app delegate to notifications");
    [[NSNotificationCenter defaultCenter]
                 addObserverForName:UserDidLoginNotification
                 object:nil
                 queue:nil
                 usingBlock:^(NSNotification *notification) {
                     NSLog(@"AppDelegate: subscribeToNotifications: User logged in");
                     [self routeUserFlow];
                 }
    ];
    [[NSNotificationCenter defaultCenter]
        addObserverForName:UserDidLogoutNotification
        object:nil
        queue:nil
        usingBlock:^(NSNotification *notification) {
            NSLog(@"AppDelegate: subscribeToNotifications: User logged out");
            [self routeUserFlow];
        }
     ];
    
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"drnick23twitter"])
    {
        
        // code flow for a newly authenticated user
        if ([url.host isEqualToString:@"oauth"])
        {
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                
                TwitterClient *client = [TwitterClient instance];
                [client fetchAccessTokenWithPath:@"/oauth/access_token"
                                           method:@"POST"
                                    requestToken:[BDBOAuthToken tokenWithQueryString:url.query]
                                    success:^(BDBOAuthToken *accessToken) {
                                        NSLog(@"Got accessToken %@",accessToken);
                                        [client.requestSerializer saveAccessToken:accessToken];
                                        
                                        [client verifyCredentialsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            //NSLog(@"success %@",responseObject);

                                            // send a notification that we have a new user logged in with all it's data payload
                                            User *user = [[User alloc] initWithDictionary:responseObject];
                                            NSLog(@"twitter client verified creditentials with user: %@",user.description);
                                            [User setCurrentUser:user];
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            NSLog(@"response failure %@",error);
                                        }];
                                        
                                    } failure:^(NSError *error) {
                                        NSLog(@"Failed to get access token %@",error);
                                    }];
            }
            
        }
        return YES;
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
