//
//  ViewController.m
//  mazeForInterview
//
//  Created by Steve Franz on 5/5/15.
//  Copyright (c) 2015 Steve Franz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
  
    NSMutableArray * finalMazeArray;
    NSMutableArray * openingsArray;
    NSArray * alphabet;
    NSString * currentLetter;
    NSMutableArray * openRowValues;
    NSMutableArray * openColumnValues;
    NSMutableArray * rowSolutionsArray;
    NSMutableArray * columnSolutionsArray;
    NSString * lastDirection;
    NSString * facingDirection;
    NSString * mazeString;
    
    int mazeUsed;
    int nextAttempt;
    BOOL isMazedSolved;
    int moveNumber;
    int letterCount;
    int numberOfRows;
    int numberOfColumns;
    int integerNumberForColumn;
    int integerNumberForRow;
    

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set initial values.  lazy instantiation
    mazeUsed = 0;
    self.notificationLabel.hidden = YES;
    self.solveButtonProperty.enabled = NO;
    self.moveNumberLabel.text = @"Number of Moves:";
    self.arrow.image = nil;
    self.currentPosition.text = @"";
    self.walkingDirectionLabel.hidden = YES;
    self.emailTextButtonProperty.hidden = YES;
    mazeString = @"";
    facingDirection = @"";
    lastDirection = @"D";
    currentLetter = @"";
    nextAttempt = 0;
    isMazedSolved = NO;
    letterCount = 0;
    numberOfColumns = 0;
    numberOfRows = 0;
    moveNumber = 0;
    openRowValues = [[NSMutableArray alloc]init];
    openColumnValues = [[NSMutableArray alloc]init];
    rowSolutionsArray = [[NSMutableArray alloc]init];
    columnSolutionsArray = [[NSMutableArray alloc]init];
    finalMazeArray = [[NSMutableArray alloc]init];
    openingsArray = [[NSMutableArray alloc]init];
    alphabet = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];

   
}
-(void)resetAlphabet
{
    //method to reset alphbet when starting new maze
    currentLetter = @"";
    letterCount = 0;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)changeImageViewPicture:(NSString *)direction
{
    //changes the arrow image in the view
    if([direction isEqualToString:@"D"])
    {
       [self.arrow setImage:[UIImage imageNamed:@"down.png"]];
    }
    if([direction isEqualToString:@"U"])
    {
         [self.arrow setImage:[UIImage imageNamed:@"up.png"]];
    }
    if([direction isEqualToString:@"L"])
    {
         [self.arrow setImage:[UIImage imageNamed:@"left.png"]];
    }
    if([direction isEqualToString:@"R"])
    {
         [self.arrow setImage:[UIImage imageNamed:@"right.png"]];
    }
    
}
-(NSString *)getNextLetterOfAlpha
{
    //increments to the next letter of the alphabet
    letterCount = letterCount%26;
    
    currentLetter = [alphabet objectAtIndex:letterCount];
    
    
    letterCount++;
    
    return currentLetter;
    
}

