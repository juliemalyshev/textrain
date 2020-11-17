/**
    CSci-4611 Assignment #1 Text Rain
**/


import processing.video.*;

// Global variables for handling video data and the input selection screen
String[] cameras;
Capture cam;
Movie mov;
PImage inputImage;
boolean inputMethodSelected = false;
int numLetters = 0;
int threshold = 100;
Character[] letters = new Character[100000]; 
String myString = "hey whats up luna";              //create normal string

char[] text = new char[myString.length()];
int[] xInit = new int[myString.length()];

int randNumLetters = 0;
Character[] randLetters = new Character[100000]; 
String randString ="sdf egjwz oq mbdx";                //create random string
char[] randText = new char[randString.length()];
int[] randXInit = new int[randString.length()];

color[] threshStore = new color[width*height*height*width];       //initialize threshold store array
boolean toggle = false;                                // create toggle for threshcontrol

void setup() {
  
  size(1280, 720);  
  inputImage = createImage(width, height, RGB);
  
  for(int i = 0; i < myString.length(); i++) {  //fill char array with characters
      text[i] = myString.charAt(i); 
  } 
  for(int i = 0; i < myString.length(); i++){
    xInit[i] = (i *70) + 10;
  }
  for(int i = 0; i < randString.length(); i++) {  //fill random char array with characters
      randText[i] = randString.charAt(i); 
  } 
  for(int i = 0; i < randString.length(); i++){
    randXInit[i] = (i *70) + 10;
  }
   textFont(loadFont("CourierNewPS-BoldMT-48.vlw"), 32);    //load font
   letters[0] = new Character();
   randLetters[0] = new Character();
}

 
void draw() {
  
  // When the program first starts, draw a menu of different options for which camera to use for input
  // The input method is selected by pressing a key 0-9 on the keyboard
  if (!inputMethodSelected) {
    cameras = Capture.list();
    int y=40;
    text("O: Offline mode, test with TextRainInput.mov movie file instead of live camera feed.", 20, y);
    y += 40; 
    for (int i = 0; i < min(9,cameras.length); i++) {
      text(i+1 + ": " + cameras[i], 20, y);
      y += 40;
    }
    return;
  }
   set(0, 0, inputImage);

  // This part of the draw loop gets called after the input selection screen, during normal execution of the program.

  
  // STEP 1.  Load an image, either from a movie file or from a live camera feed. Store the result in the inputImage variable
  
  if ((cam != null) && (cam.available())) {
    cam.read();
    inputImage.copy(cam, 0,0,cam.width,cam.height, 0,0,inputImage.width,inputImage.height);
    pushMatrix();
    translate(cam.width,0);
    scale(-1,1); 
    image(cam,0,0);
    popMatrix();
  }
  else if ((mov != null) && (mov.available())) {
    mov.read();
    inputImage.copy(mov, 0,0,mov.width,mov.height, 0,0,inputImage.width,inputImage.height);
    //pushMatrix();
    //translate(mov.width*2,0);
    //scale(-1,1); 
    //image(mov,0,0,width,height);
    //popMatrix();
  }



  // Fill in your code to implement the rest of TextRain here..

  // Tip: This code draws the current input image to the screen
  
 
  toGrayScale();
  updateThreshstore();
  
  if (toggle) {
    threshControl();   
  }
  
 if (random(20) < 1) {                                          //randomly add normal letters to array
   letters[++numLetters] = new Character(); 
 }
 if (random(10)<1){
   randLetters[++randNumLetters] = new Character();             // randomly add random letters array
 }
 
 
 
 
 //make random letters and normal letters fall
 
 for (int i = 0; i < numLetters; i++) {                         
   letters[i].fall();
 }
 
 for(int i = 0; i <randNumLetters; i++){
   randLetters[i].randFall();
 
  }
}

class Character {
  int xPos;
  int yPos;
  int randAlpha = 255;
  int alpha = 255;
  int y = 0;
  int rand = (int)random(myString.length()); // choose random letter to fall
  float startFall = 0;
  float dT= 0;                    // change in time 
  float now = 0;
  float velocity = 0;
  float distance = 0;
  int start = 0;
  color col = color(random(255), random(255), random(255));
  int threshold = 100;
  float randAcc = random(30);
  
