//
//  MSpeedyPayViewController.m
//  MrMoney
//
//  Created by xingyong on 14-4-2.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MSpeedyPayViewController.h"
#import "MOrderData.h"
#import "MPayViewController.h"
#import "UIViewController+MaryPopin.h"
#import "MHomeViewController.h"

@interface MSpeedyPayViewController ()<MPayViewControllerDelegate>
@property(nonatomic,strong) NSString *bankCode;
@property(nonatomic,strong) NSString *orderNo;
@property (nonatomic,strong) MDropDownListView *listView;
@property (nonatomic,strong) NSMutableArray  *arryList;
@end

@implementation MSpeedyPayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [_backImageView setImage:[[UIImage imageNamed:@"home_input"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [_backImageView2 setImage:[[UIImage imageNamed:@"home_input"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    
    _balanceLabel.text = STRING_FORMAT(@"￥%@",formatValue(_canInvestMoney));
    
    self.bankCode = @"qianbb";
    
}
#pragma mark -------------  快捷支付 点击 -----------------

-(IBAction)onSpeedPayAction:(id)sender{
    [_passwordTf resignFirstResponder];
    [_balanceTf resignFirstResponder];
 
    NSString *password = MSMD5(_passwordTf.text);
    
    if (![password isEqualToString:user_defaults_get_string(@"KPASSWORD")]) {
        [MActionUtility showAlert:@"账户密码错误"];
        return;
    }

    if (![self.bankCode isEqualToString:@"qianbb"]) {
        submitAction = [[MSubmitOrderAction alloc] init];
        submitAction.m_delegate = self;
        [submitAction requestAction];
        
    }
    else
    {
        balanceAction = [[MBalanceAction alloc] init];
        balanceAction.m_delegate = self;
        [balanceAction requestAction];
    }
    
    
    [self showHUD];
    
}

#pragma mark --
#pragma mark -- balance delegate
-(NSDictionary*)onRequestBalanceAction{
    
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:3];
    
    [dict setSafeObject:userMid() forKey:@"mId"];
    
    [dict setSafeObject:self.starData.mstar_pid forKey:@"pid"];
    
    [dict setSafeObject:[NSNumber numberWithFloat:[_balanceTf.text floatValue]] forKey:@"investMoney"];
    
    return dict;
}
-(void)onResponseBalanceSuccess:(NSString *)orderNo{
    [self hideHUD];
    [self.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
        
        self.successBlock(orderNo);
         
    }];
    
 
}
-(void)onResponseBalanceFail{
    
    [self hideHUDWithCompletionFailMessage:@"交易失败"];
}



#pragma mark --
#pragma mark -- submitOrder delegate
-(NSDictionary*)onRequestSubmitOrderAction{
    
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:0];
    
    [dict setSafeObject:userMid()                    forKey:@"mId"];
    [dict setSafeObject:self.starData.mstar_pid      forKey:@"pid"];
    [dict setSafeObject:self.bankCode                forKey:@"instCode"];
    [dict setSafeObject:[MUtility deviceIPAdress]    forKey:@"buyerIp"];
    
    [dict setSafeObject:[NSNumber numberWithInt:[_balanceTf.text intValue]*100] forKey:@"money"];
    [dict setSafeObject:[MDataInterface commonParam:@"kmobile"] forKey:@"mobile"];
    
    [dict setSafeObject:[NSNumber numberWithInt:0]    forKey:@"quickPass"];
    
    
    return dict;
}
-(void)onResponseSubmitOrderSuccess:(MOrderData *)orderData{
    
    [self hideHUD];
    
    [self.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
        
        self.payBlock(orderData,[_balanceTf.text floatValue]);
 
    }];
    

}
-(void)onResponseSubmitOrderFail{
    
    [self hideHUD];
}

#pragma mark ------------- DropDownListView delegate  -----------------

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size {
    
    _listView = [[MDropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size];
    _listView.delegate = self;
    [_listView showInView:self.view animated:YES];
    
    
}
- (void)dropDownListView:(MDropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    
    [_listView fadeOut];
    
    NSDictionary *bankDict =  [KPAY_DICT objectForKey:STRING_FORMAT(@"%d",anIndex)];
    self.bankCode = [MUtility payName:[bankDict objectForKey:@"bank"]];

    if (anIndex == 0) {
        
        _unuseLabel.hidden = NO;
        _balanceLabel.hidden = NO;
        _bankLabel.hidden = YES;
        _bankLabel.text = STRING_FORMAT(@"￥%@",formatValue(_canInvestMoney));
        
    }else{
        
        _bankLabel.hidden = NO;
        _unuseLabel.hidden = YES;
        _balanceLabel.hidden = YES;
        _bankLabel.text = STRING_FORMAT(@"已选%@网银支付",[bankDict objectForKey:@"name"]);
    }
    
    
}
 

//#pragma mark ------------- 支付成功 通知  -----------------
//
//-(void)payResultNotify{
//    
//    [MActionUtility showAlert:@"购买提示" message:@"请确认您这次购买产品的结果" delegate:self cancelButtonTitle:@"遇到问题？" otherButtonTitles:@"支付成功",nil];
//    
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    if (buttonIndex == 1) {
//        //支付成功  发送通知 让首页更改数据显示
//        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTITICATION_BLANCE object:nil];
//        
//        [MGo2PageUtility go2MWebBrowser:self title:@"支付结果" webUrl:KSHOW_RECORD(self.orderNo)];
//        
//    }
//    
//}

-(IBAction)onSwitchPayAction:(id)sender{
    NSInteger index = [(UIButton *)sender tag];
    
    if (index == 1) {
        [self.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
            
        }];
    }else if (index == 2){
        
        self.arryList =  [NSMutableArray arrayWithArray: [[KPAY_DICT allKeys] sortedArrayUsingSelector:@selector(compare:)]];
        
        [self showPopUpWithTitle:STRING_FORMAT(@"%f",_canInvestMoney) withOption:_arryList xy:CGPointMake(0.,0.) size:CGSizeMake(300, 240)];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
