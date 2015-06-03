//
//  StatisticsViewController.m
//  mazeForInterview
//
//  Created by Steve Franz on 5/7/15.
//  Copyright (c) 2015 Steve Franz. All rights reserved.
//

#import "StatisticsViewController.h"

@interface StatisticsViewController ()
{
    NSArray * mazeOneScores;
    NSArray * mazeTwoScores;
    NSArray * mazeThreeScores;
    NSString * mazeOneAverage;
    NSString *  mazeTwoAverage;
    NSString *  mazeThreeAverage;
}

@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)dismissButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    [self populateStatArrays];
    [self computeAverages];
    [self completeLabels];
    
    
}
-(void)completeLabels
{
    self.mazeOneAverageLabel.text = mazeOneAverage;
    self.mazeTwoAverageLabel.text = mazeTwoAverage;
    self.mazeThreeAverageLabel.text = mazeThreeAverage;
    
  

}
-(void)computeAverages
{
    
    mazeOneAverage = [NSString stringWithFormat:@"%@", [mazeOneScores valueForKeyPath:@"@avg.floatValue"]];
    mazeTwoAverage =[NSString stringWithFormat:@"%@", [mazeTwoScores valueForKeyPath:@"@avg.floatValue"]];
    mazeThreeAverage =[NSString stringWithFormat:@"%@", [mazeThreeScores valueForKeyPath:@"@avg.floatValue"]];
  
    float floatOne = [mazeOneAverage floatValue];
    mazeOneAverage = [NSString stringWithFormat:@"%.02f",floatOne];
    float floatTwo = [mazeTwoAverage floatValue];
    mazeTwoAverage = [NSString stringWithFormat:@"%.02f",floatTwo];
    float floatThree = [mazeThreeAverage floatValue];
    mazeThreeAverage = [NSString stringWithFormat:@"%.02f",floatThree];

    
    
}
-(void)populateStatArrays
{
    
    if ([[NSUserDefaults standardUserDefaults] arrayForKey:@"mazeOneScoreInterviewAppFranz"])
    {
        mazeOneScores = [[NSUserDefaults standardUserDefaults] arrayForKey:@"mazeOneScoreInterviewAppFranz"];
        
    }

    if ([[NSUserDefaults standardUserDefaults] arrayForKey:@"mazeTwoScoreInterviewAppFranz"])
    {
        mazeTwoScores = [[NSUserDefaults standardUserDefaults] arrayForKey:@"mazeTwoScoreInterviewAppFranz"];
        
    }
   
    if ([[NSUserDefaults standardUserDefaults] arrayForKey:@"mazeThreeScoreInterviewAppFranz"])
    {
        mazeThreeScores = [[NSUserDefaults standardUserDefaults] arrayForKey:@"mazeThreeScoreInterviewAppFranz"];
        
    }
    
    
}
@end
