//
//  StatisticsViewController.h
//  mazeForInterview
//
//  Created by Steve Franz on 5/7/15.
//  Copyright (c) 2015 Steve Franz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsViewController : UIViewController

@property (weak, nonatomic)IBOutlet UILabel * mazeOneAverageLabel;
@property (weak, nonatomic)IBOutlet UILabel * mazeTwoAverageLabel;
@property (weak, nonatomic)IBOutlet UILabel * mazeThreeAverageLabel;




-(IBAction)dismissButtonAction:(id)sender;

@end
