//
//  ViewController.m
//  testTableViewNewApi
//
//  Created by 张斌斌 on 17/4/12.
//  Copyright © 2017年 张斌. All rights reserved.
//

#import "ViewController.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define COUNT 10
@interface ViewController ()<
UITableViewDataSource,
UITableViewDelegate
>
@property(strong,nonatomic)UITableView*myTableview;
@property(strong,nonatomic)UIImageView *cellImage;
@property(strong,nonatomic)NSIndexPath *currentPath;
@property(strong,nonatomic)UITableViewCell *currentCell;
@property(assign,nonatomic)CGFloat orignY;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view = self.myTableview;
    
    }

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify=@"testIdentify";
 
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
       
        UILongPressGestureRecognizer *pan=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(panReg:)];
        [cell addGestureRecognizer:pan];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"taskicon0%lu",indexPath.row]];
    cell.textLabel.text=[NSString stringWithFormat:@"taskIcon%lu",indexPath.row];
  
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return COUNT;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
}
/*
 - (CGPoint)translationInView:(nullable UIView *)view;                        // translation in the coordinate system of the specified view
 - (void)setTranslation:(CGPoint)translation inView:(nullable UIView *)view;
 
 - (CGPoint)velocityInView:(nullable UIView *)view;
 */



//MARK:-PAN GESTURE
- (void)panReg:(UILongPressGestureRecognizer*)recognise{

    CGPoint currentPoint = [recognise locationInView:self.view];
   
    
    if (recognise.state==UIGestureRecognizerStateBegan) {
        _orignY=currentPoint.y;
        _currentPath = [_myTableview indexPathForRowAtPoint:currentPoint];
        _currentCell=[_myTableview cellForRowAtIndexPath:_currentPath];
        _currentCell.hidden=YES;
        _cellImage=[UIImageView new];
        _cellImage.image=[self getImageWithCell:_currentCell];
        _cellImage.frame=CGRectMake(0,currentPoint.y-30, WIDTH, 60);
        _cellImage.backgroundColor =[UIColor clearColor];
        [self.view addSubview:_cellImage];
        
    }else if(recognise.state==UIGestureRecognizerStateChanged){
        _cellImage.frame=CGRectMake(0, currentPoint.y-30, WIDTH, 60);
        //判断方向
        if (currentPoint.y>_orignY) {
            if (currentPoint.y-_orignY>30) {
                NSIndexPath *newIndexPath=[NSIndexPath indexPathForRow:_currentPath.row+1 inSection:0];
                if(newIndexPath.row<COUNT){
                    [self.myTableview moveRowAtIndexPath:_currentPath toIndexPath:newIndexPath];
                    _currentPath=newIndexPath;
                    _orignY+=60;
                }
               
            }
            
        }else{
            if (_orignY-currentPoint.y>30) {
                NSIndexPath *newIndexPath=[NSIndexPath indexPathForRow:_currentPath.row-1 inSection:0];
                [self.myTableview moveRowAtIndexPath:_currentPath toIndexPath:newIndexPath];
                _currentPath=newIndexPath;
                _orignY-=60;
            }
        
        }
    
    }else if(recognise.state==UIGestureRecognizerStateEnded){

            [_cellImage removeFromSuperview];
            _cellImage=nil;
            _currentCell.hidden=NO;
        

    }

}
//MARK:截图
- (UIImage *)getImageWithCell:(UITableViewCell*)cell {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(WIDTH, 60), NO, 1.0);
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, CGRectMake(0, 3, WIDTH, 60), [UIImage imageNamed:@"shadow"].CGImage);
    
    [cell.contentView.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}
//MARK:-GETTER
- (UITableView *)myTableview
{
    if (!_myTableview) {
        _myTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-64)];
        _myTableview.delegate = self;
        _myTableview.dataSource = self;
        _myTableview.contentSize=CGSizeMake(0, [UIScreen mainScreen].bounds.size.height-64);
        _myTableview.scrollEnabled = YES;
        
    }
    return _myTableview;
    
}




- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{

    return UITableViewCellAccessoryDisclosureIndicator;
}


@end
