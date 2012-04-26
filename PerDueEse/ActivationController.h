//
//  SecondViewController.h
//  PerDueEse
//
//  Created by mario greco on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"

@interface ActivationController : UIViewController<DatabaseAccessDelegate>
{
    DatabaseAccess *dbAccess;
    
}

-(IBAction)sendPinBtnClicked:(id)sender;
-(void)launchQuery:(NSString*)token;
@end
