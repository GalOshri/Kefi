//
//  SocialNetworkAccountsTableViewController.m
//  Kefi
//
//  Created by Paul Stavropoulos on 6/18/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "SocialNetworkAccountsTableViewController.h"
#import "SWRevealViewController.h"

@interface SocialNetworkAccountsTableViewController ()

// @property (nonatomic, strong) NSArray *accountTypes;
// set text fields for username and password changes
@property UITextField *usernameTextfield;
@property UITextField *passwordTextfield;

@end

@implementation SocialNetworkAccountsTableViewController

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
    
   //  self.accountTypes = @[@"Facebook",@"Twitter",@"Foursquare"];
}
    

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/* - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.accountTypes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.accountTypes objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100.0;
}
*/

- (IBAction)cancelModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
        switch ([indexPath row])
        {
            // Facebook
            case 0:
                if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
                    [PFFacebookUtils linkUser:[PFUser currentUser] permissions:nil block:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSLog(@"Linked to Facebook");
                        }
                    }];
                }
                else
                {
                    
                    NSLog(@"Already linked to Facebook");
                    UIAlertView *FacebookAlert = [[UIAlertView alloc] initWithTitle:@"Already Connected"
                                                                    message:@"Your account is already connected to Facebook."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [FacebookAlert show];
                }
                break;
            // Twitter
            case 1:
                if ([PFUser user])
                {
                    if (![PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]) {
                        [PFTwitterUtils linkUser:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
                            if ([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]) {
                                NSLog(@"Woohoo, user logged in with Twitter!");
                            }
                        }];
                    }
                    else
                    {
                        NSLog(@"Already linked to Twitter");
                        UIAlertView *TwitterAlert = [[UIAlertView alloc] initWithTitle:@"Already Connected"
                                                                        message:@"Your account is already connected to Twitter."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [TwitterAlert show];
                    }
                }
                break;
            // Foursquare
            case 2:
            {
                NSLog(@"No Foursquare for you. NEXT!");
                UIAlertView *FoursquareAlert = [[UIAlertView alloc] initWithTitle:@"Coming Soon!"
                                                                message:@"Foursquare connectivity coming soon."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [FoursquareAlert show];
            }
                break;
            
            default:
                break;

        }
    }
    
    if (indexPath.section == 1)
    {
        NSLog(@"clicked section1 ");
        switch ([indexPath row])
        {
            case 1:
                NSLog(@"password change");
                if ([PFUser user]) {
                    // change password
                    UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"Change Password" message:@"an email will be sent to the below address" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"go", nil];
                    passwordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
                    self.passwordTextfield.text = @"";
                    self.passwordTextfield = [passwordAlert textFieldAtIndex:0];
                   
                    
                    [passwordAlert show];
                }
                break;
            case 0:
                NSLog(@"case 0");
                if ([PFUser user]) {
                    NSLog(@" username change");
                    // change username
                    UIAlertView *usernameAlert = [[UIAlertView alloc] initWithTitle:@"Change Username" message:[NSString stringWithFormat:@"your current username is: %@ \nChange it to:", [[PFUser currentUser] username]]  delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"go", nil];
                    
                    usernameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;

                    self.usernameTextfield = [usernameAlert textFieldAtIndex:0];
                    self.usernameTextfield.text = @"";
                    [usernameAlert show];
                }
                break;
                
            default:
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1)
    {
        if (![self.passwordTextfield.text isEqualToString:@""]){
            [PFUser requestPasswordResetForEmailInBackground:[NSString stringWithFormat:@"%@",self.passwordTextfield.text]];
            NSLog(@"initiated password reset");
            
            UIAlertView *alertSuccessPassword = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Check your email to finish changing your password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertSuccessPassword show];
        }
        
        if (![self.usernameTextfield.text isEqualToString:@""]) {
            [[PFUser currentUser] setUsername:[NSString stringWithFormat:@"%@", self.usernameTextfield.text]];
            [[PFUser currentUser] saveInBackground];
            
            UIAlertView *alertSuccessUsername = [[UIAlertView alloc] initWithTitle:@"Success" message:[NSString stringWithFormat:@"Your username is now: %@", self.usernameTextfield.text] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertSuccessUsername show];
        }
    }
}



-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.0;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
