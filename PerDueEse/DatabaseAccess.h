//
//  DatabaseAccess.h
//  jobFinder
//
//  Created by mario greco on 25/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString* key(NSURLConnection* con);

@protocol DatabaseAccessDelegate;

@interface DatabaseAccess : NSObject <NSURLConnectionDelegate>{
    //NSMutableData *receivedData;
    id<DatabaseAccessDelegate> delegate;
    //NSMutableDictionary *connectionDictionary;
    NSMutableDictionary *dataDictionary;
    NSMutableArray *readConnections;
    NSMutableArray *writeConnections;
    
    NSMutableData *responseData;
    
}

@property(nonatomic,assign) id<DatabaseAccessDelegate> delegate;

-(void)registerCompany:(NSString*)pin token:(NSString*)token;
@end


@protocol DatabaseAccessDelegate <NSObject>
@optional
-(void)didReceiveResponsFromServer:(NSString*) receivedData;
@optional
-(void)didReceiveCoupon:(NSDictionary*)coupon;
-(void)didReceiveError:(NSError*)error;
@end