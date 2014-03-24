//
//  MPayViewController.h
//  MrMoney
//
//  Created by xingyong on 14-1-9.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MPayAction.h"
#import "MFinanceProductData.h"

@protocol MPayViewControllerDelegate <NSObject>

-(void)payResultNotify;

@end

@class MOrderData;
@interface MPayViewController : MBaseViewController {
 
    
}
@property(nonatomic,strong)MOrderData *order;

@property(nonatomic,copy)NSString *product_name;
@property(nonatomic,assign)float amount;
@property(nonatomic,strong)NSString  *ip;

@property (weak, nonatomic) IBOutlet UIWebView *webView;



@property(nonatomic,weak)id<MPayViewControllerDelegate> delegate;
@end
