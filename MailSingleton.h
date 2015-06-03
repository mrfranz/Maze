#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface MailSingleton : NSObject
@property (nonatomic, strong) MFMailComposeViewController *globalMailComposer;

+(MailSingleton *)sharedInstance;
-(void)cycleTheGlobalMailComposer;


@end
