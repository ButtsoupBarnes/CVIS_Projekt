import gab.opencv.*;
import org.opencv.core.Core;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

PImage referenceImage;
PImage threshFrame;
int threshold = 123;

void setup() {
  referenceImage = loadImage("referenceImage.jpg");
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);

  video.start();
}

void draw() { 
  opencv.loadImage(video);

  //opencv.threshold(threshold);

  //println(Core.sumElems(opencv.getGray()));

  threshFrame = opencv.getSnapshot();

  //opencv.diff(referenceImage);
  image(opencv.getSnapshot(), 0, 0);

  scale(2);
}

void captureEvent(Capture c) {
  c.read();
}

void keyPressed() {
  if (key == 'f') {
    threshFrame.get(0, 0, 100, 100).save("referenceImage.jpg");
  }

  if ( key == CODED ) {
    if ( keyCode == UP ) {
      threshold++;
      println(threshold);
    }
    if ( keyCode == DOWN ) {
      threshold--;
      println(threshold);
    }
  }
}