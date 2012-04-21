//
//  Utilita.m
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilita.h"
#import "Reachability.h"

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

@implementation Utilita


+(BOOL)networkReachable {
    Reachability *r = [[Reachability reachabilityForInternetConnection] retain];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    BOOL result = NO;
    
    if(internetStatus == ReachableViaWWAN){
        //NSLog(@"3g");
        result =  YES;
        
    }
    else if(internetStatus == ReachableViaWiFi){
        //NSLog(@"Wifi");
        result = YES;
        
    }
    else if(internetStatus == NotReachable){
        result = NO;        
    }
    
    [r release];
    
    return  result;
}

+(NSString*)checkPhoneNumber:(NSString*) _phone{
    
    BOOL isPlus = FALSE;
    
    //NSLog(@"_PHONE = %@",_phone);
    
    //se il numero di telefono ha il prefisso internazionale che comincia con +
    if([[_phone substringWithRange:NSMakeRange(0,1)] isEqualToString:@"+"])
        isPlus = TRUE;
    
    NSMutableString *strippedString = [NSMutableString 
                                       stringWithCapacity:_phone.length+1];
    
    NSScanner *scanner = [NSScanner scannerWithString:_phone];
    NSCharacterSet *numbers = [NSCharacterSet 
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            
            //reinserisco il + ad inizio stringa
            if(isPlus){
                strippedString = [NSMutableString stringWithFormat:@"%2B"];
                isPlus = FALSE;
            }
            
            [strippedString appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    NSLog(@"STRIPPED STRING = %@",strippedString);

    return strippedString;
    
    /*
     if(![job.phone isEqualToString:@""] && [[job.phone substringWithRange:NSMakeRange(0,1)] isEqualToString:@"+"]){
     phoneTmp = [NSMutableString stringWithFormat:@"%@",job.phone];
     [phoneTmp setString:[phoneTmp stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"]];
     }
     else{
     phoneTmp = [NSMutableString stringWithFormat:@"%@",job.phone];
     }
     */

}

+(BOOL)isNumeric:(NSString*)inputString{
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}

+(BOOL)isStringEmptyOrWhite:(NSString*)string{
    
    //controlla che le stringhe non siano ne vuote ne formate da soli spazi bianchi
    if([allTrim(string) length] == 0)       
        return FALSE ;
    else return TRUE;
}

+(BOOL)isEmailValid:(NSString*)email{
    
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:email];

}

+(BOOL)isDateFormatValid:(NSString*)data{
    
 
    //controlla formato della stringa scadenza
    if([data isEqualToString:@"--/--"] || [[data substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"--"] || [[data substringWithRange:NSMakeRange(3, 2)] isEqualToString:@"--"]){
        return FALSE;
    }
    else return TRUE;
    
}


@end
