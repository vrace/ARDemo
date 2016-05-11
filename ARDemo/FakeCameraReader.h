#ifndef __FAKE_CAMERA_READER_H__
#define __FAKE_CAMERA_READER_H__

#include "CameraReader.h"
#include <vector>

class FakeCameraReader : public CameraReader
{
public:
    FakeCameraReader();
    virtual ~FakeCameraReader();
    
    virtual int Width() const;
    virtual int Height() const;
    
    virtual unsigned char* Buffer();
    
private:
    std::vector<unsigned char> _buffer;
};

#endif
