//
//  MLockViewController.m
//  MrMoney
//
//  Created by xingyong on 14-3-3.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MLockViewController.h"
#import "MUserData.h"
@interface MLockViewController ()
@property (nonatomic) NSInteger wrongGuessCount;
@end

@implementation MLockViewController

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
    self.lockView.normalGestureNodeImage = [UIImage imageNamed:@"gesture_node_normal.png"];
    self.lockView.selectedGestureNodeImage = [UIImage imageNamed:@"gesture_node_selected.png"];
    self.lockView.lineColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    self.lockView.lineWidth = 12;
    self.lockView.delegate = self;
    self.lockView.contentInsets = UIEdgeInsetsMake(150, 20, 100, 20);
    [_thumbnail.layer borderWidth:1.0 borderColor:KCLEAR_COLOR cornerRadius:5.0];
    NSArray *array = [MUserData allDbObjects];
    if ([array isEmpty]) {

        MUserData *data = [array objectAtIndex:0];
        self.infoLabel.text = [MUtility securePhoneNumber: data.mmobile];
        [_thumbnail setImageWithURL:KAVATAR_PATH(data.mmid,data.miconPath)];
        
    }
    
    NSString * pattern = user_defaults_get_string(kCurrentPattern);
    
    if ([pattern isEqualToString:@""]) {
        _resetPasswordBtn.hidden = NO;
        _forgetPasswordBtn.hidden = YES;
    }else{
        _resetPasswordBtn.hidden = YES;
        _forgetPasswordBtn.hidden = NO;
    }
     
}

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didBeginWithPasscode:(NSString *)passcode{
    NSLog(@"begin----%@",passcode);
}

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode{
   
    
	switch (self.infoLabelStatus) {
		case InfoStatusFirstTimeSetting:
            user_defaults_set_string(kCurrentPatternTemp, passcode);
 
			self.infoLabelStatus = InfoStatusConfirmSetting;
			[self updateOutlook];
			break;
		case InfoStatusFailedConfirm:
            user_defaults_set_string(kCurrentPatternTemp, passcode);
 
			self.infoLabelStatus = InfoStatusConfirmSetting;
			[self updateOutlook];
			break;
		case InfoStatusConfirmSetting:
          
			if([passcode isEqualToString:user_defaults_get_string(kCurrentPatternTemp)]) {
 
                user_defaults_set_string(kCurrentPattern, passcode);
				[self dismissViewControllerAnimated:YES completion:nil];
			}
			else {
				self.infoLabelStatus = InfoStatusFailedConfirm;
				[self updateOutlook];
			}
			break;
		case  InfoStatusNormal:
       
			if([passcode isEqualToString:user_defaults_get_string(kCurrentPattern)]) [self dismissViewControllerAnimated:YES completion:nil];
			else {
				self.infoLabelStatus = InfoStatusFailedMatch;
				self.wrongGuessCount ++;
				[self updateOutlook];
			}
			break;
		case InfoStatusFailedMatch:
			if([passcode isEqualToString:user_defaults_get_string(kCurrentPattern)]) [self dismissViewControllerAnimated:YES completion:nil];
			else {
				self.wrongGuessCount ++;
				self.infoLabelStatus = InfoStatusFailedMatch;
				[self updateOutlook];
			}
			break;
		case InfoStatusSuccessMatch:
			[self dismissViewControllerAnimated:YES completion:nil];
			break;
			
		default:
			break;
	}

    
    
}

- (void)updateOutlook
{
	switch (self.infoLabelStatus) {
		case InfoStatusFirstTimeSetting:
			self.infoLabel.text = @"绘制解锁图案";
			break;
		case InfoStatusConfirmSetting:
			self.infoLabel.text = @"再次绘制解锁图案";
			break;
		case InfoStatusFailedConfirm:
			self.infoLabel.text = @"与上一次绘制不一致，请重新绘制";
           
			break;
		case InfoStatusNormal:
			self.infoLabel.text = @"Draw previously set pattern to go in";
			break;
		case InfoStatusFailedMatch:
			self.infoLabel.text = [NSString stringWithFormat:@"密码错误，还可以再输入%d次",5-self.wrongGuessCount];
            
            if (self.wrongGuessCount >= 5) {
                self.infoLabel.text = @"密码错误，还可以再输入0次";
                [UIAlertView showErrorWithMessage:@"忘记手势密码需要重新登录" handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                    [MGo2PageUtility go2MLoginViewController:self completionHandler:^{
                        self.infoLabelStatus = InfoStatusFirstTimeSetting;
                        [self updateOutlook];
                        
                    }];
                }];
            
            }
			break;
		case InfoStatusSuccessMatch:
			self.infoLabel.text = @"Welcome !";
			break;
			
		default:
			break;
	}
	
}

-(IBAction)onGesturePasswordAction:(id)sender{
    [MActionUtility showAlert:@"提示" message:@"忘记手势密码需要重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [MGo2PageUtility go2MLoginViewController:self completionHandler:^{
            self.infoLabelStatus = InfoStatusFirstTimeSetting;
            [self updateOutlook];

        }];
    }
}
-(IBAction)onResetGesturePasswordAction:(id)sender{
    user_defaults_set_string(kCurrentPatternTemp, @"");
    
    self.infoLabelStatus = InfoStatusFirstTimeSetting;
    [self updateOutlook];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
