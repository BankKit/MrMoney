//
//  MWalletViewController+Style.m
//  MrMoney
//
//  Created by xingyong on 14-3-18.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MWalletViewController+Style.h"
#import "MLineView.h"
#import "MAccountsData.h"
#define KTOPHEIGHT  7
@implementation MWalletViewController (Style)

- (UIView *) viewForTableViewHeaderWithText:(NSDictionary *)dataDict section:(NSInteger )section{
    
    NSArray *keyArray           = [dataDict allKeys];
    NSString *l_key             = [keyArray objectAtIndex:section];
    
    NSArray *accountArray       = [dataDict objectForKey:l_key];
    
    UIView *view                = [[UIView alloc] init];
    view.backgroundColor        = [UIColor whiteColor];
//    self.view.backgroundColor;
    
    MLineView *lineView         = [[MLineView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    lineView.backgroundColor    = self.view.backgroundColor;
    [view addSubview:lineView];
    
    if (section == 0) {
        lineView.hidden = YES;
    }
    
    
    UIImage *logoImage          = bankLogoImage(l_key);
    
    UIImageView *logo_iv        = [[UIImageView alloc] initWithFrame:CGRectMake(10, KTOPHEIGHT + 4, logoImage.width/2, logoImage.height/2)];
    logo_iv.image               = logoImage;
    [view addSubview:logo_iv];
    
         
    UILabel *label              = [[UILabel alloc] initWithFrame:CGRectMake(logoImage.width/2 + 20, KTOPHEIGHT, 100, 20)];
    label.backgroundColor       = view.backgroundColor;
    label.font                  = SYSTEMFONT(15);
    label.text                  = [KBANK_DICT objectForKey:[l_key lowercaseString]];
    [view addSubview:label];
    
    CGSize size = [MStringUtility getStringSize:label.text font:label.font width:100.];
    
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(size.width + label.frameX + 5,KTOPHEIGHT, 200, 20)];
    moneyLabel.backgroundColor  = view.backgroundColor;
    moneyLabel.font             = SYSTEMFONT(12);
    [view addSubview:moneyLabel];
    float value                 = 0.00;
    float dollor                = 0.00;
    
    for (int i                  = 0 ; i<[accountArray count]; i++) {
        MAccountsData *data         = [accountArray objectAtIndex:i];
        value                       += [data.mcurrency floatValue]/100;
        
        dollor                      += [data.mdollar floatValue]/100;
    }
    
    NSString *dollorStr         = dollor>0.00 ? STRING_FORMAT(@"%@%@",@",美元:",formatValue(dollor)) : @"";
    
    moneyLabel.text             = STRING_FORMAT(@"(人民币:%@%@)",formatValue(value),dollorStr);
    
    return view;

}

@end
