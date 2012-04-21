//
//  ReceivedCardsController.h
//  PerDueEse
//
//  Created by mario greco on 21/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceivedCardsController : UITableViewController

@property (nonatomic, retain) NSMutableArray *sectionDescription;
@property (nonatomic, retain) NSMutableArray *sectionData;

- (NSMutableArray*)creaDataContent;
@end
