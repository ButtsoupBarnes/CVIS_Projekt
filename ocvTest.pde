import gab.opencv.*;
import org.opencv.core.Core;
import org.opencv.core.Scalar;
import org.opencv.core.Mat;
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
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  video.start();
}

void draw() { 
  opencv.loadImage(video);
  opencv.setROI(250,250,10,10);
  image(opencv.getInput(), 0, 0);
  rect(250,250,10,10);

  Mat rgb = opencv.getColor();
  Mat subRGB = rgb.submat(250,260,250,260);
  Scalar colourSum = Core.sumElems(subRGB);
  //float factor = 1.0/(640.0*480.0);
  float factor = 1.0/(10.0*10.0);
  Scalar divisor = new Scalar(factor,factor,factor,factor);
  Scalar avgColour = colourSum.mul(divisor);
  //println(avgColour);
  //closeToGreen(avgColour);  
  println(closeToGreen(avgColour));  
}

boolean closeToColour(Scalar colour, Scalar groundTruth){  
  Scalar subtractedColour = subtractTwoScalars(groundTruth,colour);
  Scalar absOfSubtractedColour = absOfScalar(subtractedColour);
  float lengthOfSubtractedColour = lengthOfScalar(absOfSubtractedColour);
  println(lengthOfSubtractedColour);
  if(lengthOfSubtractedColour < 60) return true;
  return false;
}

boolean closeToGreen(Scalar colour){
  Scalar green = new Scalar(65,108,21,255);
  return closeToColour(colour, green);
}

boolean closeToOrange(Scalar colour){
  Scalar orange = new Scalar(65,108,21,255);
  return closeToColour(colour, orange);
}

Scalar subtractTwoScalars(Scalar a, Scalar b){
  Scalar result;
  result = new Scalar(a.val[0]-b.val[0],a.val[1]-b.val[1],a.val[2]-b.val[2],a.val[3]-b.val[3]);
  return result;
}

Scalar absOfScalar(Scalar s){
  Scalar result;
  result = new Scalar(abs((float)s.val[0]),abs((float)s.val[1]),abs((float)s.val[2]),abs((float)s.val[3]));
  return result; 
}

float lengthOfScalar(Scalar s){
  float result;
  result = (float)(s.val[0] + s.val[1] + s.val[2] + s.val[3]);
  return result;
}


void captureEvent(Capture c) {
  c.read();
}

void keyPressed() {

}

//To-Do
//-RoI vergrößern und mittig anordnen
//-für 10 Ziffern verschieden genuge Farben finden und so anmalen
//-Groundtruth für alle 10 Ziffern anlegen