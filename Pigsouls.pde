//Jonathan Chan
//28-1-2019
//pigsoul system



class pigsouls {
  PImage img;
  int maxPigX, maxPigY;
  float[] r = new float[1024*1024];
  float[] g = new float[1024*1024];
  float[] b = new float[1024*1024];
  
  
  pigsouls(PImage imgfile, int maxX, int maxY) {
    //imgfile: name of the image, maxX: width of picture, maxY: height of picture
    img = imgfile;
    img.resize(maxX, maxY);
    maxPigX = maxX;
    maxPigY = maxY;  
    
    for (int i = 0; i < maxPigX; i++) {
               for (int j = 0; j < maxPigY; j++) {
                 r[j*maxPigX+i] = red(img.pixels[j*maxPigX+i]);
                 g[j*maxPigX+i] = green(img.pixels[j*maxPigX+i]);
                 b[j*maxPigX+i] = blue(img.pixels[j*maxPigX+i]);
               }
    }
    
    //off for noiseDrawing()
    
  }
  
  
   void mouseDrawing(float Size, String omg, boolean spddy) {
     //Size: size of the pixel, omg(REAL or BLUR): style of drawing, spddy(true or false): whether size related to the speed
     
     //save the position of the mouse
     int x = floor(min(max(0,mouseX), maxPigX));
     int y = floor(min(max(0,mouseY), maxPigY));
     
     //calculate the speed
     float mspd = (((mouseY-pmouseY)^2 + (mouseX-pmouseX)^2)^(1/2))/0.3;
     
     //display the pixels
     if (x < maxPigX && x > 0){
       if (y < maxPigY && y > 0){
         if (omg == "REAL") {
           for (int i = 0; i < maxPigX; i++) {
             for (int j = 0; j < maxPigY; j++) {
               if (spddy == true) {
                 if (dist(x, y, i, j) < mspd*Size/15) {
                 pushMatrix();
                 translate(i, j);
                 display(i, j, 1);
                 popMatrix();              
               }
               } else if (spddy == false) {
                 if (dist(x, y, i, j) < Size) {
                 pushMatrix();
                 translate(i, j);
                 display(i, j, 1);
                 popMatrix(); 
                 }
               }
             }
           }  
         } else if (omg == "BLUR") {
           
          pushMatrix();
          translate(x, y);
          if (spddy == true) {
            display(x, y, mspd*Size/15);
          } else if (spddy == false) {
            display(x, y, Size);
          }
          popMatrix();
         }
       }
     }
   }
   void noiseDrawing(int num, float Size, float spd, String omg, String spddy) {
     //num: number of "snakes", Size: size of pixels, spd: speed of snakes
     //omg(REAL or BLUR): style of drawing, spddy(true or false): whether size related to the speed
     
     //CAUTION: the following has to be set up in order for this function to work
     //   float[] off = new float[100];
     //for (int i = 0; i < 100; i++) {
     //    off[i] = 100*i;
     //  }
     
     for (int r = 0; r < num; r++) {
       
       //path of snake by noise()
       int x = round(map(noise(off[r]+=spd), 0, 1, -maxPigX*.5, maxPigX*1.5));
       int y = round(map(noise(off[r+50]+=spd), 0, 1, -maxPigY*.5, maxPigY*1.5));
       
       //last position of "snakes"
       int px = round(map(noise(off[r]-spd), 0, 1, -maxPigX*.5, maxPigX*1.5));
       int py = round(map(noise(off[r+50]-spd), 0, 1, -maxPigY*.5, maxPigY*1.5));
       
       //calculate the speed
       float mspd = (((x-px)^2 + (y-py)^2)^(1/2))/0.3;
       
       //display the pixels
       if (x < maxPigX && x > 0){
         if (y < maxPigY && y > 0){
           if (omg == "REAL") {
             for (int i = 0; i < maxPigX; i++) {
               for (int j = 0; j < maxPigY; j++) {
                 if (spddy == "SPEED") {
                   if (dist(x, y, i, j) < mspd*Size/15) {
                   setDisplay(i, j);             
                   }
                 } else if (spddy == "NORMAL") {
                   if (dist(x, y, i, j) < Size) {
                   setDisplay(i, j);   
                   }
                 }
               }
             }  
           } else if (omg == "BLUR") {
              pushMatrix();
              translate(x, y);
              if (spddy == "SPEED") {
                display(x, y, mspd*Size/15);
               } else if (spddy == "NORMAL") {
                display(x, y, Size);
              } else if (spddy == "RED") {
                display(x, y, map(red(img.pixels[y*maxPigX+x]), 0, 255, 0, Size));
              }
            popMatrix();
           }
         }
       }   
     }
  
   }
   
   
   void display(int x, int y, float Size) {
     //x: x-coord of pixel, y: y-coord of pixel, Size: size of pixel
     
     //display pixel as circle
     fill(r[y*maxPigX+x], g[y*maxPigX+x], b[y*maxPigX+x]);
     ellipse(0, 0, Size, Size);
   }
   
