Echo off 
rem set the asdoc.exe full path.
set asdoc="D:\Program Files\Adobe\Flex Builder 3\sdks\3.1.0\bin\asdoc.exe"
rem ,C:\Program Files\Adobe\Adobe Flash CS3\en\Configuration\ActionScript 3.0\Classes\
rem begin define params ,com.wlash.scroll.ScrollDisplayObject

set sourcePath=.\classes\
set docClasses="com.wlash.scroll.ScrollTextField,com.wlash.scroll.ScrollDisplayObject"
set docSources=.
set excludeClasses="fl.transitions.TweenEvent,fl.transitions.Tween,fl.transitions.easing.Strong"
set mainTitle="API Documentation"
set windowTitle="Whohoo AS3 API Documentation"
set output=API_Documentation
set footer="www.wlash.com | whohoo@21cn.com | Author: Wally.Ho | version: 0.6"
set package=com.wlash.as3d "one class for 3D." -package com.wlash.data "about submit and check data." -package com.wlash.exception "some throw error class." -package com.wlash.loader "about loader and loading" -package com.wlash.loader.transition "for ContenteLoader class." -package com.wlash.utils "some utils class." -package com.wlash.scroll "Scroll Comonents for TextField, DisplayObject." 
rem end define params
Echo on

rem %asdoc% -sp+=%sourcePath% -dc+=%docClasses% -exclude-classes+=%excludeClasses% -main-title=%mainTitle% -window-title=%windowTitle% -o=%output% -footer=%footer% -package+=%package%

 %asdoc% -source-path %sourcePath% -doc-sources %docSources% -main-title %mainTitle% -window-title %windowTitle% -output %output% -footer %footer% -package %package%