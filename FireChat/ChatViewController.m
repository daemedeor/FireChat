//
//  ChatViewController.m
//  FireChat
//
//  Created by Justin Wong on 8/4/15.
//  Copyright (c) 2015 TEST. All rights reserved.
//

#import "ChatViewController.h"

#import "ChatEngine.h"
#import "MeTableViewCell.h"
#import "ThemTableViewCell.h"

@interface ChatViewController ()<ChatEngineDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblChat;
@property (weak, nonatomic) IBOutlet UITextField *txtTroll;
@property (strong, nonatomic) NSMutableArray *arrMessages;

@property(nonatomic, strong) ChatEngine *cEngine;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cEngine = [ChatEngine new];
    self.cEngine.delegate = self;
    self.arrMessages = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(adjustView:)
                                                name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(adjustView:)
                                                name:UIKeyboardWillHideNotification object:nil];
}

-(void)adjustView:(NSNotification*)sender{
    CGRect frameBegin = [sender.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect frameEnd = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float yMod = frameEnd.origin.y - frameBegin.origin.y ;
    
    float animDuration = [sender.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animDuration animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y+ yMod);
    }];
}

-(void)messagedRecieved:(NSString *)strMessage{
    [self.arrMessages addObject: @{ @"cellType" : @"themCell",
                                    @"message" : strMessage}];
    [self.tblChat reloadData];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if( textField.text.length > 0 && textField != self.txtTroll){
        [self.arrMessages addObject: @{ @"cellType" : @"meCell",
                                        @"message" : textField.text}];
    
        [self.cEngine advertiseMessage:textField.text withTrollName: self.txtTroll.text];
        
        textField.text = @"";
        
        [self.tblChat reloadData];
    }
    return YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrMessages.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellType = [self.arrMessages[indexPath.row] objectForKey:@"cellType"];
    
    if( [cellType isEqualToString:@"meCell"] ){
        MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType forIndexPath:indexPath];
        cell.lblMe.text = [self.arrMessages[indexPath.row] objectForKey:@"message"];
        return cell;
    }
    else{   //them cell
        ThemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType forIndexPath:indexPath];
        cell.lblThem.text = [self.arrMessages[indexPath.row] objectForKey:@"message"];
        return cell;
    }
}

@end
