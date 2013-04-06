Echo off 
rem set the asdoc.exe full path.
set asdoc="D:\Program Files\Adobe\Flex Builder 3\sdks\3.1.0\bin\asdoc.exe"
rem ,C:\Program Files\Adobe\Adobe Flash CS3\en\Configuration\ActionScript 3.0\Classes\
rem begin define params ,com.wlash.scroll.ScrollDisplayObject

set docSources=".\classes"
set mainTitle="API Documentation"
set windowTitle="Whohoo AS3 API Documentation"
set output=API_Documentation
set footer="www.wlash.com | whohoo@21cn.com | Author: Wally.Ho | version: 1.0"

set sourcePath=".\classes" "D:\Wally.Ho\works\Labs\3D\pv3d\as3\trunk\src" "D:\Program Files\Adobe\Adobe Flash CS3\en\Configuration\ActionScript 3.0\Classes" "D:\Wally.Ho\works\Labs\Tween\greensock-tweening-platform-as3"

set excludeClasses=""

set package=-package com.wlash.as3d "one class for 3D." -package com.wlash.data "about submit and check data." -package com.wlash.exception "some throw error class." -package com.wlash.loader "about loader and loading" -package com.wlash.loader.transition "for ContenteLoader class." -package com.wlash.utils "some utils class." -package com.wlash.scroll "Scroll Comonents for TextField, DisplayObject." 

set docClasses="com.wlash.scroll.SimpleScrollBar" "com.wlash.scroll.ScrollTextField" "com.wlash.scroll.ScrollDisplayObject"
set docClasses=%docClasses% "com.wlash.as3d.CubeBox" "com.wlash.as3d.PlaneDisplayObject" "com.wlash.as3d.Vector3D"
set docClasses=%docClasses% "com.wlash.data.AMFResponderEvent" "com.wlash.data.AMFsender" "com.wlash.data.CallWebServicesMethod" "com.wlash.data.Form" "com.wlash.data.WebService" "com.wlash.data.WebServicesEvent"

set docClasses=.
rem end define params
Echo on
rem %asdoc% -source-path %sourcePath% -doc-classes %docClasses% -main-title %mainTitle% -window-title %windowTitle% -output %output% -footer %footer% %package% -exclude-classes %excludeClasses%

 
 %asdoc% -source-path %sourcePath% -doc-sources %docSources% -main-title %mainTitle% -window-title %windowTitle% -output %output% -footer %footer% %package% -exclude-classes %excludeClasses%