-(void)findBeginning
{
    //locates the first opening of the maze.  Setup to find the opening in the top of the maze
    
        if([[finalMazeArray objectAtIndex:0]containsObject:@"_"])
        {
            int integerNumber = [[finalMazeArray objectAtIndex:0]indexOfObject:@"_"];
            
            NSString * string =  [NSString stringWithFormat:@"%d",integerNumber];
            [columnSolutionsArray addObject:string];
            [rowSolutionsArray addObject:@"0"];
            
        }
    
    NSString * string = [NSString stringWithFormat:@"%@",[columnSolutionsArray objectAtIndex:0]];
    int integerNumber = [string intValue];
    
    [[finalMazeArray objectAtIndex:0]replaceObjectAtIndex:integerNumber withObject:[self getNextLetterOfAlpha]];
    
   
    
    
    
}
-(void)updatePositionLabel
{
    //updates the position label in the view with the current locaation of the walker
    
    NSString * yString = [NSString stringWithFormat:@"%@",[columnSolutionsArray lastObject]];
    integerNumberForColumn = [yString intValue];
    NSString * xString = [NSString stringWithFormat:@"%@",[rowSolutionsArray lastObject]];
    integerNumberForRow = [xString intValue];
    self.currentPosition.text = [NSString stringWithFormat:@"Row: %d  Column %d",integerNumberForRow,integerNumberForColumn];
    
  
}
-(void)determineFace
{
    //determines the initial orientation of the walker so the walker is facing the correct direction
    NSString * yString = [NSString stringWithFormat:@"%@",[columnSolutionsArray firstObject]];
    int startingY = [yString intValue];
    
    NSString * xString = [NSString stringWithFormat:@"%@",[rowSolutionsArray firstObject]];
    int startingX = [xString intValue];
    
    if(startingX==0)
    {
        
        //facing down
        facingDirection = @"D";
    }
    
    else if(startingY==0)
    {
        //facing right
        facingDirection = @"R";
    }
    else if(startingX==finalMazeArray.count)
    {
        //facing up
        facingDirection = @"U";
    }
    else if(startingY == [[finalMazeArray objectAtIndex:0]count])
    {
        facingDirection = @"L";
    }
    
    [self changeImageViewPicture:facingDirection];
    
}
-(void)moveMe
{
    
    //Moves the walker forward one space.  If way is blocked this method will call the turn to turn the walker.
    
    //clear the previous open spaces
    [openingsArray removeAllObjects];
    
    //checks to see if maze end has been reached
    [self checkForEnd];
    
    
    if(!isMazedSolved)
    {
    
        //checkPaths method populates the openingsArray with a list of possible paths.  If a path exists in the direction the walker is facing then it will move that way.  If not it will move to a previously visited path.  If neither exists the walker will turn as their action.
        [self checkPaths];
        
        if([facingDirection isEqualToString:@"D"] && [openingsArray containsObject:@"D"])
        {
            [self moveDown];
        }
        else if([facingDirection isEqualToString:@"U"] && [openingsArray containsObject:@"U"])
        {
            [self moveUp];
        }
        else if([facingDirection isEqualToString:@"R"] && [openingsArray containsObject:@"R"])
        {
            [self moveRight];
        }
        else  if([facingDirection isEqualToString:@"L"] && [openingsArray containsObject:@"L"])
        {
            [self moveLeft];
        }
        else if([facingDirection isEqualToString:@"D"] && [openingsArray containsObject:@"D2"])
        {
            [self moveDown];
        }
        else if([facingDirection isEqualToString:@"U"] && [openingsArray containsObject:@"U2"])
        {
            [self moveUp];
        }
        else if([facingDirection isEqualToString:@"R"] && [openingsArray containsObject:@"R2"])
        {
            [self moveRight];
        }
        else if([facingDirection isEqualToString:@"L"] && [openingsArray containsObject:@"L2"])
        {
            [self moveLeft];
        }
        else
        {
        [   self turn];
        }
    }//end of maze solved if statement
    
    [self updatePositionLabel];
    
}
-(void)turn
{
    //randomly turns the walker.  Executed when walker is facing a wall
    NSUInteger r = arc4random_uniform(4) + 1;
    
    if(r==1)
    {
        
        facingDirection = @"L";
    }
    if(r==2)
    {
        
        facingDirection = @"R";
    }
    if(r==3)
    {
        
        facingDirection = @"U";
    }
    if(r==4)
    {
        
        facingDirection = @"D";
    }
    
    //changes the image view to the correct facing arrow.
    [self changeImageViewPicture:facingDirection];
   

}
-(void)moveDown
{
    //moves the walker down by adding one to the row number and adding the row and column values to the solution arrays for use during the next move and for the current position of the walker
    [[finalMazeArray objectAtIndex:integerNumberForRow+1]replaceObjectAtIndex:integerNumberForColumn withObject:[self getNextLetterOfAlpha]];
    
    [rowSolutionsArray addObject:[NSString stringWithFormat:@"%d",integerNumberForRow+1]];
    [columnSolutionsArray addObject:[NSString stringWithFormat:@"%d",integerNumberForColumn]];

    lastDirection = @"D";
    moveNumber++;
    
    [self updateMoveNumberLabel];


}
-(void)moveUp
{
     //moves the walker up by subtracting one to the row number and adding the row and column values to the solution arrays for use during the next move and for the current position of the walker
    [[finalMazeArray objectAtIndex:integerNumberForRow-1]replaceObjectAtIndex:integerNumberForColumn withObject:[self getNextLetterOfAlpha]];
    [rowSolutionsArray addObject:[NSString stringWithFormat:@"%d",integerNumberForRow-1]];
    [columnSolutionsArray addObject:[NSString stringWithFormat:@"%d",integerNumberForColumn]];
    

    lastDirection = @"D";
    moveNumber++;
    
    [self updateMoveNumberLabel];
    [self printSolution];
    


}
-(void)moveLeft
{
     //moves the walker down by subtracting one from the column number and adding the row and column values to the solution arrays for use during the next move and for the current position of the walker
    [[finalMazeArray objectAtIndex:integerNumberForRow]replaceObjectAtIndex:integerNumberForColumn-1 withObject:[self getNextLetterOfAlpha]];
    
    [rowSolutionsArray addObject:[NSString stringWithFormat:@"%d",integerNumberForRow]];
    [columnSolutionsArray addObject:[NSString stringWithFormat:@"%d",integerNumberForColumn-1]];
    
    
    lastDirection = @"L";
    moveNumber++;
    
    [self updateMoveNumberLabel];
    [self printSolution];
   

}
-(void)moveRight
{
    //moves the walker down by adding one to the column number and adding the row and column values to the solution arrays for use during the next move and for the current position of the walker

    [[finalMazeArray objectAtIndex:integerNumberForRow]replaceObjectAtIndex:integerNumberForColumn+1 withObject:[self getNextLetterOfAlpha]];
    
    
    [rowSolutionsArray addObject:[NSString stringWithFormat:@"%d",integerNumberForRow]];
    [columnSolutionsArray addObject:[NSString stringWithFormat:@"%d",integerNumberForColumn+1]];
    
    
 
    lastDirection = @"R";
    moveNumber++;
    
    [self updateMoveNumberLabel];
    [self printSolution];
    
   
   
}
-(void)updateMoveNumberLabel
{
    //updates the number of moves label
    self.moveNumberLabel.text = [NSString stringWithFormat:@"Number of Moves: %d",moveNumber];
    
}
-(void)checkPaths
{
    //checks all available paths based on the current position of the walker. Classifies open paths and previously visited paths separately
    
    NSString * yString = [NSString stringWithFormat:@"%@",[columnSolutionsArray lastObject]];
    integerNumberForColumn = [yString intValue];
   

    
    NSString * xString = [NSString stringWithFormat:@"%@",[rowSolutionsArray lastObject]];
    integerNumberForRow = [xString intValue];
  
    //check to see if end of maze has been reached
   
    
    //put alphbet in set for comparison
     NSSet * alphaSet = [NSSet setWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];

    //cant test outside of main maze array
    if(integerNumberForRow>=1)
    {
        //look up for opening
        if([[[finalMazeArray objectAtIndex:integerNumberForRow-1]objectAtIndex:integerNumberForColumn]isEqualToString:@"_"])
        {
            NSLog(@"found opening up");
        
            [openingsArray addObject:@"U"];
        
        }
        if([alphaSet containsObject:[[finalMazeArray objectAtIndex:integerNumberForRow-1]objectAtIndex:integerNumberForColumn]])
        {
            NSLog(@"found used opening up");
            
            [openingsArray addObject:@"U2"];
            
        }
        
    }
    
    //look down for opening
    if([[[finalMazeArray objectAtIndex:integerNumberForRow+1]objectAtIndex:integerNumberForColumn]isEqualToString:@"_"])
    {
        [openingsArray addObject:@"D"];
    }
    if([alphaSet containsObject:[[finalMazeArray objectAtIndex:integerNumberForRow+1]objectAtIndex:integerNumberForColumn]])
    {
        [openingsArray addObject:@"D2"];
    }
    
    //look left for opening
    if([[[finalMazeArray objectAtIndex:integerNumberForRow]objectAtIndex:integerNumberForColumn-1]isEqualToString:@"_"])
    {
        [openingsArray addObject:@"L"];
    }
    if([alphaSet containsObject:[[finalMazeArray objectAtIndex:integerNumberForRow]objectAtIndex:integerNumberForColumn-1]])
    {
        [openingsArray addObject:@"L2"];
    }
    
    //look right for open path
    if([[[finalMazeArray objectAtIndex:integerNumberForRow]objectAtIndex:integerNumberForColumn+1]isEqualToString:@"_"]||[alphaSet containsObject:[[finalMazeArray objectAtIndex:integerNumberForRow]objectAtIndex:integerNumberForColumn+1]])
    {
        [openingsArray addObject:@"R"];
    }
    if([alphaSet containsObject:[[finalMazeArray objectAtIndex:integerNumberForRow]objectAtIndex:integerNumberForColumn+1]])
    {
        [openingsArray addObject:@"R2"];
    }
 
}

