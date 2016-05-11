#include "ARScene.h"
#include "ResourcePath.h"
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include <iostream>

namespace
{
    struct PixelFormat
    {
        float x, y, z;
        float r, g, b, a;
    };
    
    PixelFormat vertices[] =
    {
        // top left
        -0.5, 0.5, 0,       1, 0, 0, 1,
        // bottom left
        -0.5, -0.5, 0,      0, 1, 0, 1,
        // bottom right
        0.5, -0.5, 0,       0, 0, 1, 1,
        
        // top left
        -0.5, 0.5, 0,       1, 0, 0, 1,
        // bottom right
        0.5, -0.5, 0,       0, 0, 1, 1,
        // top right
        0.5, 0.5, 0,        0, 1, 0, 1,
    };
}

ARScene::ARScene(CameraReader &camera)
: _camera(NULL)
, _tracker(NULL)
{
}

ARScene::~ARScene()
{
    StopTracking();
}

void ARScene::Update(float delta)
{
    if (_tracker)
    {
        _tracker->calc(_camera->Buffer());
        _tracker->selectBestMarkerByCf();
        
        //float confidence = _tracker->getConfidence();
        //std::cout << "confidence: " << confidence << std::endl;
    }
}

void ARScene::Render()
{
    if (_tracker)
    {
        float confidence = _tracker->getConfidence();
        
        if (confidence >= 0.7f)
        {
            glMatrixMode(GL_PROJECTION);
            glPushMatrix();
            glLoadMatrixf(_tracker->getProjectionMatrix());
            
            glMatrixMode(GL_MODELVIEW);
            glPushMatrix();
            glLoadMatrixf(_tracker->getModelViewMatrix());
            
            DrawObject();
            
            glMatrixMode(GL_MODELVIEW);
            glPopMatrix();
            
            glMatrixMode(GL_PROJECTION);
            glPopMatrix();
        }
    }
}

void ARScene::DrawObject()
{
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    
    int verticsCount = sizeof(vertices) / sizeof(PixelFormat);
    
    glVertexPointer(3, GL_FLOAT, sizeof(PixelFormat), vertices);
    glColorPointer(4, GL_FLOAT, sizeof(PixelFormat), &vertices[0].r);
    
    glDrawArrays(GL_TRIANGLES, 0, verticsCount);
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);

}

void ARScene::StartTracking(CameraReader &camera)
{
    StopTracking();
    
    _camera = &camera;
    
    _tracker = new ARToolKitPlus::TrackerSingleMarker(_camera->Width(), _camera->Height());
    
    _tracker->setPixelFormat(ARToolKitPlus::PIXEL_FORMAT_LUM);
    _tracker->init(ResourcePath("PGR_M12x0.5_2.5mm", "cal").c_str(), 0.1f, 1000.0f);
    _tracker->setPatternWidth(1.0f);
    _tracker->setBorderWidth(0.125f);
    _tracker->setThreshold(150);
    _tracker->setUndistortionMode(ARToolKitPlus::UNDIST_LUT);
    _tracker->setMarkerMode(ARToolKitPlus::MARKER_ID_BCH);
}

void ARScene::StopTracking()
{
    delete _tracker;
    _camera = NULL;
}
