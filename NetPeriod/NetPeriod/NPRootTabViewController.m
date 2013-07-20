//
//  NPRootTabViewController.m
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-15.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NPRootTabViewController.h"
#import "NPChooseGenderViewController.h"

@interface NPRootTabViewController ()

@end

@implementation NPRootTabViewController

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NPChooseGenderViewController *chooseGenderVC = [[NPChooseGenderViewController alloc] initWithNibName:@"NPChooseGenderViewController" bundle:nil];
//	UINavigationController *userGuideNav = [[UINavigationController alloc] initWithRootViewController:chooseGenderVC];
////    [self.view addSubview:userGuideNav.view];
//    [self presentViewController:userGuideNav animated:NO completion:nil];
}

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
////    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////    if(![defaults objectForKey:@"firstRun"]){
//        //STEP 1 Construct Panels
//        NPIntroductionPanel *panel = [[NPIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"SampleImage1"] description:@"Welcome to NPIntroductionView, your 100 percent customizable interface for introductions and tutorials! Simply add a few classes to your project, and you are ready to go!"];
//
//        //You may also add in a title for each panel
//        NPIntroductionPanel *panel2 = [[NPIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"SampleImage2"] title:@"Your Ticket!" description:@"NPIntroductionView is your ticket to a great tutorial or introduction!"];
//
//        //STEP 2 Create IntroductionView
//
//        /*A standard version*/
//        //NPIntroductionView *introductionView = [[NPIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerImage:[UIImage imageNamed:@"SampleHeaderImage.png"] panels:@[panel, panel2]];
//
//
//        /*A version with no header (ala "Path")*/
//        //NPIntroductionView *introductionView = [[NPIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) panels:@[panel, panel2]];
//
//        /*A more customized version*/
//        NPIntroductionView *introductionView = [[NPIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerText:@"NPIntroductionView" panels:@[panel, panel2] languageDirection:NPLanguageDirectionLeftToRight];
//        [introductionView setBackgroundImage:[UIImage imageNamed:@"SampleBackground"]];
//
//
//        //Set delegate to self for callbacks (optional)
//        introductionView.delegate = self;
//
//        //STEP 3: Show introduction view
//        [introductionView showInView:self.view];
////        [defaults setObject:[NSDate date] forKey:@"firstRun"];
////        [[NSUserDefaults standardUserDefaults] synchronize];
////    }
////    NPLoginViewController* loginController = [[NPLoginViewController alloc] initWithNibName:@"NPLoginViewController" bundle:Nil];
////    [self.parentViewController addChildViewController:loginController];
////    [self.navigationController presentViewController:loginController animated:YES completion:Nil];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IntroductionView Delegate Methods

-(void)introductionDidFinishWithType:(NPFinishType)finishType{
    if (finishType == NPFinishTypeSkipButton) {
        NSLog(@"Did Finish Introduction By Skipping It");
    }
    else if (finishType == NPFinishTypeSwipeOut){
        NSLog(@"Did Finish Introduction By Swiping Out");
    }
    
    //One might consider making the introductionview a class variable and releasing it here.
    // I didn't do this to keep things simple for the sake of example.
}

-(void)introductionDidChangeToPanel:(NPIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    NSLog(@"%@ \nPanelIndex: %d", panel.Description, panelIndex);
}

@end
