//
//  MRiskAssessmentViewController.h
//  MrMoney
//
//  Created by xingyong on 14-2-19.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MButtonRadio.h"
#import "MRiskAction.h"
@interface MRiskAssessmentViewController : MBaseViewController<MButtonRadioDelegate,MRiskActionDelegate>{
    MRiskAction *riskAction;
}
@property(weak,nonatomic)IBOutlet UIView *topView;

@property(weak,nonatomic)IBOutlet UIView *value1View;
@property(weak,nonatomic)IBOutlet UIView *value2View;
@property(weak,nonatomic)IBOutlet UIView *value3View;
@property(weak,nonatomic)IBOutlet UIView *value4View;
@property(weak,nonatomic)IBOutlet UIView *value5View;

@property(weak,nonatomic)IBOutlet UIScrollView  *scrollView;

@property (strong,nonatomic)   MFinanceProductData  * data;
@property (nonatomic,assign)   MBankType              bankType;

-(IBAction)onSubmitRiskAction:(id)sender;
@end
