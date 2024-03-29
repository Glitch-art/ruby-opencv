![Build Status with Travis CI](https://travis-ci.org/ruby-opencv/ruby-opencv.svg?branch=master)

# ruby-opencv

An OpenCV wrapper for Ruby.

* Web site: <https://github.com/ruby-opencv/ruby-opencv>
* [Documentation](http://www.rubydoc.info/gems/ruby-opencv/frames)

## Requirement

* OpenCV 2.4.13
  * [Download](http://sourceforge.net/projects/opencvlibrary/)
  * [Install guide](http://docs.opencv.org/doc/tutorials/introduction/table_of_content_introduction/table_of_content_introduction.html#table-of-content-introduction)
* Ruby 2.x
  * [RubyInstaller](http://rubyinstaller.org/) (Windows)
  * [RVM](https://rvm.io/) (Linux/Mac)

## Install

### Linux/Mac
1. Install [OpenCV](http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/)
2. Install ruby-opencv

```bash
gem install ruby-opencv -- --with-opencv-dir=/path/to/opencvdir
```

Note: **/path/to/opencvdir** is the directory where you installed OpenCV.

### Windows (RubyInstaller)

See [install-ruby-opencv-with-rubyinstaller-on-windows.md](install-ruby-opencv-with-rubyinstaller-on-windows.md).

## Sample code

### Load and Display an Image

A sample to load and display an image. An equivalent code of [this tutorial](http://docs.opencv.org/doc/tutorials/introduction/display_image/display_image.html#display-image).

```ruby
require 'opencv'
include OpenCV

# Usage: `ruby display_image.rb ImageToLoadAndDisplay`
# ARGV[0] is the image file, for example, './data/lena.jpg'

if ARGV.size == 0
  puts "Usage: ruby #{__FILE__} ImageToLoadAndDisplay"
  exit
end

image = nil
begin
  image = CvMat.load(ARGV[0], CV_LOAD_IMAGE_COLOR) # Read the file.
rescue
  puts 'Could not open or find the image.'
  exit
end

window = GUI::Window.new('Display window') # Create a window for display.
window.show(image) # Show our image inside it.
GUI::wait_key # Wait for a keystroke in the window.
```

### Face Detection

A sample to detect faces from an image.

```ruby
require 'opencv'
include OpenCV

# Usage: `ruby face_recognizer.rb source destination`
# ARGV[0] is the source image, for example, './data/face.jpg'
# ARGV[1] is the destination image, for example, './data/face_detected.jpg'

if ARGV.length < 2
  puts "Usage: `ruby #{__FILE__} source destination`"
  exit
end

DATA = './data/haarcascades/haarcascade_frontalface_alt.xml'
detector = CvHaarClassifierCascade::load(DATA)
image = CvMat.load(ARGV[0])
detector.detect_objects(image).each do |region|
  color = CvColor::Blue
  image.rectangle! region.top_left, region.bottom_right, :color => color
end

image.save_image(ARGV[1])
window = GUI::Window.new('Face detection')
window.show(image)
GUI::wait_key
```

For more samples, see [examples/*.rb](examples)

## OpenCV Modules

The Ruby wrapper for OpenCV provides access to a wide range of image processing and computer vision functionalities through the following modules:

### Main Modules

- `OpenCV::CvPoint`
- `OpenCV::CvPoint2D32f`
- `OpenCV::CvPoint3D32f`
- `OpenCV::CvSize`
- `OpenCV::CvSize2D32f`
- `OpenCV::CvRect`
- `OpenCV::CvScalar`
- `OpenCV::CvColor`
- `OpenCV::CvSlice`
- `OpenCV::CvTermCriteria`
- `OpenCV::CvBox2D`
- `OpenCV::CvFont`
- `OpenCV::IplConvKernel`
- `OpenCV::CvMoments`
- `OpenCV::CvHuMoments`
- `OpenCV::CvConvexityDefect`
- `OpenCV::CvSURFPoint`
- `OpenCV::CvSURFParams`
- `OpenCV::CvMemStorage`
- `OpenCV::CvSeq`
- `OpenCV::Curve`
- `OpenCV::PointSet`
- `OpenCV::CvChain`
- `OpenCV::CvContour`
- `OpenCV::CvContourTree`
- `OpenCV::CvMat`
- `OpenCV::IplImage`
- `OpenCV::CvHistogram`
- `OpenCV::CvCapture`
- `OpenCV::CvVideoWriter`
- `OpenCV::CvLine`
- `OpenCV::CvTwoPoints`
- `OpenCV::CvCircle32f`
- `OpenCV::CvFeatureTree`
- `OpenCV::CvConnectedComp`
- `OpenCV::CvAvgComp`
- `OpenCV::CvHaarClassifierCascade`

### Algorithms and Face Recognizers

- `OpenCV::Algorithm`
- `OpenCV::FaceRecognizer`
- `OpenCV::EigenFaces`
- `OpenCV::FisherFaces`
- `OpenCV::LBPH`

### Graphical User Interface (GUI)

The `OpenCV::GUI` module includes:

- `OpenCV::GUI::Window`
- `OpenCV::GUI::Trackbar`
- `OpenCV::GUI::MouseEvent`

### Error Codes

The following are specific error codes used within the library:

- `OpenCV::CvError`
- `OpenCV::CvStsError`
- `OpenCV::CvStsParseError`
- `OpenCV::CvGpuApiCallError`
- Other error codes

---

This listing provides an overview of the modules and functionalities available in the Ruby wrapper for OpenCV. For more information on how to use these modules in your projects, refer to the examples included in the `/examples` folder.

## LICENSE

The BSD Liscense, see [License.txt](License.txt)
