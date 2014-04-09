//
//  HomeViewController.m
//  TaoLiWangGongHui
//
//  Created by apple on 14-2-27.
//  Copyright (c) 2014年 Mac OS X. All rights reserved.
//

#import "HomeViewController.h"
#import "DelicateLifeController.h"
#import "DiscountShoppingController.h"
#import "UnionActivitiesController.h"
#import "WelfareController.h"
#import "HomeListModel.h"
#import "ShufflingImageView.h"

@interface HomeViewController ()<UIWebViewDelegate>{
    NSTimer *activitiesTimer;
}

@property (nonatomic, strong) NSMutableArray *activitiesArray;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
//    if (iPhone5) {
//        self.baseScroll.contentSize = CGSizeMake(self.view.width, 568-49);
//    }
//    else{
        self.baseScroll.top = 0;
//        self.baseScroll.contentSize = CGSizeMake(self.view.width, 568+30);
//    }
    self.baseScroll.backgroundColor  = RGBCOLOR(241, 241, 241);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.baseScroll.userInteractionEnabled = YES;
    self.headScroll.userInteractionEnabled = YES;
    self.navigationItem.title = @"淘礼网工会平台";
    self.navigationItem.leftBarButtonItem = nil;
    
    self.activitiesArray = [NSMutableArray array];
    [self commitRequestWithParams:nil withUrl:[GlobalRequest eCMainAction_QueryECMainInfo_Url]];
    
    [self createUI];
    // 精致生活点击
    [self.delicateLifeLable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delicateLifeClicked:)]];
    self.delicateLifeLable.userInteractionEnabled = YES;
}


- (void)createUI{
    //给轮播添加xx个图片视频
    int imageCount = self.activitiesArray.count;
    for (int i = 0;i < imageCount ;i ++) {
        ShufflingImageView *imageView = [[ShufflingImageView alloc] initWithFrame:CGRectMake(self.view.width*i, 0, self.view.width, 170)];
        [imageView createSubViewsWithModel:self.activitiesArray[i]];
        [self.headScroll addSubview:imageView];
    }
    
    self.headScroll.contentSize = CGSizeMake(self.view.width * imageCount, self.headScroll.height);
    activitiesTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(scrollTheHeadImage) userInfo:nil repeats:YES];
}

#pragma mark - 数据返回成功后刷新数据
- (void)reloadNewData{
    [activitiesTimer invalidate];
    [self.activitiesArray removeAllObjects];
    for (NSDictionary *dict in self.model) {
        HomeListModel *model = [[HomeListModel alloc] initWithDataDic:dict];
        if (model.typeId.intValue == 1) {
            [self.activitiesArray addObject:model];
        }else if (model.typeId.intValue == 3){
            self.jokeTitle.text = model.activityTitle;
//            self.delicateLifeLable.text = model.description;
            model.description = @"周五，正读一年级的女儿突然发烧，女儿哭哭啼啼抱怨自己病得不是时候，我以为她是惦记下午的课，就安慰她：“乖，别哭，不就上不了下午的两节课吗，爸爸帮你补。”谁知她哭声更大了：“你说的什么呀，我是说早不病晚不病，偏偏到周末我病了，这两天我只能躺在家里，不能出去玩了。”打针、吃药，忙活了两天，终于赶在周一上学前女儿的病好了，我长出了一口气。周日晚上，女儿边收拾书包边叹气：“唉，真倒霉，这病好得真不是时候，早不好晚不好，偏偏一上学就好了。”";
            [self.jokeDescription  loadHTMLString:model.description baseURL:nil];
        }
    }
    if ([self.activitiesArray count]>0) {
        [self createUI];
    }
}

- (void)setDataDic:(NSDictionary *)resultDic withRequest:(ITTBaseDataRequest *)request{
    if ([request.requestUrl isEqualToString:[GlobalRequest eCMainAction_QueryECMainInfo_Url]]) {
        [super setDataDic:resultDic withRequest:request];
    }else if ([request.requestUrl isEqualToString:[GlobalRequest productAction_QueryProductListByType_Url]]){
        
        if (!resultDic[@"result"] || [resultDic[@"result"] isKindOfClass:[NSString class]]) {
             [GlobalHelper showWithTitle:@"" withMessage:@"亲，福利的时间还没有到。"  withCancelTitle:@"确定" withOkTitle:nil withSelector:nil withTarget:self];
        }else if ([resultDic[@"result"] isKindOfClass:[NSArray class]] || [resultDic[@"result"] isKindOfClass:[NSDictionary class]]){
            if ([resultDic[@"result"] count]==0) {
                [GlobalHelper showWithTitle:@"" withMessage:@"亲，福利的时间还没有到。"  withCancelTitle:@"确定" withOkTitle:nil withSelector:nil withTarget:self];
            }else{
                WelfareController *welfareController = [[WelfareController alloc] initWithWelfareType:isBirthDay?WelfareBirthDay:WelfareHoliday];
                welfareController.model = resultDic[@"result"];
                [welfareController setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:welfareController animated:YES];
            }
            
        }else{
            WelfareController *welfareController = [[WelfareController alloc] initWithWelfareType:isBirthDay?WelfareBirthDay:WelfareHoliday];
            [welfareController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:welfareController animated:YES];
        }
    }
}

/*** 定时器实现方法
 *   当偏移量小于size的wide 减去 自己的frame的宽度，就直接设置偏移为0
 */
- (void)scrollTheHeadImage{
    [UIView beginAnimations:nil context:nil];
    self.headScroll.contentOffset = CGPointMake(self.headScroll.contentOffset.x + self.view.width, 0);
    [UIView setAnimationDuration:1];
    [UIView commitAnimations];
    if (self.headScroll.contentOffset.x > (self.headScroll.contentSize.width - self.headScroll.width)) {
        self.headScroll.contentOffset = CGPointZero;
    }
}

//精致生活点击进入详情页
- (IBAction)delicateLifeClicked:(id)sender {
    DelicateLifeController *delicateLife = [[DelicateLifeController alloc] initWithStyle:UITableViewStyleGrouped];
    [delicateLife setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:delicateLife animated:YES];
}

// 生日福利和节日福利点击
- (IBAction)welfareClicked:(UIButton *)sender {
    isBirthDay = (200==sender.tag)?YES:NO;
    NSDictionary *param = @{
                            @"id":[[UserHelper shareInstance] getMemberID],
                            (200==sender.tag?@"productType":@"type"):200==sender.tag?@"1":@"2",
                            @"pageNo":@"0",
                            @"pageSize":PAGESIZE
                            };
    [self commitRequestWithParams:param withUrl:[GlobalRequest productAction_QueryProductListByType_Url]];
}

// 优惠购物点击
- (IBAction)discountShoppingClicked:(id)sender {
    DiscountShoppingController *discountShopping = [DiscountShoppingController new];
    [discountShopping setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:discountShopping animated:YES];
}

// 工会活动点击
- (IBAction)unionActitivesClicked:(id)sender {
    UnionActivitiesController *unionActivities = [[UnionActivitiesController alloc] init];
    [unionActivities setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:unionActivities animated:YES];
}

#pragma mark - WebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *jsString = @"document.body.style.fontSize=14";
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    //webView的高度
    NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    CGRect frame = [webView frame];
    frame.size.height = [string floatValue]+10;
    [webView setFrame:frame];
    
    self.baseScroll.contentSize = CGSizeMake(self.baseScroll.width, (480+frame.size.height > 598)?(480+frame.size.height):598);
    self.jokeImageView.height = frame.size.height+25;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
