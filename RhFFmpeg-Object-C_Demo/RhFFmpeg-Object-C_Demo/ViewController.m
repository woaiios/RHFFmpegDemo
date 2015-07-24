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


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
                    
                    AVFrame *fm,*fmYUV;
                    
                    fm = av_frame_alloc();
                    fmYUV = av_frame_alloc();
                    
                    uint8_t *buffer;
                    int nbBytes;
                    nbBytes = avpicture_get_size(PIX_FMT_YUV420P, cctx->width, cctx->height);
                    buffer = av_malloc(nbBytes*sizeof(uint8_t));
                    
                    avpicture_fill((AVPicture*)fm, buffer, PIX_FMT_YUV420P, cctx->width, cctx->height);
                    
                    
                    
                    SDL_SetMainReady();
                    if ( SDL_Init(SDL_INIT_AUDIO|SDL_INIT_VIDEO|SDL_INIT_TIMER)) {
                        printf("ERROR SDL 初始化失败 %s",SDL_GetError());
                        return;
                    }
                    
                    SDL_Window* screen = SDL_CreateWindow("Maximized text",
                                                          SDL_WINDOWPOS_CENTERED,
                                                          SDL_WINDOWPOS_CENTERED,
                                                          cctx->width,
                                                          cctx->height,
                                                          SDL_WINDOW_SHOWN);
                    
                    
                    
                    if (!screen) {
                        fprintf(stderr, "不能获取screen");
                        return;
                    }
                    SDL_Renderer *render = SDL_CreateRenderer(screen, -1,SDL_RENDERER_ACCELERATED|SDL_RENDERER_PRESENTVSYNC);
                    if (!render) {
                        fprintf(stderr, SDL_GetError());
                        return;
                    }
                    
                    SDL_Rect rect = {0,0,cctx->width,cctx->height};
                
                    
                    SDL_Texture *texture =  SDL_CreateTexture(render, SDL_PIXELFORMAT_YV12, SDL_TEXTUREACCESS_STREAMING, cctx->width, cctx->height);
                    if (!texture) {
                        fprintf(stderr, SDL_GetError());
                        return;
                    }
                    
                    
                    int frameFinished;
                    AVPacket packet;
                    int j = 0;
                    
                    while (0 == av_read_frame(ctx, &packet)) {//读帧，帧是由多个包组成的。
                        if (packet.stream_index == vStm) {
                            avcodec_decode_video2(cctx, fm, &frameFinished, &packet);
                            if (frameFinished) {//如果不等于0，证明有帧。
                                struct SwsContext *swsCtx;
                                swsCtx = sws_getContext(cctx->width, cctx->height, cctx->pix_fmt, cctx->width, cctx->height, PIX_FMT_YUV420P, SWS_BICUBIC, NULL, NULL, NULL);
                                if (swsCtx) {
                                    sws_scale(swsCtx, fm->data, fm->linesize, 0, cctx->height, fm->data, fm->linesize);
                                    
                                    
                                    SD_ShowFrame(fm, render, &rect, texture);
                                    
                                    
                                    
                                    
                                    sws_freeContext(swsCtx);//释放swsCtx
                                } else {NSLog(@"ERROR 没能获得图片上下文");}
                                
                            }
                            SDL_Delay(50);
                            av_frame_unref(fm);
                            printf("%d\n",++j);
                        }
                        av_free_packet(&packet);
                        SDL_Event event;
                        SDL_PollEvent(&event);
                        switch (event.type) {
                            case SDL_QUIT:
                            {
                                SDL_Quit();
                            }
                                break;
                                
                            default:
                                break;
                        }
                    }
                    
                    SDL_DestroyTexture(texture);
                    
                    av_free(buffer);
                    av_frame_free(&fm);
                } else {
                    NSLog(@"没能打开解码器 ERROR");
                }
                
                
            }
            
        }
        SD_Dealloc();
        avcodec_close(cctx);
        avformat_close_input(&ctx);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
