//
//  DropDownListView.m
//  KDropDownMultipleSelection
//
//  Created by macmini17 on 03/01/14.
//  Copyright (c) 2014 macmini17. All rights reserved.
//

#import "DropDownListView.h"
#import "DropDownViewCell.h"
#import "MPayView.h"
#import "MBankView.h"
#define DROPDOWNVIEW_SCREENINSET 0
#define DROPDOWNVIEW_HEADER_HEIGHT 43
#define RADIUS 0


@interface DropDownListView (private)
- (void)fadeIn;
- (void)fadeOut;
@end
@implementation DropDownListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple
{
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
 
    isMultipleSelection=isMultiple;
    CGRect rect = CGRectMake(point.x, point.y,size.width,size.height);
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor clearColor];
        _kTitleText = [aTitle copy];
        _kDropDownOption = [aOptions copy];
        self.arryData=[[NSMutableArray alloc]init];
        
        
        MBankView *bankView = [[[NSBundle mainBundle] loadNibNamed:@"MBankView" owner:self options:nil] lastObject];
        bankView.frame = rect;
        [bankView.backBtn addTarget:self action:@selector(fadeOut) forControlEvents:UIControlEventTouchUpInside];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, DROPDOWNVIEW_HEADER_HEIGHT, 300, 320 - DROPDOWNVIEW_HEADER_HEIGHT)];
        
        _tableView.rowHeight = 50.;
        _tableView.backgroundColor = KVIEW_BACKGROUND_COLOR;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [bankView addSubview:_tableView];
        
        
        _payView = [[[NSBundle mainBundle] loadNibNamed:@"MPayView" owner:self options:nil] lastObject];
        _payView.frame = rect;
 
        if (![aTitle containsString:@"￥"]) {
            _payView.bankLabel.text = STRING_FORMAT(@"已选%@网银支付",_kTitleText);
            _payView.bankLabel.hidden = NO;
            _payView.investMoneyLabel.hidden = YES;
            _payView.titleMarkLabel.hidden = YES;
        }else{
            _payView.investMoneyLabel.text = _kTitleText;
            _payView.bankLabel.hidden = YES;
            _payView.investMoneyLabel.hidden = NO;
            _payView.titleMarkLabel.hidden = NO;
        }
        
        [_payView.backBtn addTarget:self action:@selector(fadeOut) forControlEvents:UIControlEventTouchUpInside];
        [_payView.switchBtn addTarget:self action:@selector(Click_Done) forControlEvents:UIControlEventTouchUpInside];
        [_payView.payBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        
        if (isMultipleSelection) {
            [self addSubview:_payView];
            
        }else{
            [self addSubview:bankView];
        }
        
    }
    return self;
}
-(void)submit{
    NSString *password = MSMD5(_payView.passwordTf.text);
    if (![password isEqualToString:user_defaults_get_string(@"KPASSWORD")]) {
        [MActionUtility showAlert:@"账户密码错误"];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(DropDownListViewDidButtonClick:bankId:)]) {
        [self.delegate DropDownListViewDidButtonClick:[_payView.moneyTf.text floatValue] bankId:_kTitleText];
    }
}
-(void)Click_Done{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(DropDownListView:Datalist:)]) {
        NSMutableArray *arryResponceData=[[NSMutableArray alloc]init];
        NSLog(@"%@",self.arryData);
        for (int k=0; k<self.arryData.count; k++) {
            NSIndexPath *path=[self.arryData objectAtIndex:k];
            [arryResponceData addObject:[_kDropDownOption objectAtIndex:path.row]];
            NSLog(@"pathRow=%d",path.row);
        }
        
        [self.delegate DropDownListView:self Datalist:arryResponceData];
        
    }
    
    [self fadeOut];
}
#pragma mark - Private Methods
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    _overlayView.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        _overlayView.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
        _overlayView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            [_overlayView removeFromSuperview];
        }
    }];
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    
    if (animated) {
        [self fadeIn];
    }
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_kDropDownOption count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"Cell";
    
    DropDownViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==nil) {
        cell = [[DropDownViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentity];
    }
    
    int row = [indexPath row];
    
    NSString *bankOrderkey =  [_kDropDownOption safeObjectAtIndex:row];
    
    NSDictionary *cellDict = [KPAY_DICT objectForKey:bankOrderkey];
    cell.imageView.image = bankLogoImage([cellDict objectForKey:@"bank"]);
    cell.textLabel.text = [cellDict objectForKey:@"name"];
    if (row == 0) {
        
        cell.detailTextLabel.text = STRING_FORMAT(@"%@%@",[cellDict objectForKey:@"content"],_kTitleText);
    }else{
        cell.detailTextLabel.text =[cellDict objectForKey:@"content"];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(DropDownListView:didSelectedIndex:)]) {
        [self.delegate DropDownListView:self didSelectedIndex:[indexPath row]];
    }
    
    [self fadeOut];
    
	
}

@end
