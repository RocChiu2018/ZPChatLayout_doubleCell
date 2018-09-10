//
//  ZPViewController.m
//  聊天布局
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZPViewController.h"
#import "ZPMessage.h"
#import "ZPTableViewCell.h"

@interface ZPViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *messagesArray;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;

@end

@implementation ZPViewController

#pragma mark ————— 懒加载 —————
-(NSArray *)messagesArray
{
    if (_messagesArray == nil)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        ZPMessage *lastMessage = nil;
        for (NSDictionary *dict in dictArray)
        {
            ZPMessage *message = [ZPMessage messageWithDict:dict];
            message.isHideTime = [message.time isEqualToString:lastMessage.time];
            [tempArray addObject:message];
            
            lastMessage = message;
        }
        
        _messagesArray = tempArray;
    }
    
    return _messagesArray;
}

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.messageTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.messageTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //监听键盘变化的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark ————— 键盘弹出和退下 —————
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    //取出键盘最终的frame
    CGRect rect = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //取出键盘弹出或退下所花费的时间
    double duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        CGFloat ty = [UIScreen mainScreen].bounds.size.height - rect.origin.y;
        self.view.transform = CGAffineTransformMakeTranslation(0, - ty);  //view向上移动，y是负值
    }];
}

#pragma mark ————— UITableViewDataSource —————
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messagesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出模型
    ZPMessage *message = [self.messagesArray objectAtIndex:indexPath.row];
    
    //选择重用标识
    NSString *ID = nil;
    if (message.type == messageTypeMe)
    {
        ID = @"me";
    }else
    {
        ID = @"other";
    }
    
    ZPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.message = message;
    
    return cell;
}

#pragma mark ————— UITableViewDelegate —————
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZPMessage *message = [self.messagesArray objectAtIndex:indexPath.row];
    
    return message.cellHeight;
}

#pragma mark ————— UIScrollViewDelegate —————
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark ————— 移除通知 —————
-(void)dealloc
{
    //移除本类的所有通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
