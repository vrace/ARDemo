#ifndef __CAMERA_READER_H__
#define __CAMERA_READER_H__

class CameraReader
{
public:
    CameraReader();
    virtual ~CameraReader();
    
    virtual int Width() const = 0;
    virtual int Height() const = 0;
    
    virtual unsigned char* Buffer() = 0;
};

#endif
