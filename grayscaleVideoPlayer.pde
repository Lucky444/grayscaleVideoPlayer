int w = 0;
int h = 0;
int totalFrames = 0;

boolean loaded = false;
int currentFrame = 0;
int pixelSize = 0;

byte[][][] frames;

void setup() {
  size(1920, 1080); 
  background(0);

  frames = loadlvfFile("well.lvf");

  text("Loaded", width/2, height/2);
}

int fT = 0;
void draw() {
  if (loaded) {
    DisplayFrame(currentFrame);
    currentFrame ++;
    if (currentFrame == totalFrames) {
      currentFrame = 0;
    }
  }
}

void DisplayFrame(int frameID) {

  noStroke();
  fill(0);
  background(0);

  for (int y = 0; y < h; y ++) {
    for (int x = 0; x < w; x++) {
      color c = color(int(frames[frameID][x][y] & 255));
      fill(c);
      rect(x*pixelSize, y*pixelSize, pixelSize, pixelSize);
    }
  }
}


//########################################### Loading
byte[][][] loadlvfFile(String path) {
  byte[] byteBuffer = loadBytes(path);
  byte[] bTEMP = byteBuffer;

  for (int i = 0; i < 8; i++) {
    w += int(byteBuffer[i] & 255); 
    h += int(byteBuffer[i+7] & 255);
  }

  byteBuffer = new byte[byteBuffer.length-16];
  for (int i = 16; i < bTEMP.length; i++) {
    byteBuffer[i-16] = bTEMP[i];
  }

  totalFrames = byteBuffer.length / (w*h);
  pixelSize = height/h;

  byte[][][] _frames;
  _frames = new byte[totalFrames][w][h];

  int currentFrame = 0;
  int currentXIndex = 0;
  int currentYIndex = 0;

  for (int i = 0; i < byteBuffer.length; i++) {
    currentXIndex ++;
    if (currentXIndex >= w) {
      currentYIndex ++;
      currentXIndex = 0;
    }
    if (currentYIndex >= h) {
      currentFrame ++;
      currentYIndex = 0;
      currentXIndex = 0;
    }

    if (currentFrame == totalFrames) {
      loaded = true;
      return _frames;
    }

    _frames[currentFrame][currentXIndex][currentYIndex] = byteBuffer[i];
  }
  return null;
}
