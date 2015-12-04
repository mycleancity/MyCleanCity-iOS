//
//  CommentController.m
//  MyCleanCity
//
//  Created by fliptoo on 3/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "CommentController.h"
#import "CommentCell.h"
#import "FAKIonIcons.h"
#import "Api+Comment.h"
#import "Comment.h"
#import "Cache.h"
#import "FAKIonIcons.h"
#import "UIViewController+BarButtonItem.h"
#import "UIViewController+Back.h"

static NSString *identifier = @"Cell";

@interface CommentController ()

@property (nonatomic, strong) NSMutableArray *comments;

@end

@implementation CommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UIBarButtonItem *backItem = [self barButtonItem:[FAKIonIcons iosArrowBackIconWithSize:25]
                                             action:@selector(back:)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    
    self.title = @"Comment";
    self.msgField.placeholder = @"Write a comment...";
    self.msgField.delegate = self;
    self.comments = [[NSMutableArray alloc] init];
    
    FAKIcon *sendIcon = [FAKIonIcons iosPaperplaneIconWithSize:30];
    [sendIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    [self.sendButton setImage:[sendIcon imageWithSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    
    if (self.complaintID) {
        [Api complaintComments:self.complaintID last:nil size:200 success:^(NSArray *comments) {
            [self.comments addObjectsFromArray:comments];
            [self.table reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    } else if (self.culpritID) {
        [Api culpritComments:self.culpritID last:nil size:200 success:^(NSArray *comments) {
            [self.comments addObjectsFromArray:comments];
            [self.table reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    } else if (self.thinkBoxID) {
        [Api thinkboxComments:self.thinkBoxID last:nil size:200 success:^(NSArray *comments) {
            [self.comments addObjectsFromArray:comments];
            [self.table reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - IBAction

- (IBAction)send:(id)sender
{
    if(self.msgField.text.length == 0)return;
    
    self.sendButton.hidden = true;
    
    if (self.complaintID) {
        [Api sendComplaintComments:self.complaintID story:self.msgField.text success:^(Comment *comment) {
            self.sendButton.hidden = false;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.sendButton.hidden = false;
        }];
    } else if (self.culpritID) {
        [Api sendCulpritComments:self.culpritID story:self.msgField.text success:^(Comment *comment) {
            self.sendButton.hidden = false;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.sendButton.hidden = false;
        }];
    } else if (self.thinkBoxID) {
        [Api sendThinkBoxComments:self.thinkBoxID story:self.msgField.text success:^(Comment *comment) {
            self.sendButton.hidden = false;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.sendButton.hidden = false;
        }];
    }

    [self.msgField resignFirstResponder];
    Comment *comment = [[Comment alloc] init];
    comment.story = self.msgField.text;
    comment.date = [NSDate date];
    comment.user = [Cache objectForKey:kUserMe];
    
    [self.comments addObject:comment];
    [self.table reloadData];
    [self scrollToBottom:YES];
    self.msgField.text = nil;
}

#pragma mark - Private

- (void)scrollToBottom:(BOOL)animated
{
    if (self.comments.count == 0) return;
    
    NSIndexPath *ipath = [NSIndexPath indexPathForRow:self.comments.count-1 inSection:0];
    [self.table scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated:animated];
}

#pragma mark - Notification Methods

- (void)onKeyboardWillShow:(NSNotification*)notification
{
    self.table.userInteractionEnabled = NO;
    
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
//    CGRect containerFrame = self.holder.frame;
//    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    
    CGRect tableFrame = self.table.frame;
    tableFrame.origin.y = 40 - keyboardBounds.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    //self.holder.frame = containerFrame;
    self.holderContraint.constant = keyboardBounds.size.height;
    self.table.frame = tableFrame;
    [self.holder layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (void)onKeyboardWillHide:(NSNotification*)notification
{
    self.table.userInteractionEnabled = YES;
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
//    CGRect containerFrame = self.holder.frame;
//    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    CGRect tableFrame = self.table.frame;
    tableFrame.origin.y = 40;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    //self.holder.frame = containerFrame;
    self.table.frame = tableFrame;
    self.holderContraint.constant = 0.0f;
    [self.holder layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [self send:nil];
        return NO;
    }
    
    if([[textView text] length] > 100){
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell update:[self.comments objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        return UITableViewAutomaticDimension;
    }
    
    static CommentCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [self.table dequeueReusableCellWithIdentifier:identifier];
    });
    
    [cell update:[self.comments objectAtIndex:indexPath.row]];
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.table.frame), CGRectGetHeight(cell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
}

@end
