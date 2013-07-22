//
//  NPMessageBoardTableViewController.m
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-15.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NPMessageBoardViewController.h"
#import "NPMessageBoardViewCell.h"
#import "NPComposeViewController.h"
#import "NPMessageBoardDetailViewController.h"
#import "AFNetworking.h"
#import "SVSegmentedControl.h"
#import "JSONKit.h"
#import "ODRefreshControl.h"
#import "NPArticle.h"

@interface NPMessageBoardViewController () <SVSegmentedControlDelegate>
{
    SVSegmentedControl *navSC;
    ODRefreshControl *refreshControl;
    
    NSMutableArray *articles;
    NSInteger maxArticleId;
    NSInteger minArticleId;
    NSString *articleType;
    
    BOOL isPullingUp;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NPMessageBoardViewController

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
	// Do any additional setup after loading the view.
    
    articles = [NSMutableArray array];
    articleType = @"0";
    
    navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"论坛", @"我的帖子", nil]];
    navSC.thumb.tintColor = [UIColor colorWithRed:0 green:0.5 blue:0.1 alpha:1];
    [navSC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
	navSC.center = CGPointMake(160, 22);
    [self.navigationController.navigationBar addSubview:navSC];
    
    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    [self checkAndGetLastArticles];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    navSC.hidden = NO;
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
    return [articles count] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"NPImageViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
        if ([articleType intValue] == 0) {
            imageView.image = [UIImage imageNamed:@"banner"];
        } else {
            imageView.image = [UIImage imageNamed:@"np_my_banner"];
        }
        
        [cell.contentView addSubview:imageView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == [articles count] + 1) {
        if (minArticleId <= 1) {
            static NSString *CellIdentifier = @"NPLoadFinishCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.textLabel.text = @"已经加载全部帖子";
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        static NSString *CellIdentifier = @"NPLoadMoreCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = CGPointMake(96, 22);
        [cell.contentView addSubview:indicator];
        [indicator startAnimating];
        cell.textLabel.text = @"正在加载更多";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *theEndId = @"1";
        if (minArticleId > 10) {
            theEndId = [NSString stringWithFormat:@"%d", minArticleId - 9];
        }
        [self getArticlesWithType:articleType startId:[NSString stringWithFormat:@"%d", minArticleId] endId:theEndId];
        return cell;
    }
    
    static NSString *CellIdentifier = @"NPMessageBoardViewCell";
    NPMessageBoardViewCell *cell = (NPMessageBoardViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [NPMessageBoardViewCell cellFromNib];
    }

    NSDictionary *dic = [articles objectAtIndex:indexPath.row - 1];
    cell.titleLabel.text = [dic objectForKey:@"title"];
    cell.dateLabel.text = [dic objectForKey:@"addtime"];
    cell.articleLabel.text = [dic objectForKey:@"content"];
    cell.commentLabel.text = [NSString stringWithFormat:@"%@条评论",(NSString *)[dic objectForKey:@"count"]];
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 150;
    } if (indexPath.row == [articles count] + 1) {
        return 44;
    }
    return 84;
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
    if (indexPath.row == 0) {
        return;
    }
    if (indexPath.row == [articles count] + 1) {
        return;
    }
    
    NPMessageBoardDetailViewController *detailViewController = [[NPMessageBoardDetailViewController alloc] initWithNibName:@"NPMessageBoardDetailViewController" bundle:nil];
    
    NSDictionary *dic = [articles objectAtIndex:indexPath.row - 1];
    NPArticle *article = [[NPArticle alloc] init];
    article.title = [dic objectForKey:@"title"];
    article.date = [dic objectForKey:@"addtime"];
    article.content = [dic objectForKey:@"content"];
    article.commentNum = [dic objectForKey:@"count"];
    article.topicId = [dic objectForKey:@"pkid"];
    detailViewController.article = article;
    
    navSC.hidden = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - Actions

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    
//    double delayInSeconds = 3.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [refreshControl endRefreshing];
//    });
    isPullingUp = YES;
    [self pullAndRefreshArticles];
}

- (void)pullAndRefreshArticles
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://10.240.34.43:8080/"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@"http://10.240.34.43:8080/np-web/maxTopicId"
                                                      parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSDictionary *result = [[JSONDecoder decoder] objectWithData:responseObject];
        NSString *maxId = [result objectForKey:@"maxId"];
        if ([maxId intValue] == maxArticleId) {
            [refreshControl endRefreshing];
            return;
        } else if ([maxId intValue] - maxArticleId >= 10) {
            [articles removeAllObjects];
        }
        NSString *theEndId = [NSString stringWithFormat:@"%d", maxArticleId + 1];
        maxArticleId = [maxId intValue];
        NSLog(@"Max %d", maxArticleId);
        [self getArticlesWithType:articleType startId:maxId endId:theEndId];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];
}

- (void)checkAndGetLastArticles
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://10.240.34.43:8080/"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                    path:@"http://10.240.34.43:8080/np-web/maxTopicId"
                parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSDictionary *result = [[JSONDecoder decoder] objectWithData:responseObject];
        NSString *maxId = [result objectForKey:@"maxId"];
        NSString *theEndId = @"1";
        if ([maxId intValue] > 10) {
            theEndId = [NSString stringWithFormat:@"%d", [maxId intValue] - 9];
        }
        maxArticleId = [maxId intValue];
        NSLog(@"Max %d", maxArticleId);
        [self getArticlesWithType:articleType startId:maxId endId:theEndId];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];
}

- (void)getArticlesWithType:(NSString *)type startId:(NSString *)startId endId:(NSString *)endId
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://10.240.34.43:8080/"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                    path:@"http://10.240.34.43:8080/np-web/queryTopicsByRange"
                    parameters:@{
                                    @"startId":startId,
                                    @"endId":endId,
                                    @"type":type,
                                    @"email":@"aa@163.com",
                                    @"uid":@"fdssfsfsdsad"
                                    }];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *dic = [[JSONDecoder decoder] objectWithData:responseObject];
        
        if (isPullingUp) {
            NSArray *arr = [dic objectForKey:@"topics"];
            NSRange range = NSMakeRange(0, [arr count]);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [articles insertObjects:arr atIndexes:indexSet];
            [self.tableView reloadData];
            [refreshControl endRefreshing];
            isPullingUp = NO;
            return;
        }
        minArticleId = [endId intValue];
        NSLog(@"Min %d", minArticleId);
        if ([[dic objectForKey:@"topics"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = [dic objectForKey:@"topics"];
            [articles addObjectsFromArray:arr];
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    [operation start];

}

#pragma mark - UIControlEventValueChanged

- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl {
	NSLog(@"segmentedControl %i did select index %i (via UIControl method)", segmentedControl.tag, segmentedControl.selectedSegmentIndex);
    maxArticleId = 0;
    minArticleId = 0;
    articleType = [NSString stringWithFormat:@"%d", segmentedControl.selectedSegmentIndex];
    [articles removeAllObjects];
    [self.tableView reloadData];
    [self checkAndGetLastArticles];
}

#pragma mark - SVSegmentController Delegate

- (void)segmentedControl:(SVSegmentedControl*)segmentedControl didSelectIndex:(NSUInteger)index
{
    
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
