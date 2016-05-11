#ifndef __DEVICE_CAMERA_READER_H__
#define __DEVICE_CAMERA_READER_H__

#include "CameraReader.h"
#include "ImageProcessing.h"
#include <vector>

class DeviceCameraReader : public CameraReader
{
public:
    DeviceCameraReader();
    virtual ~DeviceCameraReader();
    
    virtual int Width() const;
    virtual int Height() const;
    
    virtual unsigned char *Buffer();
    
    void FeedCameraData(unsigned char *buffer, int width, int height, int bpp);
    
private:
    std::vector<PixelGrayScale> _cameraBuffer;
    std::vector<PixelGrayScale> _grayBuffer;
    std::vector<PixelGrayScale> _rotateBuffer;
};

#endif
