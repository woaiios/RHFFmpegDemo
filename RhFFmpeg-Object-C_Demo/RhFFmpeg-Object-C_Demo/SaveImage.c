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