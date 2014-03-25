//
//  MAccountInfoViewController.m
//  MrMoney
//
//  Created by xingyong on 13-12-9.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MAccountInfoViewController.h"
#import "MAccountCell.h"
#import "MUserData.h"
#import "MLoginViewController.h"

@interface MAccountInfoViewController ()
@property(nonatomic,strong)NSString *passwordNew;
@property(nonatomic,strong)NSString *passwordOld;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *realName;
@end

@implementation MAccountInfoViewController

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
    [self createNavBarTitle:@"账户信息"];
 

    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.tableFooterView = _footView;
    
    self.dataArray = [NSMutableArray arrayWithObjects:@"头像",@"姓名",@"设置密码",@"编号",@"手机",@"邮箱",  nil];
  
    _user = [[MUserData allDbObjects] objectAtIndex:0];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MAccountCell *cell = (MAccountCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MAccountCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = KVIEW_BACKGROUND_COLOR;
        
        if (IsIOS7) {
            UIImage *background = [MActionUtility cellBackgroundForRowAtIndexPath:indexPath tableView:tableView];
            
            cell.backgroundView = [[UIImageView alloc] initWithImage:background];
            
            UIImage *imageSelectedBack = [MActionUtility cellSelectedBackgroundViewForRowAtIndexPath:indexPath tableView:tableView];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:imageSelectedBack];
            
        }
   
        
    }
    
    
    int section = indexPath.section;
    int row = indexPath.row;
    
         
    if (section == 0) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row ];
        
        if (indexPath.row == 0) {
            
 
            if (![strOrEmpty(_user.miconPath) isEqualToString:@""]) {
 
                [cell.thumb setImageWithURL:KAVATAR_PATH(userMid(),_user.miconPath)];
 
            }
            else{
                cell.thumb.image = [UIImage imageNamed:@"default_qbaobao"];
            }
            
        }
        if ( row == 1) {
            cell.contentLabel.text = _user.mrealName;
        }
        
    }
    if (section == 1) {
        cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row + 2];
        
        if ( row == 0) {
            cell.contentLabel.text = _user.mmid;
        }
        if ( row == 1) {
            cell.contentLabel.text = [MUtility securePhoneNumber:_user.mmobile];
        }
        if ( row == 2) {
            cell.contentLabel.text = _user.memail;
        }
        
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)  return 20.0;
    return 5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row ==0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选择图片",nil];
        [sheet showInView:self.view];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改名称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:KCONFIRM_STR, nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *oldTf=[alert textFieldAtIndex:0];
        oldTf.placeholder = @"修改昵称";
        
        alert.tag = 300;
        [alert show];

    }
    
    if (indexPath.row == 2 && indexPath.section == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:KCONFIRM_STR, nil];
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        UITextField *oldTf=[alert textFieldAtIndex:0];
        oldTf.placeholder = @"旧密码";
        
        UITextField *newTf=[alert textFieldAtIndex:1];
        newTf.placeholder = @"新密码";
        
        alert.tag = 100;
        [alert show];
    }else if(indexPath.row == 2 && indexPath.section == 1 ){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改邮箱" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:KCONFIRM_STR, nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *oldTf=[alert textFieldAtIndex:0];
        oldTf.placeholder = @"输入邮箱";
        
        alert.tag = 200;
        [alert show];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
 
    if (buttonIndex == 0) [self pickImageFromCamera];
    if (buttonIndex == 1) [self pickImageFromAlbum];
}
#pragma mark 从相册获取活动图片
- (void)pickImageFromAlbum
{
    UIImagePickerController  *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
       imagePicker.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary])
    {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
     
    }
    
    
    [self.navigationController presentViewController:imagePicker animated:YES completion:^{
        
    }];
   
    
}
#pragma mark 从摄像头获取活动图片


