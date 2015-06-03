//
//  ViewController.h
//  mazeForInterview
//
//  Created by Steve Franz on 5/5/15.
//  Copyright (c) 2015 Steve Franz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MailSingleton.h"

@interface ViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic)IBOutlet UITextView * mazeTextView;
@property (weak, nonatomic)IBOutlet UILabel * walkingDirectionLabel;
@property (weak, nonatomic)IBOutlet UILabel * notificationLabel;
@property (weak, nonatomic)IBOutlet UIButton * solveButtonProperty;
@property (weak, nonatomic)IBOutlet UIButton * emailTextButtonProperty;
@property (weak, nonatomic)IBOutlet UILabel * moveNumberLabel;
@property (weak, nonatomic)IBOutlet UILabel * currentPosition;
@property (weak, nonatomic)IBOutlet UIImageView * arrow;
-(IBAction)loadMazeAction:(UIButton *)sender;
-(IBAction)solveMazeAction:(id)sender;
-(IBAction)emailTextFileButton:(id)sender;

@end

