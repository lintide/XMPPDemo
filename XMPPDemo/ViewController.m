//
//  ViewController.m
//  XMPPDemo
//
//  Created by Teddy Lin on 12/31/14.
//  Copyright (c) 2014 Zhimei Inc. All rights reserved.
//

#import "ViewController.h"
#import <XMPPFramework/XMPP.h>

@interface ViewController ()<XMPPStreamDelegate>

@property (strong, nonatomic) XMPPStream *stream;

- (IBAction)sendMessage:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.stream = [[XMPPStream alloc] init];
    self.stream.myJID = [XMPPJID jidWithString:@"lintide@teddys-mac-mini.local"];
    [self.stream setHostName:@"192.168.1.119"];
    
    [self.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error;
    [self.stream connectWithTimeout:30 error:&error];
    if (error) {
        NSLog(@"connect error: %@", error);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)sendMessage:(id)sender {
    if (![self.stream isAuthenticated]) {
        return;
    }
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:@"hello"];
    
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    [mes addAttributeWithName:@"to" stringValue:@"teddy@teddys-mac-mini.local"];
    [mes addAttributeWithName:@"from" stringValue:@"lintide@teddys-mac-mini.local"];
    [mes addChild:body];
    
    
    
    [self.stream sendElement:mes];
}

#pragma mark -  XMPP delegate

- (void)xmppStreamWillConnect:(XMPPStream *)sender {
    NSLog(@"xmppStreamWillConnect");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"xmppStreamDidConnect");
    
    NSError *error;
    [self.stream authenticateWithPassword:@"123456" error:&error];
    
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"xmppStreamDidAuthenticate");
    
    XMPPPresence *pre = [XMPPPresence presence];
    [self.stream sendElement:pre];
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
    NSLog(@"didSendMessage");
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    NSLog(@"message = %@", message);
    
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:msg forKey:@"msg"];
//    [dict setObject:from forKey:@"sender"];
    
    //消息委托(这个后面讲)
//    [messageDelegate newMessageReceived:dict];
    
}

@end