- (void)pickImageFromCamera
{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
       imagePicker.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
     
    }
    
    [self.navigationController presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *infoImage  = [info objectForKey:UIImagePickerControllerEditedImage];
    
     [MUtility  saveImage:infoImage WithName:@"uploadImage.jpg"];
    
    uploadAction = [[MUploadIconAction alloc] init];
    uploadAction.m_delegate = self;
    [uploadAction requestAction];
    [self showHUD];
}
-(NSDictionary*)onRequestUploadIconAction{
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:0];
    [dict setObject:userMid() forKey:@"mId"];

    [dict setObject:@"jpg" forKey:@"imageType"];
    
    return dict;
}
-(void)onResponseUploadIconSuccess:(NSString *)iconPath{
 
    __weak MAccountInfoViewController *wself = self;
    [self hideHUDWithCompletionMessage:@"头像上传成功" finishedHandler:^{
        [[SDImageCache sharedImageCache] cleanDisk];
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        
        _user.miconPath  = iconPath;
        
        [_user updatetoDb];
        
        _user = [[MUserData allDbObjects] objectAtIndex:0];
        
        [wself.tableView reloadData];
        
    }];
    
    
}
-(void)onResponseUploadIconFail{
    [self hideHUDWithCompletionFailMessage:@"头像上传失败"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70.;
    }
    return 46.;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogoutAction:(id)sender {
    
    UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@"" message:@"确定注销账户？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            self.passwordOld = [[alertView textFieldAtIndex:0] text];
            self.passwordNew = [[alertView textFieldAtIndex:1] text];
            modifyAction = [[MModifyPasswordAction alloc] init];
            modifyAction.m_delegate = self;
            [modifyAction requestAction];
        }
        
    }else if (alertView.tag == 200){
        if (buttonIndex == 1) {
            self.email = [[alertView textFieldAtIndex:0] text];
            
            if ([self.email isEmail]) {
                emailAction = [[MModifyEmailAction alloc] init];
                emailAction.m_delegate = self;
                [emailAction requestAction];
                [self showHUD];
            }else{
                [MActionUtility showAlert:@"邮箱输入不合法"];
                return;
            }
           
        }
        
    }else if (alertView.tag == 300){
        if (buttonIndex == 1) {
                self.realName = [[alertView textFieldAtIndex:0] text];
            
                emailAction = [[MModifyEmailAction alloc] init];
                emailAction.m_delegate = self;
                [emailAction requestAction];
                [self showHUD];
            
        }
        
    }
    else
    {
        if (buttonIndex == 1) {
            [MActionUtility  userLogout];
             [[SDImageCache sharedImageCache] cleanDisk];
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}
/**
 *   修改密码代理
 */
-(NSDictionary*)onRequestModifyPasswordAction{
    
    MutableOrderedDictionary  *dict = [MutableOrderedDictionary dictionary];
    
    [dict setSafeObject:self.user.mmid forKey:@"mId"];
    [dict setSafeObject:self.passwordNew forKey:@"password"];
    [dict setSafeObject:self.user.mrealName forKey:@"realName"];
    [dict setSafeObject:self.passwordOld forKey:@"oldPassword"];
    
    return dict;
}
-(void)onResponseModifyPasswordSuccess{
    [self hideHUD];
    [MActionUtility showAlert:@"密码修改成功"];
}
-(void)onResponseModifyPasswordFail{
    [self hideHUD];
    [MActionUtility showAlert:@"网络异常"];
}

/**
 *   修改邮箱
 */
-(NSDictionary*)onRequestModifyEmailAction{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setSafeObject:self.user.mmid forKey:@"mId"];
    [dict setSafeObject:self.realName? self.realName : _user.mrealName forKey:@"realName"];
    [dict setSafeObject:self.email?self.email : _user.memail forKey:@"email"];
    
    return dict;
}
-(void)onResponseModifyEmailSuccess{
    [self hideHUD];
     
    _user.memail = self.email?self.email : _user.memail;
    _user.mrealName =self.realName? self.realName : _user.mrealName;

    if ([_user updatetoDb]) {
        _user = [[MUserData allDbObjects] objectAtIndex:0];
        [self.tableView reloadData];
        [MActionUtility showAlert:@"修改成功"];
    }

    
}
-(void)onResponseModifyEmailFail{
    [self hideHUD];
    [MActionUtility showAlert:@"修改成功"];
}

@end
