//
//  ViewController.m
//  SLTableViewPlaceHolder
//
//  Created by 孙磊 on 2017/5/15.
//  Copyright © 2017年 孙磊. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+SLTableViewPlaceHolder.h"

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView ;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataArray = [@[@"1",@"2"] mutableCopy];
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 50, 30)];
    addBtn.backgroundColor = [UIColor redColor];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [self.view addSubview:addBtn];
    
    [addBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *reduceBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 30, 50, 30)];
    reduceBtn.backgroundColor = [UIColor purpleColor];
    [reduceBtn setTitle:@"-" forState:UIControlStateNormal];
    [self.view addSubview:reduceBtn];
    
    [reduceBtn addTarget:self action:@selector(reduc) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *showBtn = [[UIButton alloc]initWithFrame:CGRectMake(180, 30, 50, 30)];
    showBtn.backgroundColor = [UIColor brownColor];
    [showBtn setTitle:@"show" forState:UIControlStateNormal];
    [self.view addSubview:showBtn];
    
    [showBtn addTarget:self action:@selector(showPlaceHolder) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *hideBtn = [[UIButton alloc]initWithFrame:CGRectMake(260, 30, 50, 30)];
    hideBtn.backgroundColor = [UIColor greenColor];
    [hideBtn setTitle:@"hide" forState:UIControlStateNormal];
    [self.view addSubview:hideBtn];
    
    [hideBtn addTarget:self action:@selector(hidePlaceHolderuc) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.tableView];
    
//    self.tableView.contentSize
    
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}


-(void)add{
    [self.dataArray addObject:@"123"];
    [self.tableView reloadData];
}



-(void)reduc{
    [self.dataArray removeLastObject];
    [self.tableView reloadData];
}


-(void)showPlaceHolder{
    self.tableView.sl_isShowPlaceHolder = YES;
}

-(void)hidePlaceHolderuc{

    self.tableView.sl_isShowPlaceHolder = NO;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

    NSLog(@"~~~~~~%@",change);
}


#pragma mark - tableView相关
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}


-(UITableView *)tableView{

    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, Screen_W, Screen_H - 100) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor purpleColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.sl_isShowPlaceHolder = NO;
        
        _tableView.rowHeight = 100;
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
