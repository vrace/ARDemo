#ifndef __AR_SCENE_H__
#define __AR_SCENE_H__

#include "ARToolKitPlus/TrackerSingleMarker.h"
#include "CameraReader.h"

class ARScene
{
public:
    ARScene(CameraReader &camera);
    ~ARScene();
    
    void Update(float delta);
    void Render();
    
    void StartTracking(CameraReader &camera);
    void StopTracking();
    
private:
    void DrawObject();
    
private:
    ARToolKitPlus::TrackerSingleMarker *_tracker;
    CameraReader *_camera;
};

#endif
