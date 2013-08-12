//
//  NewShippingAddressController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-13.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "NewShippingAddressController.h"
#import "FMDatabase.h"
#import "GPWSAPI.h"
#import "AppDelegate.h"
#import "KeychainItemWrapper.h"
#import "UserInfoValidator.h"

@interface CityModle : NSObject
@property(nonatomic, copy)   NSString  *cityName;
@property(nonatomic, assign) NSInteger cityID;
@property(nonatomic, assign) NSInteger fkey;   // 外键

+ (CityModle *)cityWithName:(NSString *)name cityID:(NSInteger)cid fkey:(NSInteger)fkey;
@end

@implementation CityModle
+ (CityModle *)cityWithName:(NSString *)name cityID:(NSInteger)cid fkey:(NSInteger)fkey;
{
    CityModle *cm = [[CityModle alloc] init];
    cm.cityName = name;
    cm.cityID   = cid;
    cm.fkey     = fkey;
    return cm;
}
@end


#define PickerViewHeight (180)
#define PickerViewInitPosition (LH_SCREEN_HEIGHT-LH_STATUS_BAR_HEIGHT-LH_NAVIGATION_BAR_HEIGHT)
#define PickerViewNormalPosition (PickerViewInitPosition - PickerViewHeight)

@interface NewShippingAddressController ()

@property (weak, nonatomic) IBOutlet UITextField *theConsigneTextField;
@property (weak, nonatomic) IBOutlet UITextField *telphoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextView  *detailAddressTextView;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *zoneTextField;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIButton *textFiledRightViewButton;
@property (weak, nonatomic) IBOutlet UIButton *defaultShippingAddressButton;

@property (assign, nonatomic) BOOL           isDefaultAddress;
@property (strong, nonatomic) FMDatabase     *dbRef;
@property (strong, nonatomic) UIPickerView   *pickerView;
@property (strong, nonatomic) NSMutableArray *provinceArray, *cityArray, *citySubArray, *zoneArray, *zoneSubArray;

@property (copy, nonatomic) NSString *provinceName, *cityName, *zoneName;

@end

@implementation NewShippingAddressController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"新增收货地址";
    self.isDefaultAddress = NO;

    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, PickerViewInitPosition, LH_SCREEN_WIDTH, PickerViewHeight)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:self.pickerView];
    
    self.zoneTextField.rightViewMode = UITextFieldViewModeAlways;
    self.zoneTextField.rightView = self.textFiledRightViewButton;
    
    // 将全国的城市数据加载到内存
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cityDB" ofType:nil];
    self.dbRef = [FMDatabase databaseWithPath:path];
    if(![self.dbRef open])
    {
        self.dbRef = nil;
        NSLog(@"Open DB Failed!");
        return;
    }
    
    self.provinceArray = [NSMutableArray new];
    self.cityArray     = [NSMutableArray new];
    self.citySubArray  = [NSMutableArray new];
    self.zoneArray     = [NSMutableArray new];
    self.zoneSubArray  = [NSMutableArray new];
    
    FMResultSet *s = [self.dbRef executeQuery:@"SELECT * FROM T_Province"];
    while ([s next])
    {
        NSInteger rowid = [s intForColumn:@"ProSort"];
        NSString  *cityName = [s stringForColumn:@"ProName"];
        
        CityModle *cm = [CityModle  cityWithName:cityName cityID:rowid fkey:0];
        [self.provinceArray addObject:cm];
    }
    
    s = [self.dbRef executeQuery:@"SELECT * FROM T_City"];
    while ([s next])
    {
        NSInteger rowid = [s intForColumn:@"CitySort"];
        NSInteger fkey  = [s intForColumn:@"ProID"];
        NSString  *cityName = [s stringForColumn:@"CityName"];
        
        CityModle *cm = [CityModle  cityWithName:cityName cityID:rowid fkey:fkey];
        [self.cityArray addObject:cm];
    }

    s = [self.dbRef executeQuery:@"SELECT * FROM T_Zone"];
    while ([s next])
    {
        NSInteger rowid = [s intForColumn:@"ZoneID"];
        NSInteger fkey  = [s intForColumn:@"CityID"];
        NSString  *cityName = [s stringForColumn:@"ZoneName"];
        
        CityModle *cm = [CityModle  cityWithName:cityName cityID:rowid fkey:fkey];
        [self.zoneArray addObject:cm];
    }
    
    [self.pickerView reloadComponent:0];
}

