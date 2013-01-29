//
//  RecognizeImPlugin.h
//  Assistant2
//
//  Created by Alessio Basso on 1/25/13.
//
//

#import <Cordova/CDV.h>

@interface RecognizeImPlugin : CDVPlugin <NSURLConnectionDataDelegate>

@property (nonatomic, retain) NSMutableDictionary* callbackIds;

//- (void)match:(CDVInvokedUrlCommand*)command;
- (void)match:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;

@end