  void fall() {
    if(y<0) {      // if y pos is ever negative, reset
        y=0;
     }
     for (int i = -1; i < (y-distance); i ++){                                  //loop to ensure that it checks every pixel
        if(threshStore[xInit[rand]+inputImage.width*(y-i)] == color(0,0,0) ){
          y=y-i;
          startFall  = millis();                                             //reseting the time
         
        }
     }
      if(threshStore[xInit[rand]+inputImage.width*(y)] == color(0,0,0) ){
         fill(red(col),green(col),blue(col),randAlpha);
          text(randText[rand], randXInit[rand], y);
          randAlpha-=30;
          if(randAlpha<0){
            randAlpha=0;
      
          }
      }
      
    //calculating acceleration
    if(start==0){
      startFall  = millis();
    }
      start = 1;
      now = millis();
      dT = (now-(startFall))/1000;
      velocity = randAcc*(dT);
      distance = velocity * (dT);
      y = y + round((distance));
      if(y>736){
        y=736;
      }
     fill(red(col),green(col),blue(col),alpha);
     
     text(text[rand], xInit[rand], y);
     
     
     
 
  }
  
  //same function as fall but for random letters
  
  void randFall(){
    if(y<0) {
        y=0;
     }
     //print(y, distance + "\n");
    for (int i = -1; i < (y-distance); i ++){
    if(threshStore[xInit[rand]+inputImage.width*(y-i)] == color(0,0,0) ){
      y=y-i;
      startFall  = millis();
     
    }
    }
    if(threshStore[xInit[rand]+inputImage.width*(y)] == color(0,0,0) ){
     fill(red(col),green(col),blue(col),randAlpha);
      text(randText[rand], randXInit[rand], y);
      randAlpha-=30;
      if(randAlpha<0){
        randAlpha=0;
  
      }
    }
    //calculating acceleration
    if(start==0){
      startFall  = millis();
    }
      start = 1;
      now = millis();
      dT = (now-(startFall))/1000;
      velocity = randAcc*(dT);
      distance = velocity * (dT);
      y = y + round((distance));
      if(y>736){
        y=736;
      }
     fill(red(col),green(col),blue(col),randAlpha);
    
     text(randText[rand], randXInit[rand], y);
  
  }
  

  
}

 void threshControl(){                                    //this function controls the debugging mode
   loadPixels();
   for (int i = 0; i < width; i ++){
      for(int j = 0; j < height;j++){
        int index1D = i + width*j;
        float green = green(pixels[index1D]);
        float red = red(pixels[index1D]);
        float blue = blue(pixels[index1D]);
        int grayScale = (int)(green + red + blue)/3;
        pixels[index1D] = grayScale;
        
       // updatePixels();
        if(pixels[index1D] > threshold){
          pixels[index1D] = color(255,255,255);
        
          
        }else{
          pixels[index1D] = color(0, 0, 0); 
          
        }
        
        
    }
    
    }
    updatePixels();
 }
 
 
 
 void updateThreshstore(){                                  //this function updates the other array of pixels
   loadPixels();
   for (int i = 0; i < width; i ++){
      for(int j = 0; j < height;j++){
       int index1D = i + width*j;
        float green = green(pixels[index1D]);
        float red = red(pixels[index1D]);
        float blue = blue(pixels[index1D]);
        int grayScale = (int)(green + red + blue)/3;
        pixels[index1D] = grayScale;
       if(pixels[index1D] > 150){
            threshStore[index1D] = color(255,255,255);
            
       }else{
           
            threshStore[index1D] = color(0, 0, 0);
       }
      }
   }
  
 }
 
 void toGrayScale(){                                  // this function turns the screen to grayscale 
   loadPixels();
   for (int i = 0; i < width; i ++){
      for(int j = 0; j < height;j++){
        int index1D = i + width*j;
        float green = green(pixels[index1D]);
        float red = red(pixels[index1D]);
        float blue = blue(pixels[index1D]);
        int grayScale = (int)(green + red + blue)/3;
        pixels[index1D] = color(grayScale,grayScale,grayScale);
      }
   }
   updatePixels();
 }
 



   
 


void keyPressed() {
                                   
  
  if (!inputMethodSelected) {
    // If we haven't yet selected the input method, then check for 0 to 9 keypresses to select from the input menu
    if ((key >= '0') && (key <= '9')) { 
      int input = key - '0';
      if (input == 0) {
        println("Offline mode selected.");
        mov = new Movie(this, "TextRainInput3.mov");
        mov.loop();
        inputMethodSelected = true;
      }
      else if ((input >= 1) && (input <= 9)) {
        println("Camera " + input + " selected.");           
        // The camera can be initialized directly using an element from the array returned by list():
        cam = new Capture(this, cameras[input-1]);
        cam.start();
        inputMethodSelected = true;
      }
     
    }
    return;
  }


  // This part of the keyPressed routine gets called after the input selection screen during normal execution of the program
  // Fill in your code to handle keypresses here..
  
  if (key == CODED) {
    if (keyCode == UP) {
      // up arrow key pressed
      threshold+=10;
    }
    else if (keyCode == DOWN) {
      // down arrow key pressed
      threshold-=10;
    }
  }
  else if (key == ' ') {
    // space bar presse
    toggle = !toggle;
  } 
  
}
