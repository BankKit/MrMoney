//
//  MAddAccountViewController.m
//  MrMoney
//
//  Created by xingyong on 14-1-16.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MAddAccountViewController.h"
#import "SMPageControl.h"
#import "MRelateAccountViewController.h"
#import "MSecurityView.h"
#import "UIViewController+CWPopup.h"
#import "UIViewController+style.h"
#define KCOUNT 10
@interface MAddAccountViewController ()
@property(nonatomic,strong) NSMutableDictionary *bankDict;
@property(nonatomic,assign) BOOL isCheck;
@end

@implementation MAddAccountViewController

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
    
    [self createNavBarTitle:@"添加资产"];
     
    
    self.isCheck = YES;
    
    _bankDict = [NSMutableDictionary  dictionaryWithDictionary:KBANK_DICT];
    
    [_bankDict removeObjectForKey:@"jsb"];
    [_bankDict removeObjectForKey:@"hzb"];
    [_bankDict removeObjectForKey:@"nbcb"];
    [_bankDict removeObjectForKey:@"njcb"];
    [_bankDict removeObjectForKey:@"xib"];
    [_bankDict removeObjectForKey:@"cbhb"];
    [_bankDict removeObjectForKey:@"czb"];
    [_bankDict removeObjectForKey:@"bos"];
    [_bankDict removeObjectForKey:@"bsb"];
    [_bankDict removeObjectForKey:@"dfcf"];
    [_bankDict removeObjectForKey:@"otherbanks"];
    [_bankDict removeObjectForKey:@"bosera"];
    [_bankDict removeObjectForKey:@"jsfund"];
    [_bankDict removeObjectForKey:@"lionfund"];
    [_bankDict removeObjectForKey:@"nfund"];
    [_bankDict removeObjectForKey:@"efmc"];
    [_bankDict removeObjectForKey:@"camc"];
    [_bankDict removeObjectForKey:@"gzcb"];
    

    MSecurityView * securityView =  [self securityView:_middleView];

    [self.scrollView  addSubview:securityView];
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, securityView.frameY + securityView.frameHeight + 5);
    
    self.scrollView.contentSize = CGSizeMake(320, securityView.frameY + securityView.frameHeight + 5);
    
    
    [self initContentScrollView];
    
}
-(void)initContentScrollView{
    _contentScrollView.delegate = self;
    
    CGRect rect = CGRectMake(100,_contentScrollView.frameY + _contentScrollView.frameHeight - 20,100,30);

    _pageControl                           = [[SMPageControl alloc] initWithFrame:rect];
    _pageControl.indicatorDiameter         = 4.;
    _pageControl.pageIndicatorImage        = [UIImage imageNamed:@"home_page_gray.png"];
    _pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"home_page_orange.png"];
    _pageControl.userInteractionEnabled    = NO;
    _pageControl.alignment                 = SMPageControlAlignmentCenter;
    _pageControl.hidesForSinglePage        = YES;
    _pageControl.tag                       = 666;
 
     
    int count = [[_bankDict allKeys] count];
    _contentScrollView.contentSize=CGSizeMake(280*(count/10+1), 200);
    
    _pageControl.numberOfPages = count/10+1;
    _pageControl.currentPage = 0;

    [self.middleView  addSubview:_pageControl];
    
    for (int i = 0 ; i < count ; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"btn_check_unsel"];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"btn_check_sel"] forState:UIControlStateSelected];
        button.tag = i + 1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *key = [[_bankDict allKeys] objectAtIndex:i];
        
        UILabel *label=[[UILabel alloc] init];
        label.backgroundColor=[UIColor clearColor];
        label.textColor=[UIColor darkGrayColor];
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:14];
        label.text             = [_bankDict objectForKey:key];
        label.frameWidth       = 90;
        label.frameHeight      = 21;
        
        NSString *imageName    = STRING_FORMAT(@"logo_%@",[key lowercaseString]);
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:PNGIMAGE(imageName)];
        imageView.frameWidth = PNGIMAGE(imageName).width/2;
        imageView.frameHeight = PNGIMAGE(imageName).height/2;
        
        
        
        button.frameHeight     = image.height/2;
        button.frameWidth      = image.width/2;
        
        int  row               = i%10;
        int  list              = i/10;
        
        button.frameX          = list * 280 + (i%2)*(button.frameWidth + 110)+20;
        button.frameY          = floor(row/2)*(button.frameHeight +10) + 15;
        imageView.frameX       = button.frameX + button.frameWidth + 2;
        imageView.frameY       = button.frameY + image.width/8;
        label.frameX           = imageView.frameX + imageView.frameWidth + 2;
        label.frameY           = button.frameY + 2;
        
        
        [_contentScrollView addSubview:imageView];
        [_contentScrollView addSubview:label];
        [_contentScrollView addSubview:button];

        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
 
    CGFloat pageWidth = _contentScrollView.frame.size.width;
    int page = floor((_contentScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
 
	
 }
//跳转到下一界面

-(void)agreementViewButtonClick:(BOOL)check{
    self.isCheck = check;
}

-(IBAction)onNextStepAction:(id)sender{
    if (!self.isCheck) {
        [MActionUtility showAlert:@"请阅读并同意 使用条款和隐私政策"];
        return;
    }
    if (_currentButton) {
         
        MRelateAccountViewController *relate = [[MRelateAccountViewController alloc] initWithNibName:@"MRelateAccountViewController" bundle:nil];
        relate.bank_identifie = [[_bankDict allKeys] objectAtIndex:self.buttonIndex];
        relate.ptype = self.ptype;
        [self.navigationController pushViewController:relate animated:YES];
       
    }else{
        [MActionUtility showAlert:@"请选择一个银行"];
    }
 
}
 
-(void)buttonClick:(id)sender{

    UIButton *button = (UIButton *)sender;

    self.buttonIndex = button.tag - 1;
    
    _currentButton.selected = NO;
    button.selected = YES;
    _currentButton = button;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