-(void)checkForEnd
{
    //checks if the walker reaches the end of the maze.  Based on walker's position and the size of the maze array
    NSString * yString = [NSString stringWithFormat:@"%@",[columnSolutionsArray lastObject]];
    integerNumberForColumn = [yString intValue];

    NSString * xString = [NSString stringWithFormat:@"%@",[rowSolutionsArray lastObject]];
    integerNumberForRow = [xString intValue];
   
    NSLog(@"End Check last solution number x: %d",integerNumberForRow);
    NSLog(@"End Check last solution number y: %d",integerNumberForColumn);
    
    if(integerNumberForRow+1>=finalMazeArray.count)
    {
        isMazedSolved = YES;
        self.solveButtonProperty.enabled = NO;
        self.notificationLabel.hidden = NO;
        [self zoomAnimation:self.notificationLabel];
        self.emailTextButtonProperty.hidden = NO;
        [self saveScore:[NSNumber numberWithInt:moveNumber]];
    }

}
-(void)saveScore:(NSNumber *)score
{
    //this method saves the score based on maze to nsuserdefaults to be used in the statistics view controller
    switch (mazeUsed)
    {
        case 1:
        {
            NSArray * array = [[NSArray alloc]init];
            array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"mazeOneScoreInterviewAppFranz"];
            NSMutableArray * scoreArray = [[NSMutableArray alloc]init];
            [scoreArray addObject:score];
            [scoreArray addObjectsFromArray:array];
            [[NSUserDefaults standardUserDefaults] setObject:scoreArray forKey:@"mazeOneScoreInterviewAppFranz"];
            
            
            break;
        }
        case 2:
        {
            NSArray * array = [[NSArray alloc]init];
            array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"mazeTwoScoreInterviewAppFranz"];
            NSMutableArray * scoreArray = [[NSMutableArray alloc]init];
            [scoreArray addObject:score];
            [scoreArray addObjectsFromArray:array];
            [[NSUserDefaults standardUserDefaults] setObject:scoreArray forKey:@"mazeTwoScoreInterviewAppFranz"];
            

            break;
        }
        case 3:
        {
            NSArray * array = [[NSArray alloc]init];
            array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"mazeThreeScoreInterviewAppFranz"];
            NSMutableArray * scoreArray = [[NSMutableArray alloc]init];
            [scoreArray addObject:score];
            [scoreArray addObjectsFromArray:array];
            [[NSUserDefaults standardUserDefaults] setObject:scoreArray forKey:@"mazeThreeScoreInterviewAppFranz"];
            

            break;
        }
        default:
            break;
    }
   
    
    
}
-(void)printSolution
{
    //method to display the current maze in the view with the walker
    NSArray * printArray = [[NSArray alloc]initWithArray:finalMazeArray copyItems:YES];
    NSString *  result = [[NSString alloc]init];
    
    for(int i = 0; i < numberOfRows ; i++)
    {
        result = [result stringByAppendingString:[[[printArray objectAtIndex:i] valueForKey:@"description"] componentsJoinedByString:@""]];
        result = [result stringByAppendingString:@"\n"];
    }
    
    [result stringByReplacingOccurrencesOfString:@"1" withString:@""];
    NSLog(@"Result String: %@",result);
    self.mazeTextView.text = result;
}
-(void)putMazeIntoArray
{
    //puts the initial maze file into an array.
    NSArray * mazeArray = [mazeString componentsSeparatedByString:@"\n"];

    
    NSString * firstRow = [mazeArray objectAtIndex:0];

    numberOfColumns =  firstRow.length;
    numberOfRows = mazeArray.count -1;
    
    
    for(int i = 0; i<numberOfRows; i++)
    {
        NSMutableArray *array = [NSMutableArray array];
        NSString *str = [mazeArray objectAtIndex:i];
        
        for (int t = 0; t < numberOfColumns; t++)
        {
            NSString *ch = [str substringWithRange:NSMakeRange(t, 1)];
            [array addObject:ch];
        }
        
    [finalMazeArray addObject:array];
    
    }
    
}

