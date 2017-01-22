//
//  TextDownloader.m
//  Quzipedia
//
//  Created by akshay bansal on 1/21/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "TextDownloader.h"

@implementation TextDownloader
+(instancetype)sharedInstance{
    
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)DownloadData
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURL *url = [NSURL URLWithString:@"https://en.wikipedia.org/w/api.php?format=json&action=query&generator=random&grnnamespace=0&prop=extracts&exsentences=10&explaintext="];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error && data!=nil)
        {
            if ([response isKindOfClass:[NSHTTPURLResponse class]])
            {
                NSError *jsonError=nil;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                
                if (jsonError) {
                    NSLog(@"Json Parsing Error");
                }
                else {
                    if ([[jsonResponse allKeys] containsObject:@"query"]) {
                        
                        NSDictionary *pages= [[jsonResponse objectForKey:@"query"] objectForKey:@"pages"];
                        NSString *WikiExtract=[[pages objectForKey:[[pages allKeys] objectAtIndex:0]] objectForKey:@"extract"];

                        NSLog(@"%@",WikiExtract);
                        [self.delegate DownLoadCompletedWithData:WikiExtract];

                    }
                    
                }
            }
            else
            {
                NSLog(@"Response Error");
            }
        }
        else
        {
            NSLog(@"error : %@", error.description);
        }
    }] ;
    
    [postDataTask resume];
}




@end