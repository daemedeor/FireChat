//
//  ChatEngine.h
//  FireChat
//
//  Created by Justin Wong on 8/4/15.
//  Copyright (c) 2015 TEST. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChatEngineDelegate <NSObject>

-(void)messagedRecieved:(NSString *)strMessage;

@end

@interface ChatEngine : NSObject

@property(nonatomic, weak) id<ChatEngineDelegate> delegate;

-(void)advertiseMessage:(NSString*)strMessage withTrollName: (NSString *)strTrollName;

@end
