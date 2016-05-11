//
//  Shader.fsh
//  ARDemo
//
//  Created by Liu Yang on 4/21/16.
//  Copyright © 2016 Liu Yang. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
