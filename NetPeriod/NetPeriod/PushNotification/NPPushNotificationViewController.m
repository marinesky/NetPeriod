//
//  NPPushNotificationViewController.m
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-18.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NPPushNotificationViewController.h"
#import "NPPushNotificationCell.h"
#import "NPLoginViewController.h"
#import "JSONKit.h"
#import "NPUser.h"

@interface NPPushNotificationViewController () {
    NSMutableArray *notifications;
    NPUser *user;
}

@property (weak, nonatomic) IBOutlet UITableView *pushTableView;

@end

@implementation NPPushNotificationViewController

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
    self.title = @"提醒";
	// Do any additional setup after loading the view.
    user = [[NPUser alloc] init];
    notifications = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateViewHeight];
    [self getLastestNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewHeight
{
    CGRect frame = self.pushTableView.frame;
    frame.size.height = [notifications count] * 72;
    self.pushTableView.frame = frame;
    
    UIScrollView *scrollView = (UIScrollView *)self.view;
    [scrollView setContentSize:CGSizeMake(320, frame.origin.y + frame.size.height + 20)];
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
    return [notifications count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NPPushNotificationCell";
    NPPushNotificationCell *cell = (NPPushNotificationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [NPPushNotificationCell cellFromNib];
    }
    
    // Configure the cell...
    NSDictionary *dic = [notifications objectAtIndex:indexPath.row];
    cell.content.text = [dic objectForKey:@"content"];
    cell.date.text = [dic objectForKey:@"pushtime"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
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
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)handlePushNotification:(NSDictionary *)userInfo
{
    NSLog(@"In the Push");
    [self getLastestNotifications];
}

- (void)getLastestNotifications
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.130.50:8080/"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@"http://192.168.130.50:8080/np-web/getNotification"
                                                      parameters:@{
                                    @"email":user.username,
                                    @"uid":user.uid}];
    NSLog(@"User: %@ UID: %@", user.username, user.uid);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
//        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", str);
        NSDictionary *dic = [[JSONDecoder decoder] objectWithData:responseObject];
        if ([[dic objectForKey:@"logs"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = [dic objectForKey:@"logs"];
            [notifications setArray:arr];
            [self.pushTableView reloadData];
            [self updateViewHeight];
        }
//        if ([[[JSONDecoder decoder] objectWithData:responseObject] isKindOfClass:[NSArray class]]) {
//            NSArray *arr = [[JSONDecoder decoder] objectWithData:responseObject];
//            [notifications setArray:arr];
//            [self.pushTableView reloadData];
//            [self updateViewHeight];
//        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}

- (void)viewDidUnload {
    [self setPushTableView:nil];
    [super viewDidUnload];
}
@end
