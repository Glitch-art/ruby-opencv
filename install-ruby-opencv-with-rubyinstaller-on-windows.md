# Install ruby-opencv with RubyInstaller on Windows

This document shows how to install ruby-opencv with RubyInstaller on Windows.

Official OpenCV binary for MinGW32 is no longer distributed, so when you use ruby-opencv with RubyInstaller, you should build OpenCV yourself using Devkit.

## Requirement

- Windows 10 64bit
- [Ruby 2.3.0p0 x64-mingw32 on RubyInstaller](http://rubyinstaller.org/)
- [Devkit (DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe)](https://rubyinstaller.org/downloads/archives/)
- [OpenCV 2.4.13](https://sourceforge.net/projects/opencvlibrary/files/opencv-win/2.4.13/opencv-2.4.13.exe/download)
- [cmake-3.29.0-windows-x86_64.msi](https://cmake.org/)

TODO Advice: Test with a compiler(mingw32) more recent.

## How to install OpenCV and ruby-opencv

### Download and extract OpenCV

Download OpenCV library from https://sourceforge.net/projects/opencvlibrary/ and extract it.

### Set environment variables

#### Option 1: Set temporary environment variables

Open ```cmd.exe``` and run the following commands.

```bash
set DEVKIT_PATH=C:/development_tools/DevKit-mingw64-64-4.7.2-20130224-1432-sfx
set SOURCE_PATH=D:/opencv/opencv-2.4.13/sources
set OPENCV_INSTALL_PATH=D:/opencv/output/opencv-2.4.13
set OPENCV_BUILD_PATH=D:/opencv/build/opencv-2.4.13
```

#### Option 2: Set permanent environment variables

Open ```cmd.exe``` and run the following commands.

```bash
setx DEVKIT_PATH C:/development_tools/DevKit-mingw64-64-4.7.2-20130224-1432-sfx
setx SOURCE_PATH D:/opencv/opencv-2.4.13/sources
setx OPENCV_INSTALL_PATH D:/opencv/output/opencv-2.4.13
setx OPENCV_BUILD_PATH D:/opencv/build/opencv-2.4.13
```

Then, restart ```cmd.exe```.

### Create OpenCV Makefile with CMake

Open ```cmd.exe``` and run the following commands.

```bash
cmake -S %SOURCE_PATH% -B %OPENCV_BUILD_PATH% -G "MinGW Makefiles" -DCMAKE_INSTALL_PREFIX=%OPENCV_INSTALL_PATH% -DCMAKE_MAKE_PROGRAM=%DEVKIT_PATH%/mingw/bin/mingw32-make.exe -DCMAKE_C_COMPILER=%DEVKIT_PATH%/mingw/bin/gcc.exe -DCMAKE_CXX_COMPILER=%DEVKIT_PATH%/mingw/bin/g++.exe -DBUILD_PERF_TESTS=OFF -DBUILD_opencv_java=OFF
```

In this document, I assume that the Devkit is installed to ```C:/development_tools/DevKit-mingw64-64-4.7.2-20130224-1432-sfx```, the OpenCV library is extracted to ```D:/work/opencv-2.4.13``` and its source directory is ```D:/opencv/opencv-2.4.13/sources```, and the output will be installed in ```D:/opencv/output/opencv-2.4.13```.


### Build OpenCV with DevKit

Open ```cmd.exe``` prompt.
Go to folder ```D:/opencv/build/opencv-2.4.13```
Execute the following commands.

```bash
%DEVKIT_PATH%/mingw/bin/mingw32-make.exe
%DEVKIT_PATH%/mingw/bin/mingw32-make.exe install
```


### Install ruby-opencv

Run the following commands in ```cmd.exe```.

```bash
path %OPENCV_INSTALL_PATH%\x64\mingw\bin;%DEVKIT_PATH%\mingw\bin;%PATH%
gem install ruby-opencv -- --with-opencv-include=%OPENCV_INSTALL_PATH%/include --with-opencv-lib=%OPENCV_INSTALL_PATH%/x64/mingw/lib
```

And try to use ruby-opencv.

```bash
irb
```

```ruby
irb(main):001:0> require 'opencv'
=> true
irb(main):002:0> OpenCV::CV_VERSION
=> "2.4.13"
```

Note that the paths ```%OPENCV_INSTALL_PATH%\x64\mingw\bin``` and ```%DEVKIT_PATH%\mingw\bin``` must **ALWAYS** be set when using ```ruby-opencv```, or you may get the following error.

```
D:\>irb
irb(main):001:0> require 'opencv'
LoadError: 126: The specified module could not be found.   - D:/local/ruby/lib/ruby/gems/2.3.0/gems/ruby-opencv-0.0.17/lib/opencv.so
        from D:/local/ruby/lib/ruby/site_ruby/2.3.0/rubygems/core_ext/kernel_require.rb:133:in `require'
        from D:/local/ruby/lib/ruby/site_ruby/2.3.0/rubygems/core_ext/kernel_require.rb:133:in `rescue in require'
        from D:/local/ruby/lib/ruby/site_ruby/2.3.0/rubygems/core_ext/kernel_require.rb:40:in `require'
        from D:/local/ruby/lib/ruby/gems/2.3.0/gems/ruby-opencv-0.0.17/lib/opencv.rb:8:in `rescue in <top (required)>'
        from D:/local/ruby/lib/ruby/gems/2.3.0/gems/ruby-opencv-0.0.17/lib/opencv.rb:5:in `<top (required)>'
        from D:/local/ruby/lib/ruby/site_ruby/2.3.0/rubygems/core_ext/kernel_require.rb:133:in `require'
        from D:/local/ruby/lib/ruby/site_ruby/2.3.0/rubygems/core_ext/kernel_require.rb:133:in `rescue in require'
        from D:/local/ruby/lib/ruby/site_ruby/2.3.0/rubygems/core_ext/kernel_require.rb:40:in `require'
        from (irb):1
        from D:/local/ruby/bin/irb.cmd:19:in `<main>'
```
