//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"

@interface SidebarViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation SidebarViewController


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    // NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
     UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    // destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    
    
     if ([segue.identifier isEqualToString:@"accountsSegue"]) {
         // set bar button items
         UIImage *menuImg = [UIImage imageNamed:@"menu.png"];
         UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
         imgButton.bounds = CGRectMake(0,0, menuImg.size.width, menuImg.size.height);
         
         [imgButton setImage:menuImg forState:UIControlStateNormal];
         UIBarButtonItem *menuBarBtn = [[UIBarButtonItem alloc]initWithCustomView:imgButton];
         menuBarBtn.target = self.revealViewController;
         menuBarBtn.action = @selector(revealToggle:);
         
         destViewController.navigationItem.leftBarButtonItem = menuBarBtn;
         
         NSLog(@"we prepare for accounts segue");
     }
    
    if ([segue.identifier isEqualToString:@"contactsSegue"]) {
        NSLog(@"we prepare for contacts segue");
        
        
    }

    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
        };
        NSLog(@"got into swrevealviewcontrollerSegue class stuff"); 
    }
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.3f];
    
    _menuItems = @[@"home", @"accounts", @"settings", @"invites", @"contact", @"privacy", @"logout"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

@end
