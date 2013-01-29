//
//  RecognizeImPlugin.m
//  Assistant2
//
//  Created by Alessio Basso on 1/25/13.
//
//

#import "RecognizeImPlugin.h"
#import <Cordova/CDV.h>

#import "ItraffApi.h"

@implementation RecognizeImPlugin

@synthesize callbackIds = _callbackIds;

- (NSMutableDictionary*)callbackIds {
	if(_callbackIds == nil) {
		_callbackIds = [[NSMutableDictionary alloc] init];
	}
	return _callbackIds;
}

//- (void)match:(CDVInvokedUrlCommand*)command
- (void)match:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options
{
    /*
    NSString* client = [command.arguments objectAtIndex:0];
    NSString* clientKey = [command.arguments objectAtIndex:1];
    NSString* img = [command.arguments objectAtIndex:2];
    */
    NSString* client = [options objectForKey:@"client"];
    NSString* clientKey = [options objectForKey:@"clientKey"];
    NSString* img = [options objectForKey:@"img"];

    /*_callbackId = command.callbackId;*/
    [self.callbackIds setValue:[arguments pop] forKey:@"match"];
    
    /*
    NSData *dataObj = [NSData dataWithBase64EncodedString:img];
    UIImage *beforeImage = [UIImage imageWithData:dataObj];
    */
    NSString *str = @"data:image/jpg;base64,";
    str = [str stringByAppendingString:img];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
    UIImage *imageObj = [UIImage imageWithData:imageData];
    
    
    [[[ItraffApi alloc] initWithKey:client :clientKey] send:imageObj :self];
    
    /*
     if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
     */
}

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    return request;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //[responseText setText:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
    
    //[self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
    [self writeJavascript:[pluginResult toSuccessCallbackString:[self.callbackIds valueForKey:@"match"]]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error", nil) message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[error description]];
    
    //[self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
    [self writeJavascript:[pluginResult toErrorCallbackString:[self.callbackIds valueForKey:@"match"]]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end