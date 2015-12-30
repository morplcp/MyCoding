//
//  LeftSettingViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/4.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "LeftSettingViewController.h"
#import "PlayerManager.h"
#import "DataManager.h"
#import "Music.h"
@interface LeftSettingViewController ()<PlayerManagerDelegate>

// 记录当前播放的音乐索引
@property(nonatomic, assign) NSInteger currentIndex;
// 记录当前播放的音乐
@property(nonatomic, retain) Music *currentMusic;
@property(nonatomic, retain) NSTimer *timer;
@property(nonatomic, strong)UIImageView *imgView;
@property(nonatomic, strong)UIImageView *singerImg;
@property(nonatomic, strong)UILabel *lblMusicName;

@end

@implementation LeftSettingViewController

static LeftSettingViewController *leftVC = nil;

+ (instancetype)sharedPlayingPVC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        leftVC = [sb instantiateViewControllerWithIdentifier:@"leftVC"];
        leftVC.currentIndex = -1;
        leftVC.mode = 1;
        [DataManager shareaManager].callBack = ^(){
            leftVC.musicArray = [DataManager shareaManager].allMusic;
        };
    });
    return leftVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RgbColor(255, 255, 255);
    [PlayerManager sharedManager].delegate = self;
}

- (void)startPlay{
    self.mode = 2;
    NSString * str = [NSString stringWithFormat:@"%@%@%@",kMusicPlay_URL,self.currentMusic.contentid,kPlay];
    [[PlayerManager sharedManager] playWithUrlString:str];
    [self buildUI];
}

- (void)buildUI{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.currentMusic.singerIcon]];
    [self.singerImg sd_setImageWithURL:[NSURL URLWithString:self.currentMusic.albumImg]];
    NSString *musicName = [NSString stringWithFormat:@"%@ - %@",self.currentMusic.title , self.currentMusic.singer];
    self.lblMusicName.text = musicName;
    [_btnPlayOrPause setBackgroundImage:[UIImage imageNamed:@"zanting"] forState:(UIControlStateNormal)];
}

- (void)setPlayIndex:(NSInteger)playIndex{
    _playIndex = playIndex;
    if (_playIndex == self.currentIndex) {
        return;
    }
    _currentIndex = _playIndex;
    [self startPlay];
}

- (void)setTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kWindowHeight - 90)];
    self.singerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, topView.frame.size.width, topView.frame.size.height)];
    _singerImg.contentMode = UIViewContentModeScaleAspectFill;
    _singerImg.image = [UIImage imageNamed:@"bac.jpg"];
    [topView addSubview:self.singerImg];
    topView.backgroundColor = RgbColor(255, 255, 255);
    [self.view addSubview:topView];
}

// 设置底部音乐播放控件
- (void)setPlayerView{
    UIView *playerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight - 90, self.view.frame.size.width, 90)];
    self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bac.jpg"]];
    _imgView.frame = CGRectMake(5, 5, 80, 80);
    self.lblMusicName = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.frame.size.width + 10, 5, playerView.frame.size.width - 95, 30)];
    _lblMusicName.backgroundColor = [UIColor clearColor];
    _lblMusicName.textColor = [UIColor whiteColor];
    _lblMusicName.font = [UIFont systemFontOfSize:15];
    playerView.backgroundColor = [UIColor blackColor];
    self.btnLast = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _btnLast.frame = CGRectMake(_lblMusicName.frame.origin.x, 50, 30, 30);
    _btnLast.backgroundColor = [UIColor clearColor];
    [_btnLast setBackgroundImage:[UIImage imageNamed:@"shang"] forState:(UIControlStateNormal)];
    self.btnPlayOrPause = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _btnPlayOrPause.frame = CGRectMake((_lblMusicName.frame.size.width - 90) / 2.0 + 30 + _btnLast.frame.origin.x, 50, 30, 30);
    if ([PlayerManager sharedManager].isPlaying) {
        [_btnPlayOrPause setBackgroundImage:[UIImage imageNamed:@"zanting"] forState:(UIControlStateNormal)];
    }else{
        [_btnPlayOrPause setBackgroundImage:[UIImage imageNamed:@"bofang"] forState:(UIControlStateNormal)];
    }
    _btnPlayOrPause.backgroundColor = [UIColor clearColor];
    self.btnNext = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _btnNext.frame = CGRectMake((_lblMusicName.frame.size.width - 90) / 2.0 + 30 + _btnPlayOrPause.frame.origin.x, 50, 30, 30);
    _btnNext.backgroundColor = [UIColor clearColor];
    [_btnNext setBackgroundImage:[UIImage imageNamed:@"xia"] forState:(UIControlStateNormal)];
    [playerView addSubview:_imgView];
    [playerView addSubview:_lblMusicName];
    [playerView addSubview:_btnNext];
    [playerView addSubview:_btnPlayOrPause];
    [playerView addSubview:_btnLast];
    [self.view addSubview:playerView];
    [self setAction];
}

// 添加按钮事件
- (void)setAction{
    [_btnLast addTarget:self action:@selector(actionLast) forControlEvents:(UIControlEventTouchUpInside)];
    [_btnNext addTarget:self action:@selector(actionNext) forControlEvents:(UIControlEventTouchUpInside)];
    [_btnPlayOrPause addTarget:self action:@selector(actionPlayOrPause:) forControlEvents:(UIControlEventTouchUpInside)];
}
// 上一曲
- (void)actionLast{
    _currentIndex--;
    if (_currentIndex < 0) {
        _currentIndex = 0;
        return;
    }
    [self startPlay];
}
// 下一曲
- (void)actionNext{
    _currentIndex++;
    if (_currentIndex == self.musicArray.count) {
        _currentIndex = 0;
    }
    [self startPlay];
}

// 暂停/播放
- (void)actionPlayOrPause:(UIButton *)sender{
    if (self.mode == 1) {
        _currentIndex = 0;
        [self startPlay];
    }
    if ([PlayerManager sharedManager].isPlaying) {
        [[PlayerManager sharedManager] pause];
        [_btnPlayOrPause setBackgroundImage:[UIImage imageNamed:@"bofang"] forState:(UIControlStateNormal)];
    }else{
        [[PlayerManager sharedManager] play];
        [_btnPlayOrPause setBackgroundImage:[UIImage imageNamed:@"zanting"] forState:(UIControlStateNormal)];
    }
}

#pragma mark -PlayerManagerDelegate
// 一首播放完毕后自动跳下一曲
- (void)playerDidPlayEnd{
    [self actionNext];
}

#pragma mark -getter

- (Music *)currentMusic{
    Music *music = self.musicArray[self.currentIndex];
    return music;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setTopView];
        [self setPlayerView];
    });
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
