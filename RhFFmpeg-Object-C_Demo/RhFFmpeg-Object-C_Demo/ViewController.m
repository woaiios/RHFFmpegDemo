//
//  ViewController.m
//  RhFFmpeg-Object-C_Demo
//
//  Created by sun on 15/7/22.
//  Copyright (c) 2015年 sun. All rights reserved.
//

#import "ViewController.h"
#import "avformat.h"
#import "swscale.h"
#import "SaveImage.h"
#import "SDL.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    av_register_all();
   unsigned int v = avformat_version();
    NSLog(@"%d",v);//3679332
    av_register_all();
    
    AVFormatContext *ctx = NULL;
    const char *filePath = [[[NSBundle mainBundle] pathForResource:@"videoplayback_4" ofType:@"mp4"] cStringUsingEncoding:NSUTF8StringEncoding];
    int stau = avformat_open_input(&ctx, filePath, NULL, NULL);

    if (stau == 0) {
        av_dump_format(ctx, 0, filePath, 0);
        
        //找出第一个视频流
        AVCodecContext *cctx = NULL;
        int vStm = -1;
        for (int i = 0; i<ctx->nb_streams; i++) {
            if (ctx->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
                vStm = i;
                break;
            }
        }
        
        if (-1 != vStm) {
            cctx = ctx->streams[vStm]->codec;
            
            //寻找解码器解码
            AVCodec *dec;
            dec = avcodec_find_decoder(cctx->codec_id);
            if (NULL != dec) {
                if (0 == avcodec_open2(cctx, dec, NULL)) {
                    
                    AVFrame *fm;
                    fm = av_frame_alloc();
                    
                    uint8_t *buffer;
                    int nbBytes;
                    nbBytes = avpicture_get_size(PIX_FMT_RGB24, cctx->width, cctx->height);
                    buffer = av_malloc(nbBytes*sizeof(uint8_t));
                    
                    avpicture_fill((AVPicture*)fm, buffer, PIX_FMT_RGB24, cctx->width, cctx->height);
                    
                    int frameFinished;
                    AVPacket packet;
                    int i = 0;
                    while (0 == av_read_frame(ctx, &packet)) {//读帧，帧是由多个包组成的。
                        if (packet.stream_index == vStm) {
                            avcodec_decode_video2(cctx, fm, &frameFinished, &packet);
                            if (frameFinished) {//如果不等于0，证明有帧。
                                struct SwsContext *swsCtx;
                                swsCtx = sws_getContext(cctx->width, cctx->height, cctx->pix_fmt, cctx->width, cctx->height, PIX_FMT_RGB24, SWS_BICUBIC, NULL, NULL, NULL);
                                if (swsCtx) {
                                    sws_scale(swsCtx, fm->data, fm->linesize, 0, cctx->height, fm->data, fm->linesize);
                                    if (++i>=600 && i <= 606) {
                                        
                                        SDL_Init(SDL_INIT_AUDIO|SDL_INIT_VIDEO|SDL_INIT_TIMER);
                                        //SaveFrame(fm, cctx->width, cctx->height, i);
                                    }
                                    
                                    
                                } else {NSLog(@"ERROR 没能获得图片上下文");}
                            }
                        }
                        
                    }
                    
                    av_free(buffer);
                    av_frame_free(&fm);
                } else {
                    NSLog(@"没能打开解码器 ERROR");
                }
                
                
            }
            
        }
        
        avformat_close_input(&ctx);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
