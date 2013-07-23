//
//  NPSettingViewController.m
//  NetPeriod
//
//  Created by Ye Xianjin on 7/20/13.
//  Copyright (c) 2013 NetEase. All rights reserved.
//

#import "NPSettingViewController.h"
#import "NPLoginViewController.h"
#import "NPaddLoversViewController.h"
#import "NPInvitationRequestViewController.h"
#import "CommonData.h"
#import "NPLoverDetialViewController.h"

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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData]; // I think this is a very bad idea, but for time sake, I have to do this.
}

#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
    
    // your code here to reconfigure the app for changed settings
}

- (void)settingsViewController:(IASKAppSettingsViewController*)sender buttonTappedForSpecifier:(IASKSpecifier*)specifier {
//    NSLog(specifier.key);
	if ([specifier.key isEqualToString:@"ToggleLoginAction"]) {
//         NSLog([[NSUserDefaults standardUserDefaults] objectForKey:specifier.key]);
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:specifier.key] isEqualToString:@"退出"]) {
        NSLog(@"Login button pressed!");
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
            [[NSUserDefaults standardUserDefaults] setBool:NO  forKey:@"loggedin"];
            [[NSUserDefaults standardUserDefaults] setInteger:hasnolover forKey:@"loverStatus"];
            [sender.tableView reloadData];
        }
		
	} 
}

#pragma mark -
#pragma mark customcell view delegate
- (CGFloat)tableView:(UITableView*)tableView heightForSpecifier:(IASKSpecifier*)specifier {
    if ([specifier.key isEqualToString:@"headerPicture"]){
        return 65;
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
        switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"loverStatus"]) {
            case hasnolover:
                cell.textLabel.text = @"添加伴侣";
                break;
            case addinglover:
                cell.textLabel.text = @"添加待确认";
                break;
            case addedlover:
                cell.textLabel.text = @"伴侣详情";
                break;
            case hasinvitation:
                cell.textLabel.text = @"伴侣邀请请求";
                break;
            default:
                cell.textLabel.text = @"添加伴侣";
                break;
        };
        
        
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
        NSString *gender = [[NSUserDefaults standardUserDefaults] valueForKey:@"gender"];
        gender = [gender uppercaseString];
        gender = gender?gender:@"M";
        UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", gender]]];
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
        else {
            switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"loverStatus"]) {
                case hasnolover:
                case addinglover: {
                    NPaddLoversViewController *addLoverViewController = [[NPaddLoversViewController alloc] initWithNibName:@"NPaddLoversViewController" bundle:Nil];
                    [sender.navigationController pushViewController:addLoverViewController animated:YES];
                    break;
                }
                case hasinvitation: {
                    NPInvitationRequestViewController *invitationReqVC = [[NPInvitationRequestViewController alloc] initWithNibName:@"NPInvitationRequestViewController" bundle:Nil];
                    [sender.navigationController pushViewController:invitationReqVC animated:YES];
                    break;
                }
                case addedlover: {
                    NPLoverDetialViewController *loverDetialVC = [[NPLoverDetialViewController alloc] initWithNibName:@"NPLoverDetialViewController" bundle:Nil];
                    [sender.navigationController pushViewController:loverDetialVC animated:YES];
                    break;
                }
                default:
                    break;
            }
            
            
            
        }
    }
}

//男方同步女方数据后调用
- (void)enableCalendar
{
    ((UITabBarItem *)((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).tabBar.items[1]).enabled = YES;
}

- (void)didReceiveRequest:(NSString *)type email:(NSString *)email {
    
    if([type isEqualToString:@"1"]) {//invite
        [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"invitationEmail"];
        [[NSUserDefaults standardUserDefaults] setInteger:hasinvitation forKey:@"loverStatus"];
    } else if([type isEqualToString:@"2"] ){
        [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"loverEmail"];
        [[NSUserDefaults standardUserDefaults] setInteger:addedlover forKey:@"loverStatus"];
    } else if([type isEqualToString:@"3"]) {//refuse
      [[NSUserDefaults standardUserDefaults] setInteger:hasnolover forKey:@"loverStatus"];
    } else if([type isEqualToString:@"4"]) {//untie
      [[NSUserDefaults standardUserDefaults] setInteger:hasnolover forKey:@"loverStatus"];
      [[NSUserDefaults standardUserDefaults] setObject:Nil forKey:@"loverEmail"];
    }
}
@end
