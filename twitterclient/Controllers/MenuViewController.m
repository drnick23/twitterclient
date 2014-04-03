//
//  MenuViewController.m
//  twitterclient
//
//  Created by Nicolas Halper on 4/3/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuProfileTableViewCell.h"
#import "MenuLinkTableViewCell.h"
#import "User.h"

enum MenuTypes {
    MT_PROFILE,
    MT_LINK
};
typedef enum MenuTypes MenuTypes;

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *menu;


@end

@implementation MenuViewController

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
    
    self.menu = @[
                  @{@"type":@(MT_PROFILE)},
                  @{@"type":@(MT_LINK),@"name":@"Home Timeline", @"icon":@"TwitterIcon"},
                  @{@"type":@(MT_LINK),@"name":@"@mentions",@"icon":@"TwitterIcon"},
                  @{@"type":@(MT_LINK),@"name":@"Log out",@"icon":@"TwitterIcon"}
                ];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // register our custom cells
    UINib *menuProfileViewCellNib = [UINib nibWithNibName:@"MenuProfileTableViewCell" bundle:nil];
    [self.tableView registerNib:menuProfileViewCellNib forCellReuseIdentifier:@"MenuProfileTableViewCell"];
    UINib *menuLinkViewCellNib = [UINib nibWithNibName:@"MenuLinkTableViewCell" bundle:nil];
    [self.tableView registerNib:menuLinkViewCellNib forCellReuseIdentifier:@"MenuLinkTableViewCell"];

    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"getting menu rows: %d",[self.menu count]);
    return [self.menu count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = self.menu[indexPath.row];
    
    if ([item[@"type"] isEqualToValue:@(MT_PROFILE)]) {
        return 200.0f;
    } else {
        return 75.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = self.menu[indexPath.row];
    NSLog(@"Cell at %d %@",indexPath.row,item);
    if ([item[@"type"] isEqualToValue:@(MT_PROFILE)]) {
        MenuProfileTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuProfileTableViewCell" forIndexPath:indexPath];
        cell.user = [User currentUser];
        return cell;
    } else {
        MenuLinkTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuLinkTableViewCell" forIndexPath:indexPath];
        cell.name = item[@"name"];
        cell.icon = item[@"icon"];
        return cell;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