-(IBAction)loadMazeAction:(UIButton *)sender
{
    //button action method to load the maze
    switch (sender.tag)
    {
        case 1:
        {
            NSString * path = [[NSBundle mainBundle]pathForResource:@"maze" ofType:@"txt"];
            NSString * content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
            mazeString = content;
            NSLog(@"This is the string: %@",content);
            self.mazeTextView.text = mazeString;
            mazeUsed = 1;
            break;
        }
        case 2:
        {
            NSString * path = [[NSBundle mainBundle]pathForResource:@"maze2" ofType:@"txt"];
            NSString * content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
            mazeString = content;
            NSLog(@"This is the string: %@",content);
            self.mazeTextView.text = mazeString;
            mazeUsed = 2;
            break;
        }
        case 3:
        {
            NSString * path = [[NSBundle mainBundle]pathForResource:@"maze3" ofType:@"txt"];
            NSString * content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
            mazeString = content;
            NSLog(@"This is the string: %@",content);
            mazeUsed = 3;
            self.mazeTextView.text = mazeString;
            break;
        }
            
        default:
            break;
    }
    self.emailTextButtonProperty.hidden = YES;
    self.walkingDirectionLabel.hidden= NO;
    isMazedSolved = NO;
    self.notificationLabel.hidden = YES;
    self.solveButtonProperty.enabled = NO;
    self.moveNumberLabel.text = @"Number of Moves:";
    self.arrow.image = nil;
    self.currentPosition.text = @"";
    moveNumber = 0;
    facingDirection = @"";
   
    openRowValues = [[NSMutableArray alloc]init];
    openColumnValues = [[NSMutableArray alloc]init];
    rowSolutionsArray = [[NSMutableArray alloc]init];
    columnSolutionsArray = [[NSMutableArray alloc]init];
    lastDirection = @"D";
    finalMazeArray = [[NSMutableArray alloc]init];
    openingsArray = [[NSMutableArray alloc]init];
    

    [self resetAlphabet];
    
    
    
   
    
    [self putMazeIntoArray];
  //  [self findOpenSpacesInMaze];
    [self findBeginning];
    [self determineFace];
    
    self.solveButtonProperty.enabled = YES;
}