#pragma mark - Action

- (IBAction)setDefaultAddress:(UIButton *)sender
{
    if(self.isDefaultAddress)
        [sender setTitle:@"默认" forState:UIControlStateNormal];
    else
        [sender setTitle:@"NO" forState:UIControlStateNormal];
    
    self.isDefaultAddress = !self.isDefaultAddress;
}

- (IBAction)chooseProvince:(id)sender
{
    [self show:YES];
}

- (IBAction)saveNewAddress:(id)sender
{
    NSString *consigneName, *telphoneNumber, *zipCode, *zone, *detailAddress, *fullAddress;
    
    consigneName = self.theConsigneTextField.text;
    telphoneNumber = self.telphoneNumberTextField.text;
    zipCode = self.zipcodeTextField.text;
    zone = self.zoneTextField.text;
    detailAddress = self.detailAddressTextView.text;
    fullAddress = [NSString stringWithFormat:@"%@%@", zone, detailAddress];
    
    if(!consigneName.length)    {Alert(@"输入收货人姓名"); return;}
    if([UserInfoValidator isValidMobileNumber:telphoneNumber] == NO)
    {
        Alert(@"请输入有效的电话号码");
        return;
    }
    if(!zone.length)            {Alert(@"请选择省份(市,区)"); return;}
    if(!detailAddress.length)   {Alert(@"输入收货地址"); return;}
    if([UserInfoValidator isValidZipCode:zipCode] == NO)
    {
        Alert(@"请输入有效的邮政编码");
        return;
    }
   
    NSString *userName, *userPassowrd;
    userName = UserName;
    userPassowrd = Password;
    
    [GPWSAPI addShippingAddressWithConsigneName:consigneName
                                       telphone:telphoneNumber
                                        address:fullAddress
                                        zipcode:zipCode
                               isDefaultAddress:[NSNumber numberWithInteger:(self.isDefaultAddress ? 1 : 0)]
                                       userName:userName
                                   userPassword:userPassowrd success:^(BOOL yesOrNo)
                                   {
                                       if(yesOrNo)
                                       {
                                           Alert(@"添加收货地址成功");
                                       }
                                       else
                                       {
                                           Alert(@"添加收货地址失败");
                                       }
                                   } faile:^(ErrorType errorType)
                                    {
                                        Alert(@"添加收货地址失败");
                                        NSLog(@"添加收货地址失败:%d", errorType);
                                   }];
}


- (IBAction)setDefalutShippingAddress:(UIButton *)sender
{
    NSString *imageName = nil;
    imageName = _isDefaultAddress ? @"default_shipping_address_button_selected@2x" : @"default_shipping_address_button@2x.png";
    UIImage *image = [UIImage imageNamed:imageName];
    [self.defaultShippingAddressButton setImage:image forState:UIControlStateNormal];
    
    _isDefaultAddress = !_isDefaultAddress;
}

#pragma mark - UITextFiledDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    // 520是选择省份的UITextFiled的Tag值
    return textField.tag == 520 ? NO : YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // 在IPhone5上键盘遮挡不住填写邮政编码的文本输入框，所以不用移动视图
    if(textField.tag == 1314 && LH_SCREEN_HEIGHT == 480)
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = self.containerView.frame;
            f.origin.y = - 90;
            self.containerView.frame = f;
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag == 1314 && LH_SCREEN_HEIGHT == 480)
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = self.containerView.frame;
            f.origin.y = 0;
            self.containerView.frame = f;
        }];
    }
}

