//
//  CardViewController.h
//  PerDueEse
//
//  Created by mario greco on 07/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CartaPerDue;

@interface CardViewController : UIViewController

@property(nonatomic, retain) IBOutlet UILabel *validateLabel;
-(void)fillCardInfo:(CartaPerDue*)card;
@end
