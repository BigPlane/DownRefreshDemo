//
//  ViewController.m
//  DownRefresh
//
//  Created by Colin on 15-8-31.
//  Copyright (c) 2015年 CH. All rights reserved.
//

#import "ViewController.h"

#define kRandomNumber arc4random_uniform(1024)
#define kOrignalData [NSString stringWithFormat:@"原数据---%d", kRandomNumber]
#define kNewData [NSString stringWithFormat:@"新数据---%d", kRandomNumber]

@interface ViewController () <UITableViewDataSource>

// 模拟数据
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation ViewController

#pragma mark - 懒加载
- (NSMutableArray *)data
{
    if (!_data)
    {;
        self.data = [NSMutableArray array];
        for (int i = 0; i<3; i++)
        {
            [self.data addObject:kOrignalData];
        }
    }
    
    return _data;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource = self;
    
    [self setupDownRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupDownRefresh
{
    /* 添加刷新控件 */
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    
    // 监听事件
    [control addTarget:self action:@selector(loadNewDatas:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:control];
    
/* 是否进入界面先刷新一次 */
//    // 进入刷新状态
//    [control beginRefreshing];
//    
//    // 加载数据
//    [self loadNewDatas:control];
}

/**
 *  加载更多数据
 */
- (void)loadNewDatas:(UIRefreshControl *)control
{
    // 插入数据前面
    for (int i = 0; i < 2; i++)
    {
        [self.data insertObject:kNewData atIndex:0];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新TableView
        [self.tableView reloadData];
        
        // 结束刷新状态
        [control endRefreshing];
    });
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = self.data[indexPath.row];
    
    return cell;
}

@end
