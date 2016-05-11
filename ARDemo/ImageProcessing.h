#ifndef __IMAGE_PROCESSING_H__
#define __IMAGE_PROCESSING_H__

struct PixelBGRA32
{
    unsigned char b, g, r, a;
};

typedef unsigned char PixelGrayScale;

template <class T>
void GrayScaleImage(const T *src, int width, int height, PixelGrayScale *dest)
{
    for (int y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
            int index = y * width + x;
            dest[index] = ToGrayScale(src[index]);
        }
    }
}

template <class T>
void RotateImage(const T *src, int width, int height, T *dest)
{
    for (int row = 0; row < height; row++)
    {
        for (int column = 0; column < width; column++)
        {
            int srcIndex = row * width + column;
            int destIndex = column * height + (height - 1 - row);
            dest[destIndex] = src[srcIndex];
        }
    }
}

template <class T>
void ScaleImage(const T *src, int width, int height, float ratio, T *dest)
{
    int destWidth = static_cast<int>(width * ratio);
    int destHeight = static_cast<int>(height * ratio);
    
    for (int y = 0; y < destHeight; y++)
    {
        for(int x = 0; x < destWidth; x++)
        {
            int destIndex = y * destWidth + x;
            int srcIndex = static_cast<int>(y / ratio) * width + static_cast<int>(x / ratio);
            
            dest[destIndex] = src[srcIndex];
        }
    }
}

PixelGrayScale ToGrayScale(const PixelBGRA32 &pixel);

#endif
