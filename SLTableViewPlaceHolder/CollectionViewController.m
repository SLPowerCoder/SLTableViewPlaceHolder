//
//  CollectionViewController.m
//  SLTableViewPlaceHolder
//
//  Created by 孙磊 on 2017/12/5.
//  Copyright © 2017年 孙磊. All rights reserved.
//

#import "CollectionViewController.h"


#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height

@interface CollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView ;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation CollectionViewController

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
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}


-(void)add{
    self.dataArray = [@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18"] mutableCopy];
    [self.collectionView reloadData];
}



-(void)reduc{
    self.dataArray = [@[] mutableCopy];
    [self.collectionView reloadData];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSLog(@"~~~~~~%@",change);
}


#pragma mark - tableView相关

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor purpleColor];
    return cell;
}

-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(Screen_W / 5, Screen_W / 5);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100 + 64, Screen_W, Screen_H - 100) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor brownColor];

        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
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
