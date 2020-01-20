#import "AssetsAudioPlayPlugin.h"
#import <AVFoundation/AVFoundation.h>

@interface AssetsAudioPlayPlugin()

@property (nonatomic) AVAudioPlayer *audioPlayer;

@end

static id<FlutterPluginRegistrar> mRegistrar;

@implementation AssetsAudioPlayPlugin


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"assets_audio_play"
            binaryMessenger:[registrar messenger]];
  AssetsAudioPlayPlugin* instance = [[AssetsAudioPlayPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    mRegistrar = registrar;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if([@"play" isEqualToString:call.method]) {
      [self playAudio: call result:result];
  } else if([@"pause" isEqualToString:call.method]){
      [self pauseAudio:call result:result];
  } else if([@"release" isEqualToString:call.method]){
      [self releaseAudio:call result:result];
  } else {
      result(FlutterMethodNotImplemented);
  }
}


- (void)playAudio:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *path = call.arguments[@"path"];
    NSString *key = [mRegistrar lookupKeyForAsset:path];
    NSString *temp = [[NSBundle mainBundle] pathForResource:key ofType:nil];
    NSURL *audio = [NSURL fileURLWithPath:temp];
    NSError *error = nil;
    self.audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:audio error:&error];
    self.audioPlayer.volume = 1.0;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

- (void)pauseAudio:(FlutterMethodCall*)call result:(FlutterResult)result {
    if(self.audioPlayer != nil){
        [self.audioPlayer pause];
    }
}

- (void)releaseAudio: (FlutterMethodCall*)call result:(FlutterResult)result {
    if(self.audioPlayer != nil){
    }
}
@end
