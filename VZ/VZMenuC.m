//
//  VZMenuC.m
//  VZ
//
//  Created by Travis on 13-10-20.
//  Copyright (c) 2013年 Plumn LLC. All rights reserved.
//

#import "VZMenuC.h"
#import <QuartzCore/QuartzCore.h>
#import <UIImageView+AFNetworking.h>
#import "VZNavView.h"
#import <UIViewController+MMDrawerController.h>

#import <AVOSCloudSNS/AVUser+SNS.h>

CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}
CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}


@interface VZMenuC ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (nonatomic) UITapGestureRecognizer *loginTap;
@end

@implementation VZMenuC

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)onLogin:(id)user{
    [self.avatar setImageWithURL:[NSURL URLWithString:[user objectForKey:@"avatar"]]
                placeholderImage:[UIImage imageNamed:@"head"]];
}

-(void)onLogout{
    self.avatar.image=[UIImage imageNamed:@"head"];
}

-(void)login{
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:@"2858658895" andAppSecret:@"9d97c1cce2893cbdcdc970f05bc55fe4" andRedirectURI:@"http://"];
    //[AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:@"31024382" andAppSecret:@"25c3e6b5763653d1e5b280884b45c51f" andRedirectURI:@"http://"];
    
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        if (error) {
            NSLog(@"login error %@",[error description]);
        }else if(object){
            [self onLogin:object];
        }
    } toPlatform:AVOSCloudSNSSinaWeibo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableHeaderView.frame=CGRectMake(0, 0, 10, 0);
    
    //self.loginTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login)];
    //[self.avatar addGestureRecognizer:self.loginTap];
    
    [self onLogin:(id)[AVOSCloudSNS userInfo:AVOSCloudSNSSinaWeibo]];
    
}

//-(void)viewWillAppear:(BOOL)animated{
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationRight];
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UINavigationController *nav=(id)self.mm_drawerController.centerViewController;
    
    if (indexPath.section==1) {
        [nav setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"SettingC"]] animated:YES];
    }else if(indexPath.section==0){
        switch (indexPath.row) {
            case 0:
                [self login];
                return;
                break;
            
            case 1:
            {
                UIViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"PostListC"];
                [nav setViewControllers:@[vc] animated:YES];
            }
                break;
                
            case 2:
            {
                UIViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"NearC"];
                [nav setViewControllers:@[vc] animated:YES];
            }
                
            default:
                break;
        }
    }
    [self setMenuBtn];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

-(void)setMenuBtn{
    UINavigationController *nav=(id)self.mm_drawerController.centerViewController;
    UIViewController *vc= nav.viewControllers[0];
    
    UIBarButtonItem *btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Dots"] style:UIBarButtonItemStylePlain target:self action:@selector(menu:)];
    vc.navigationItem.leftBarButtonItem=btn;
    
}
-(void)menu:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
