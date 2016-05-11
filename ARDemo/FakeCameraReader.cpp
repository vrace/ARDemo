#include "FakeCameraReader.h"
#include "ResourcePath.h"
#include <fstream>

namespace
{
    const int CAMERA_WIDTH = 320;
    const int CAMERA_HEIGHT = 240;
    const int CAMERA_BPP = 1;
    const int CAMERA_BUFFER_BYTES = CAMERA_WIDTH * CAMERA_HEIGHT * CAMERA_BPP;
}

FakeCameraReader::FakeCameraReader()
{
    _buffer.resize(CAMERA_BUFFER_BYTES, 0);
    
    std::ifstream fs(ResourcePath("image_320_240_8_marker_id_bch_nr0100", "raw").c_str(), std::ios::in | std::ios::binary);
    
    if (fs)
    {
        fs.read((char*)&_buffer[0], CAMERA_BUFFER_BYTES);
    }
}

FakeCameraReader::~FakeCameraReader()
{
    
}

int FakeCameraReader::Width() const
{
    return CAMERA_WIDTH;
}

int FakeCameraReader::Height() const
{
    return CAMERA_HEIGHT;
}

unsigned char* FakeCameraReader::Buffer()
{
    return &_buffer[0];
}
