//
//  TableViewController.m
//  SLTableViewPlaceHolder
//
//  Created by 孙磊 on 2017/12/5.
//  Copyright © 2017年 孙磊. All rights reserved.
//

#import "TableViewController.h"

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height

@interface TableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView ;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18"] mutableCopy];
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 30 + 64, 40, 30)];
    addBtn.backgroundColor = [UIColor redColor];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [self.view addSubview:addBtn];
    
    [addBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *reduceBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 30  + 64, 40, 30)];
    reduceBtn.backgroundColor = [UIColor purpleColor];
    [reduceBtn setTitle:@"-" forState:UIControlStateNormal];
    [self.view addSubview:reduceBtn];
    
    [reduceBtn addTarget:self action:@selector(reduc) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}


-(void)add{
    self.dataArray = [@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18"] mutableCopy];
    [self.tableView reloadData];
}



-(void)reduc{
    self.dataArray = [@[] mutableCopy];
    [self.tableView reloadData];
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
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100 + 64, Screen_W, Screen_H - 100) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor brownColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.rowHeight = 50;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