-(IBAction)solveMazeAction:(id)sender
{
    //button action method for the walker to complete one action
    [self moveMe];
    [self printSolution];
}

-(void)zoomAnimation:(UIView *)viewInput
{
    //method to animate the Solved label at the completion of the maze
    viewInput.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        //original 1.1
        viewInput.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.1, 2.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            //original .9
            viewInput.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.9, 1.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                viewInput.transform = CGAffineTransformIdentity;

                
            }];
        }];
    }];
  
    
}
-(IBAction)emailTextFileButton:(id)sender
{
    //method to mail solution.
    MailSingleton * myMailInstance = [MailSingleton sharedInstance];
    
    if ( [MFMailComposeViewController canSendMail] )
    {
        [myMailInstance.globalMailComposer setToRecipients:[NSArray arrayWithObjects:@"", nil]];
        [myMailInstance.globalMailComposer setSubject:@"Maze Solution"];
        [myMailInstance.globalMailComposer setMessageBody:self.mazeTextView.text isHTML:NO];
        myMailInstance.globalMailComposer.mailComposeDelegate = self;
      
        [self presentViewController:myMailInstance.globalMailComposer
                           animated:YES completion:nil];
    }
    else
    {
        [myMailInstance cycleTheGlobalMailComposer];
    }
    
  
}
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError *)error
{
    //delegate method of compose mail controller
    
 MailSingleton * myMailInstance = [MailSingleton sharedInstance];
    [self dismissViewControllerAnimated:YES completion:^
     { [myMailInstance cycleTheGlobalMailComposer]; }
     ];
}
@end
