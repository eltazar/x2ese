 //
//  DatabaseAccess.m
//  jobFinder
//
//  Created by mario greco on 25/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DatabaseAccess.h"
//#import "NSDictionary_JSONExtensions.h"
//#import "CJSONDeserializer.h"


@implementation DatabaseAccess
@synthesize delegate;


#warning sistemare questa classe
// cercare di riciclare il codice invece di duplicare sempre le stesse istruzioni

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        //connectionDictionary = [[NSMutableDictionary alloc] init];
        dataDictionary = [[NSMutableDictionary alloc] init];
        readConnections = [[NSMutableArray alloc]init];
        writeConnections = [[NSMutableArray alloc]init];
    }
    
    return self;
}

NSString* key(NSURLConnection* con)
{
    return [NSString stringWithFormat:@"%p",con];
}

-(void)registerCompany:(NSString*)pin token:(NSString *)token{
    
    NSLog(@"DBACCESS REGISTER ");
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://cartaperdue.it/partner/app_esercenti/registerCompany.php"];
    
    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *postFormatString = @"pin=%@&token=%@";
    NSString *postString = [NSString stringWithFormat:postFormatString,pin,token];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];  
    
    
    
    if(connection){
        //NSLog(@"IS CONNECTION TRUE");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [writeConnections addObject:connection];
        
        NSMutableData *receivedData = [[NSMutableData data] retain];
        //[connectionDictionary setObject:connection forKey:key(connection)];
        [dataDictionary setObject:receivedData forKey:key(connection)];
        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
    }
    else{
        NSLog(@"theConnection is NULL");
        //mostrare alert all'utente che la connessione è fallita??
    }
}



-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"DID RECEIVE RESPONSE");
    
    NSMutableData *receivedData = [dataDictionary objectForKey:key(connection)];

    [receivedData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //sto log crea memory leak
    //NSLog(@"XXXX %@",[[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSASCIIStringEncoding]);
    NSMutableData *receivedData = [dataDictionary objectForKey:key(connection)];

    [receivedData appendData:data];
    //NSLog(@"RECEIVED DATA AFTER APPENDING %@",receivedData);
}

//If an error is encountered during the download, the delegate receives a connection:didFailWithError:
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSMutableData *receivedData = [dataDictionary objectForKey:key(connection)];
    [dataDictionary removeObjectForKey:key(connection)];
    
    [readConnections removeObject:connection];
    [writeConnections removeObject:connection];
    
    //esempio se richiedo connessione quando rete non disponibile, mostrare allert view?
    NSLog(@"ERROR with theConenction");
    
    if(delegate && [delegate respondsToSelector:@selector(didReceiveError:)])
        [delegate didReceiveError:error];
    
    [connection release];
    [receivedData release];
}

//if the connection succeeds in downloading the request, the delegate receives the connectionDidFinishLoading:
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSMutableData *receivedData = [dataDictionary objectForKey:key(connection)];

    //NSLog(@"DONE. Received Bytes: %d", [receivedData length]);
    NSString *json = [[NSString alloc] initWithBytes: [receivedData mutableBytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
    //NSLog(@"JSON  %@", json);
    
    
    
    if([readConnections containsObject:connection]){
        //creo array di job
        NSError *theError = NULL;
        //NSArray *dictionary = [NSMutableDictionary dictionaryWithJSONString:json error:&theError];
       // NSLog(@"TIPO DEL DIZIONARIO %@",[dictionary class]);
       // NSLog(@"%@",dictionary);
      
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        
       /* NSDictionary *dic = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&theError] retain];
        
        if(dic){
            //NSLog(@"DIZIONARIO MARIO \n: %@",dic);
            if(delegate &&[delegate respondsToSelector:@selector(didReceiveCoupon:)])
                [delegate didReceiveCoupon:dic];
        }
        
        if (theError) NSLog(@"DatabaseAccess, JSONError: reason[%@] desc[%@,%@]", [theError localizedFailureReason], [theError description], [theError localizedDescription]);
        */
//        if(dictionary != nil){
//            NSMutableArray *jobsArray = [[NSMutableArray alloc]initWithCapacity:dictionary.count];
//        
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"yyyy-MM-dd"];
//            //    return [f dateFromString:dateString];
//            //NSLog(@"FORMATTER = %p",formatter);
//           for(int i=0; i < dictionary.count-1; i++){
//               NSDictionary *tempDict = [dictionary objectAtIndex:i];
//               CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[tempDict objectForKey:@"latitude"] doubleValue],[[tempDict objectForKey:@"longitude"] doubleValue]);        
//               Job *job = [[[Job alloc] initWithCoordinate:coordinate] autorelease]; //aggiunto 7 nov
//                           
//                //sistemare il tipo ritornato da field e da date
//               //job.employee = [Utilities sectorFromCode:[tempDict objectForKey:@"field"]];
//               job.time = [tempDict objectForKey:@"time"];
//               job.idDb = [[tempDict objectForKey:@"id"] integerValue];
//               job.code = [tempDict objectForKey:@"field"];
//               job.date = [formatter dateFromString: [tempDict objectForKey:@"date"]];
//               job.description = [tempDict objectForKey:@"description"];
//               job.address = @"";
//               job.phone = [tempDict objectForKey:@"phone"];
//               job.phone2 = [tempDict objectForKey:@"phone2"];
//               //NSLog(@"########### email = %@",[tempDict objectForKey:@"email"] );
//               job.email = [tempDict objectForKey:@"email"];
//               [job setUrlWithString:[tempDict objectForKey:@"url"]];
//               job.user = [tempDict objectForKey:@"user"];
//                
//                [jobsArray addObject:job];
//            }
//            
//            if(delegate != nil &&[delegate respondsToSelector:@selector(didReceiveJobList:)])
//                [delegate didReceiveJobList:jobsArray];
//            
//            [jobsArray release];
//            [formatter release];
//            formatter = nil;
//        }
        
        [readConnections removeObject:connection];
       
    }else{ 
        if(delegate && [delegate respondsToSelector:@selector(didReceiveResponsFromServer:)])
             [delegate didReceiveResponsFromServer:json];
        [writeConnections removeObject:connection];
    }
        //rilascio risorse, come spiegato sula documentazione apple
    [json release];
    
    [dataDictionary removeObjectForKey:key(connection)];
    
//    [readConnections removeObject:connection];
//    [writeConnections removeObject:connection];
    
    [connection release];
    [receivedData release];
}


-(void)dealloc
{
    [readConnections release];
    [writeConnections release];
    [dataDictionary release];
    [super dealloc];
}

 
@end
