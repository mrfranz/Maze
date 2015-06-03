#import "MailSingleton.h"

@implementation MailSingleton

static MailSingleton * _sharedInstance;

- (id)init
{
    self = [super init];
    if (self) {
        [self cycleTheGlobalMailComposer];
        // Your initialization code goes here
        
    }
    return self;
}

+ (MailSingleton *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(void)cycleTheGlobalMailComposer
{
    // we are cycling the damned GlobalMailComposer... due to horrible iOS issue
    self.globalMailComposer = nil;
    self.globalMailComposer = [[MFMailComposeViewController alloc] init];
}
@end
