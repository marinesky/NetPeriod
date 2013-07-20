//
//  NPSettingViewController.m
//  NetPeriod
//
//  Created by Ye Xianjin on 7/20/13.
//  Copyright (c) 2013 NetEase. All rights reserved.
//

#import "NPSettingViewController.h"
#import "NPLoginViewController.h"

@interface NPSettingViewController ()

@end

@implementation NPSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"setting screen inits!");
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"setting page inits");
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
    
    // your code here to reconfigure the app for changed settings
}

- (void)settingsViewController:(IASKAppSettingsViewController*)sender buttonTappedForSpecifier:(IASKSpecifier*)specifier {
	if ([specifier.key isEqualToString:@"ToggleLoginAction"]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:specifier.key] isEqualToString:@"登录注册"]) {
        //NSLog(@"Login button pressed!");
        NPLoginViewController *loginViewController = [[NPLoginViewController alloc] init];
            loginViewController.redirectType = LoginRedirectFromSetting;
        //[loginViewController.view addSubview:loginViewController.loginOnlyView];
        //loginViewController.loginAndRegisterUsernameTextField.hidden =YES;
        //loginViewController.loginAndRegisterPasswordTextField.hidden = YES;
        [self presentViewController:loginViewController animated:YES completion:Nil];
        } else {
             UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"信息" message:@"退出成功" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:Nil];
            [message show];
            [[NSUserDefaults standardUserDefaults] setObject:@"登录注册" forKey:specifier.key];
        }
		
	} else if ([specifier.key isEqualToString:@"ButtonDemoAction2"]) {
		NSString *newTitle = [[[NSUserDefaults standardUserDefaults] objectForKey:specifier.key] isEqualToString:@"Logout"] ? @"Login" : @"Logout";
		[[NSUserDefaults standardUserDefaults] setObject:newTitle forKey:specifier.key];
	}
}

#pragma mark -
#pragma mark customcell view delegate
- (CGFloat)tableView:(UITableView*)tableView heightForSpecifier:(IASKSpecifier*)specifier {
    if ([specifier.key isEqualToString:@"headerPicture"]){
        return 80;
    }
    return 44;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForSpecifier:(IASKSpecifier*)specifier {
    if ([specifier.key isEqualToString:@"lovers"]) {
        static NSString *CellIdentifier = @"lovers";//set to the specifier.key
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        cell.textLabel.text = @"伴侣";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else if ([specifier.key isEqualToString:@"headerPicture"]) {
        static NSString *CellIdentifier = @"haderPicture";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        cell.textLabel.text = @"头像";
        UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"M.bmp"]];
        cell.accessoryView = headerImageView;
        return cell;
    }
    return Nil;
}

- (void)settingsViewController:(IASKAppSettingsViewController*)sender tableView:(UITableView *)tableView didSelectCustomViewSpecifier:(IASKSpecifier*)specifier {
//    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:specifier.key];
//    if (cell == nil) {
//        NSLog(@"cell is nil");
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:specifier.key];
//    }
    //myBackView.backgroundColor = [UIColor colorWithRed:151.0/255 green:212.0/255 blue:197.0/255 alpha:1];
    //cell.contentView.backgroundColor = [UIColor colorWithRed:151.0/255 green:212.0/255 blue:197.0/255 alpha:1];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if ([specifier.key isEqualToString:@"lovers"]) { //user selected the lover tableview cell
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"loggedin"]){ //user has not logged in
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"信息" message:@"您还未登录，请先登录或者注册再添加伴侣" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:Nil];
            [message show];
        }
    }
}
@end
