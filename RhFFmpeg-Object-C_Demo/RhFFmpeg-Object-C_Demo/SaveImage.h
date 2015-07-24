//
//  SaveImage.h
//  RhFFmpeg-Object-C_Demo
//
//  Created by 孙润辉 on 15/7/22.
//  Copyright (c) 2015年 sun. All rights reserved.
//

#ifndef __RhFFmpeg_Object_C_Demo__SaveImage__
#define __RhFFmpeg_Object_C_Demo__SaveImage__

#include <stdio.h>

#endif /* defined(__RhFFmpeg_Object_C_Demo__SaveImage__) */

#include "avformat.h"
#include "SDL.h"
#import "SDL_main.h"

void SaveFrame(AVFrame *pFrame, int width, int height, int iFrame);

void SD_Init(int width, int height ,SDL_Renderer *render_ ,SDL_Texture *texture_,SDL_Rect *rect_);
void SD_ShowFrame(AVFrame *pFrame,SDL_Renderer *render, SDL_Rect *rect , SDL_Texture *tex);
void SD_Dealloc();