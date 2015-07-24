//
//  SaveImage.c
//  RhFFmpeg-Object-C_Demo
//
//  Created by 孙润辉 on 15/7/22.
//  Copyright (c) 2015年 sun. All rights reserved.
//

#include "SaveImage.h"
void SaveFrame(AVFrame *pFrame, int width, int height, int iFrame) {
    FILE *pFile;
    char szFilename[64];
    int  y;
    // Open file
    sprintf(szFilename, "/Users/Runhui/Desktop/frame%d.ppm", iFrame);
    pFile=fopen(szFilename, "wb");
    if(pFile==NULL)
        return;
    // Write header
    fprintf(pFile, "P6\n%d %d\n255\n", width, height);
    // Write pixel data
    for(y=0; y<height; y++)
        fwrite(pFrame->data[0]+y*pFrame->linesize[0], 1, width*3, pFile);
    // Close file
    fclose(pFile);
}

void SD_Init(int width, int height ,SDL_Renderer *render_ ,SDL_Texture *texture_,SDL_Rect *rect_) {
    SDL_SetMainReady();
    if ( SDL_Init(SDL_INIT_AUDIO|SDL_INIT_VIDEO|SDL_INIT_TIMER)) {
        printf("ERROR SDL 初始化失败 %s",SDL_GetError());
        return;
    }
    
    SDL_Window* screen = SDL_CreateWindow("Maximized text",
                                          SDL_WINDOWPOS_UNDEFINED,
                                          SDL_WINDOWPOS_UNDEFINED,
                                          width,
                                          height,
                                          SDL_WINDOW_RESIZABLE);
    
//    SDL_Surface* screen = SDL_GetWindowSurface(window);
    
    if (!screen) {
        fprintf(stderr, "不能获取screen");
        return;
    }
    SDL_Renderer *render = SDL_CreateRenderer(screen, -1,0/*SDL_RENDERER_SOFTWARE|SDL_RENDERER_ACCELERATED|SDL_RENDERER_PRESENTVSYNC|SDL_RENDERER_TARGETTEXTURE*/);
    if (!render) {
        fprintf(stderr, SDL_GetError());
        return;
    }
    
    SDL_Rect rect = {0,0,width,height};
    
    render_ = render;

    
    rect_->x = rect.x;
    rect_->y = rect.y;
    rect_->w = rect.w;
    rect_->h = rect.h;
}

void SD_ShowFrame(AVFrame *pFrame, SDL_Renderer *render, SDL_Rect *rect , SDL_Texture *tex) {
    
    SDL_UpdateTexture(tex, rect, pFrame->data[0], pFrame->linesize[0]);
    SDL_RenderClear(render);
    SDL_RenderCopy(render, tex, rect, rect);
    SDL_RenderPresent(render);
//    SDL_Delay(40);
    
}

void SD_Dealloc(){
//    SDL_Quit();
}