   void rectDisplay(int x, int y, float Size) {
     //x: x-coord of pixel, y: y-coord of pixel, Size: size of pixel
     
     //display pixel as circle
     fill(r[y*maxPigX+x], g[y*maxPigX+x], b[y*maxPigX+x]);
     rect(0, 0, Size, Size);
   }
   void setDisplay(int x, int y) {
     color c = color(r[y*maxPigX+x], g[y*maxPigX+x], b[y*maxPigX+x]);
     set(x, y, c);
   }
   
   void reread() {
   //rescan the pixels for realtime color abjustment  
     
      for (int i = 0; i < maxPigX; i++) {
               for (int j = 0; j < maxPigY; j++) {
                 r[j*maxPigX+i] = red(img.pixels[j*maxPigX+i]);
                 g[j*maxPigX+i] = green(img.pixels[j*maxPigX+i]);
                 b[j*maxPigX+i] = blue(img.pixels[j*maxPigX+i]);
               }
    }
   }
     
   
   void moreRed() {
     //increase the 'redness' of the image
     
     for (int i = 0; i < maxPigX; i++) {
               for (int j = 0; j < maxPigY; j++) {
                 if (r[j*maxPigX+i] > 150) {
                   r[j*maxPigX+i] = min(r[j*maxPigX+i]+ 50, 255);
                 }
               }
    }
   
   }
   
   void mouseRed() {
     //the red of the pixels is related to the x position of the mouse
     
      for (int i = 0; i < maxPigX; i++) {
               for (int j = 0; j < maxPigY; j++) {
                 if (r[j*maxPigX+i] > 100) {
                   r[j*maxPigX+i] = r[j*maxPigX+i]*map(mouseX, 0, width, 0.5, 1.5);
                   r[j*maxPigX+i] = constrain(r[j*maxPigX+i], 0, 255);
                 }
               }
    }
   }
   
   void mouseBright() {
       //the brightness of the pixels is related to the y position of the mouse

     
     for (int i = 0; i < maxPigX; i++) {
               for (int j = 0; j < maxPigY; j++) {
                 r[j*maxPigX+i] = r[j*maxPigX+i]*mouseY/width*2;
                 g[j*maxPigX+i] = g[j*maxPigX+i]*mouseY/width*2;
                 b[j*maxPigX+i] = b[j*maxPigX+i]*mouseY/width*2;
                 r[j*maxPigX+i] = constrain(r[j*maxPigX+i], 0, 255);
                 g[j*maxPigX+i] = constrain(g[j*maxPigX+i], 0, 255);
                 b[j*maxPigX+i] = constrain(b[j*maxPigX+i], 0, 255);
                 
                   
                 
               }
    }
   }
   void noiseBright() {
     //the birghtness change automatically using noise()
     //float boff has to be set
     
       
       for (int i = 0; i < maxPigX; i++) {
         for (int j = 0; j < maxPigY; j++) {
             r[j*maxPigX+i] = r[j*maxPigX+i]*map(noise(boff), 0, 1, 0, 4);
                 g[j*maxPigX+i] = g[j*maxPigX+i]*map(noise(boff), 0, 1, 0, 4);
                 b[j*maxPigX+i] = b[j*maxPigX+i]*map(noise(boff), 0, 1, 0, 4);
                 r[j*maxPigX+i] = constrain(r[j*maxPigX+i], 0, 255);
                 g[j*maxPigX+i] = constrain(g[j*maxPigX+i], 0, 255);
                 b[j*maxPigX+i] = constrain(b[j*maxPigX+i], 0, 255);
                 
                   
                 
               }
    }
    boff+=0.02;
   }
     
   
}
