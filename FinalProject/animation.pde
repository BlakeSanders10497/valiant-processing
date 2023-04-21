// Class for animating a sequence of PImages.
// Adapted from https://processing.org/examples/animatedsprite.html
import java.util.*;

class Animation {
  List<PImage> images;
  int frame = 0;

  // Timing, in milliseconds
  int timeOfLastFrame;
  final int FRAME_DURATION = 200;
  
  // constructor for an animation instance 
  Animation(PImage... images) {
    this.images = new LinkedList<PImage>();
    reset();

    for (PImage img : images) {
      this.images.add(img);
    }
  }

  // resets the time frame for animations
  void reset() {
    frame = 0;
    timeOfLastFrame = millis();
  }

  // draws a frame from the animation to the screen 
  void display(float screenX, float screenY) {
    int timeSinceLastFrame = millis() - timeOfLastFrame;
    if(timeSinceLastFrame > FRAME_DURATION) {
      frame = (frame+1) % images.size();
      timeOfLastFrame = millis();
    }
    
    image(images.get(frame), screenX, screenY);
  }
  
  // returns the width of an image 
  int getWidth() {
    return images.get(0).width;
  }
}
