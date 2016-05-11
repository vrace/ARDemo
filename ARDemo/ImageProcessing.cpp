#include "ImageProcessing.h"

PixelGrayScale ToGrayScale(const PixelBGRA32 &pixel)
{
    return static_cast<PixelGrayScale>((static_cast<int>(pixel.r) + static_cast<int>(pixel.g) + static_cast<int>(pixel.b)) / 3.0);
}