#pragma mark - PickerView Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return component == 0 ? self.provinceArray.count : (component == 1 ? self.citySubArray.count : self.zoneSubArray.count);
}

#pragma mark - PickerView Delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return component == 0 ? 120 : 100;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CityModle *cm = nil;
    switch(component)
    {
        case 0:
            cm = self.provinceArray[row];
            return cm.cityName;
        case 1:
            cm = self.citySubArray[row];
            return cm.cityName;
        case 2:
            cm = self.zoneSubArray[row];
            return cm.cityName;
            
        default:return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch(component)
    {
        case 0:
        {
            [self.citySubArray removeAllObjects];
            [self.zoneSubArray removeAllObjects];
            [self.pickerView reloadComponent:1];
            [self.pickerView reloadComponent:2];
            
            CityModle *cm = self.provinceArray[row];
            for(CityModle *cmObj in self.cityArray)
                if(cmObj.fkey == cm.cityID)
                    [self.citySubArray addObject:cmObj];
            
            cm = self.citySubArray[0];
            for(CityModle *cmObj in self.zoneArray)
                if(cmObj.fkey == cm.cityID)
                    [self.zoneSubArray addObject:cmObj];
            
            [self.pickerView reloadComponent:1];
            [self.pickerView reloadComponent:2];
            
            CityModle *cm1, *cm2, *cm3;
            cm1 = self.provinceArray[row], self.provinceName = cm1.cityName;
            cm2 = self.citySubArray[0], self.cityName = cm2.cityName;
            
            if(self.zoneSubArray.count >= 1) // 有些地区可能没有县级(区),譬如:台湾,澳门，香港
            {
                cm3 = self.zoneSubArray[0];
                self.zoneName = cm3.cityName;
            }
            
            break;
        }
            
        case 1:
        {
            [self.zoneSubArray removeAllObjects];
            [self.pickerView reloadComponent:2];
            
            CityModle *cm = self.citySubArray[row];
            for(CityModle *cmObj in self.zoneArray)
                if(cmObj.fkey == cm.cityID)
                    [self.zoneSubArray addObject:cmObj];
            
            [self.pickerView reloadComponent:2];
            
            CityModle *cm2, *cm3;
            cm2 = self.citySubArray[row], self.cityName = cm2.cityName;
            if(self.zoneSubArray.count >= 1)
            {
                cm3 = self.zoneSubArray[0];
                self.zoneName = cm3.cityName;
            }
            
            break;
        }
            
        case 2:
        {
            CityModle *cm3;
            cm3 = self.zoneSubArray[row];
            self.zoneName = cm3.cityName;
            
            break;
        }
            
        default:break;
    }
    
    self.zoneTextField.text = [NSString stringWithFormat:@"%@%@%@", self.provinceName,self.cityName,self.zoneName];
}

- (void)viewDidUnload
{
    [self setTheConsigneTextField:nil];
    [self setTelphoneNumberTextField:nil];
    [self setDetailAddressTextView:nil];
    [self setZipcodeTextField:nil];
    [self setZoneTextField:nil];
    [self setTextFiledRightViewButton:nil];
    [self setContainerView:nil];
    [self setDefaultShippingAddressButton:nil];
    [super viewDidUnload];
}

- (void)show:(BOOL)isShow
{
    CGFloat y = (isShow==NO ? PickerViewInitPosition : PickerViewNormalPosition);
    
    [UIView animateWithDuration:0.3 animations:^
    {
        CGRect f = self.pickerView.frame;
        f.origin.y = y;
        self.pickerView.frame = f;
    } completion:^(BOOL finished) {
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self show:NO];
}

- (void)dealloc
{
    if(self.dbRef) [self.dbRef close];
}

@end


