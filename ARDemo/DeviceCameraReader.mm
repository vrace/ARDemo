#include "DeviceCameraReader.h"
#include "ImageProcessing.h"
#include <cassert>
#include <algorithm>
#include <iostream>
#include <Foundation/Foundation.h>

extern int ScreenWidth;
extern int ScreenHeight;

namespace
{
    struct PixelData
    {
        unsigned char b, g, r, a;
    };
}

DeviceCameraReader::DeviceCameraReader()
{
    
}

DeviceCameraReader::~DeviceCameraReader()
{
    
}

int DeviceCameraReader::Width() const
{
    return ScreenWidth;
}

int DeviceCameraReader::Height() const
{
    return ScreenHeight;
}

unsigned char* DeviceCameraReader::Buffer()
{
    return &_cameraBuffer[0];
}

#define PRINT_ELAPSED(action) \
elapsed = [NSDate new];\
std::cout << action": " << [elapsed timeIntervalSinceDate:snapshot] << std::endl;\
snapshot = elapsed

void DeviceCameraReader::FeedCameraData(unsigned char *buffer, int width, int height, int bpp)
{
    NSDate *snapshot = [[NSDate alloc] init];
    NSDate *elapsed;
    
    _cameraBuffer.resize(Width() * Height());
    _rotateBuffer.resize(width * height);
    _grayBuffer.resize(width * height);
    
    GrayScaleImage((PixelBGRA32*)buffer, width, height, &_grayBuffer[0]);
    RotateImage(&_grayBuffer[0], width, height, &_rotateBuffer[0]);
    ScaleImage(&_rotateBuffer[0], height, width, (float)Width() / height, &_cameraBuffer[0]);
    
    PRINT_ELAPSED("Transform pixel data");
}
