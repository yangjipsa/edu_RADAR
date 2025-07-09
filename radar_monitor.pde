import processing.serial.*; // imports library for serial communication
import java.awt.event.KeyEvent; // imports library for reading the data from the serial port
import java.io.IOException;
Serial myPort; // defines Object Serial
// defubes variables
String angle="";
String distance="";
String data="";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1=0;
int index2=0;
PFont orcFont;
void setup() {
  
 size (960, 540);
 //size ((1920/2), (1080/2));

 smooth();
 myPort = new Serial(this,"COM5", 115200); // starts the serial communication
 //myPort = new Serial(this, "/dev/cu.usbmodem11201", 115200);
 myPort.bufferUntil('.'); // reads the data from the serial port up to the character '.'. So actually it reads this: angle,distance.
// orcFont = loadFont("OCRAExtended-30.vlw");
}
void draw() {
  
  fill(98,245,31);
 // textFont(orcFont);
  // simulating motion blur and slow fade of the moving line
  noStroke();
  fill(0,4); 
  rect(0, 0, width, 1010); 
  
  fill(98,245,31); // green color
  // calls the functions for drawing the radar
  drawRadar(); 
  drawLine();
  drawObject();
  drawText();
}
void serialEvent(Serial myPort) {
  data = myPort.readStringUntil('.');
  if (data == null) return;
  data = data.trim();

  int index = data.indexOf(",");
  if (index > 0) {
    angle = data.substring(0, index);
    distance = data.substring(index + 1);

    try {
      iAngle = int(angle);
      iDistance = int(float(distance));  // float 처리 후 정수 변환

      println("▶ RECEIVED: " + data);
      println("→ Parsed angle: " + iAngle + ", distance: " + iDistance);
    } catch (Exception e) {
      println("⚠️ Parsing error: " + e);
    }
  }
}

void drawRadar() {
  pushMatrix();
  translate(960/2,1000/2); // moves the starting coordinats to new location
  noFill();
  strokeWeight(2);
  stroke(98,245,31);
  // draws the arc lines
  arc(0,0,1800/2,1800/2,PI,TWO_PI);
  arc(0,0,1400/2,1400/2,PI,TWO_PI);
  arc(0,0,1000/2,1000/2,PI,TWO_PI);
  arc(0,0,600/2,600/2,PI,TWO_PI);
  // draws the angle lines
  line(-960/2,0,960/2,0);
  line(0,0,-960*cos(radians(30))/2,-960*sin(radians(30))/2);
  line(0,0,-960*cos(radians(60))/2,-960*sin(radians(60))/2);
  line(0,0,-960*cos(radians(90))/2,-960*sin(radians(90))/2);
  line(0,0,-960*cos(radians(120))/2,-960*sin(radians(120))/2);
  line(0,0,-960*cos(radians(150))/2,-960*sin(radians(150))/2);
  line(-960*cos(radians(30)),0,960/2,0);
  popMatrix();
}
void drawObject() {
  pushMatrix();
  translate(960/2,1000/2); // moves the starting coordinats to new location
  strokeWeight(9);
  stroke(255,10,10); // red color
  pixsDistance = iDistance*22.5/2; // covers the distance from the sensor from cm to pixels
  // limiting the range to 40 cms
  if(iDistance<40){
    // draws the object according to the angle and the distance
  line(pixsDistance*cos(radians(iAngle))/2,-pixsDistance*sin(radians(iAngle))/2,950*cos(radians(iAngle))/2,-950*sin(radians(iAngle))/2);
  }
  popMatrix();
}
void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30,250,60);
  translate(960/2,1000/2); // moves the starting coordinats to new location
  line(0,0,950*cos(radians(iAngle))/2,-950*sin(radians(iAngle))/2); // draws the line according to the angle
  popMatrix();
}
void drawText() { // draws the texts on the screen
  
  pushMatrix();
  if(iDistance>40) {
  noObject = "Out of Range";
  }
  else {
  noObject = "In Range";
  }
  fill(0,0,0);
  noStroke();
  rect(0, 1010/2, width, 1080/2);
  fill(98,245,31);
  textSize(15);
  text("10cm",1180/2,990/2);
  text("20cm",1380/2,990/2);
  text("30cm",1580/2,990/2);
  text("40cm",1780/2,990/2);
  textSize(20);
  text("Object: " + noObject, 240/2, 1050/2);
  text("Angle: " + iAngle +" °", 1050/2, 1050/2);
  text("Distance: ", 1380/2, 1050/2);
  if(iDistance<40) {
  text("                " + iDistance +" cm", 1400/2, 1050/2);
  }
  textSize(15);
  fill(98,245,60);
  translate((961+960*cos(radians(30)))/2,(982-960*sin(radians(30)))/2);
  rotate(-radians(-60));
  text("30°",0,0);
  resetMatrix();
  translate((954+960*cos(radians(60)))/2,(984-960*sin(radians(60)))/2);
  rotate(-radians(-30));
  text("60°",0,0);
  resetMatrix();
  translate((945+960*cos(radians(90)))/2,(990-960*sin(radians(90)))/2);
  rotate(radians(0));
  text("90°",0,0);
  resetMatrix();
  translate((935+960*cos(radians(120)))/2,(1003-960*sin(radians(120)))/2);
  rotate(radians(-30));
  text("120°",0,0);
  resetMatrix();
  translate((940+960*cos(radians(150)))/2,(1018-960*sin(radians(150)))/2);
  rotate(radians(-60));
  text("150°",0,0);
  popMatrix(); 
}
