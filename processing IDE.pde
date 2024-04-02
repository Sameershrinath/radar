import processing.serial.*; // imports library for serial communication
import java.awt.event.KeyEvent; // imports library for reading the data from the serial port
import java.io.IOException;
import java.net.*;

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
int x;
int y;
void setup() {

  size (1750,1000 ); // ***CHANGE THIS TO YOUR SCREEN RESOLUTION***
  smooth();
  myPort = new Serial(this, "COM7", 9600); // starts the serial communication
  myPort.bufferUntil('.'); // reads the data from the serial port up to the character '.'. So actually it reads this: angle,distance.
background(0, 0, 50);

}
void draw() {

    if (iDistance<40 && frameCount % 20 < 10) { // Change the blinking speed by adjusting the modulo and divisor values
        fill(955,0,0); // Text color when visible
        text("Detected", width-width*0.10, height-height*0.955); // Replace "Blinking Text" with your desired text and (x, y) with the coordinates
    
}   
    if(iDistance>40) {        text("Out of Range", width-width*0.10, height-height*0.925); // Replace "Blinking Text" with your desired text and (x, y) with the coordinates

    }

  
  fill(98, 245, 31);
  // simulating motion blur and slow fade of the moving line
  noStroke();
  fill(0, 4); 
  rect(0, 0, width, height-height*0.065); 

  fill(98, 245, 31); // green color
  // calls the functions for drawing the radar
  drawRadar(); 
  drawLine();
  drawObject();
  drawText();
}



void serialEvent (Serial myPort) { // starts reading data from the Serial Port
  // reads the data from the Serial Port up to the character '.' and puts it into the String variable "data".
  data = myPort.readStringUntil('.');
  data = data.substring(0, data.length()-1);

  index1 = data.indexOf(","); // find the character ',' and puts it into the variable "index1"
  angle= data.substring(0, index1); // read the data from position "0" to position of the variable index1 or thats the value of the angle the Arduino Board sent into the Serial Port
  distance= data.substring(index1+1, data.length()); // read the data from position "index1" to the end of the data pr thats the value of the distance

  // converts the String variables into Integer
  iAngle = int(angle);
  iDistance = int(distance);
}
void drawRadar() {
  pushMatrix();
  translate(width/2, height-height*0.074); // moves the starting coordinats to new location
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);
// draws the arc lines
  for (int r = 40; r <= (width - width * 0.0625) / 2; r += 40) {
    ellipse(0, 0, r * 2, r * 2);
  }
  // draws the angle lines
  line(-width/2, 0, width/2, 0);

  line(0, 0, (-width/2)*cos(radians(15)), (-width/2)*sin(radians(15))); 
    line(0, 0, (-width/2)*cos(radians(30)), (-width/2)*sin(radians(30)));
    line(0, 0, (-width/2)*cos(radians(45)), (-width/2)*sin(radians(45)));
  line(0, 0, (-width/2)*cos(radians(60)), (-width/2)*sin(radians(60)));
    line(0, 0, (-width/2)*cos(radians(75)), (-width/2)*sin(radians(75)));
  line(0, 0, (-width/2)*cos(radians(90)), (-width/2)*sin(radians(90)));
    line(0, 0, (-width/2)*cos(radians(105)), (-width/2)*sin(radians(105)));
  line(0, 0, (-width/2)*cos(radians(120)), (-width/2)*sin(radians(120)));
      line(0, 0, (-width/2)*cos(radians(135)), (-width/2)*sin(radians(135)));
  line(0, 0, (-width/2)*cos(radians(150)), (-width/2)*sin(radians(150)));
      line(0, 0, (-width/2)*cos(radians(165)), (-width/2)*sin(radians(165)));
 line((-width/2)*cos(radians(15)), 0, width/2, 0);
  line((-width/2)*cos(radians(30)), 0, width/2, 0);
  line((-width/2)*cos(radians(45)), 0, width/2, 0);
  popMatrix();
}
void drawObject() {
  pushMatrix();
  translate(width/2, height-height*0.074); // moves the starting coordinats to new location
  strokeWeight(9);
  stroke(255, 0, 0); // red color
  pixsDistance = iDistance*((height-height*0.1666)*0.025); // covers the distance from the sensor from cm to pixels
  // limiting the range to 40 cms
  if (iDistance<40) {
    // draws the object according to the angle and the distance
    line(pixsDistance*cos(radians(iAngle)), -pixsDistance*sin(radians(iAngle)), (width-width*0.505)*cos(radians(iAngle)), -(width-width*0.505)*sin(radians(iAngle)));
  }
  popMatrix();
}
void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30, 250, 60);
  translate(width/2, height-height*0.074); // moves the starting coordinats to new location
  line(0, 0, (height-height*0.12)*cos(radians(iAngle)), -(height-height*0.12)*sin(radians(iAngle))); // draws the line according to the angle
  popMatrix();
}






void drawText() { // draws the texts on the screen

 int millisPassed = millis();
  int secondsPassed = millisPassed / 1000;
  int minutesPassed = secondsPassed / 60;
  int hoursPassed = minutesPassed / 60;

  // Calculate remaining minutes and seconds after hours are deducted
  int remainingMinutes = minutesPassed % 60;
  int remainingSeconds = secondsPassed % 60;

  String currentTime = nf(hoursPassed, 2) + ":" + nf(remainingMinutes, 2) + ":" + nf(remainingSeconds, 2); // Format the time


  pushMatrix();
  if (iDistance>40) {
    noObject = "Out of Range";
  } else {
    noObject = "In Range";
  }
  fill(0, 0, 0);
  noStroke();
  rect(0, height-height*0.0648, width, height);
  fill(98, 245, 31);
  textSize(25);
text("        " + currentTime , width-width*0.123, height-height*0.895);
text("Range 40 cm" , width-width*0.103, height-height*0.87);

   text("10cm", width-width*0.3854, height-height*0.0833);
  text("20cm", width-width*0.281, height-height*0.0833);
  text("30cm", width-width*0.177, height-height*0.0833);
  text("40cm", width-width*0.0729, height-height*0.0833);
  textSize(40);
  text("Suresh Gyan Vihar University(Project) ", width-width*0.975, height-height*0.0277);
  text("Angle: " + iAngle +" ", width-width*0.48, height-height*0.0277);
  text("Distance: ", width-width*0.26, height-height*0.0277);
  if (iDistance<40) {
    text("        " + iDistance +" cm", width-width*0.210, height-height*0.0277);
  }
  textSize(19);
  text("Btech CSE- AI & ML ", width-width*0.99, height-height*0.955);
  text("Sameer Shrinath ", width-width*0.99, height-height*0.925);

  textSize(25);
  fill(98, 245, 60);
  translate((width-width*0.4994)+width/2*cos(radians(30)), (height-height*0.0907)-width/2*sin(radians(30)));
  rotate(-radians(-60));
  text("30", 0, 0);
  resetMatrix();
  translate((width-width*0.503)+width/2*cos(radians(60)), (height-height*0.0888)-width/2*sin(radians(60)));
  rotate(-radians(-30));
  text("60", 0, 0);
  resetMatrix();
  translate((width-width*0.507)+width/2*cos(radians(90)), (height-height*0.0833)-width/2*sin(radians(90)));
  rotate(radians(0));
  text("90", 0, 0);
  resetMatrix();
  translate(width-width*0.513+width/2*cos(radians(120)), (height-height*0.07129)-width/2*sin(radians(120)));
  rotate(radians(-30));
  text("120", 0, 0);
  resetMatrix();
  translate((width-width*0.5104)+width/2*cos(radians(150)), (height-height*0.0574)-width/2*sin(radians(150)));
  rotate(radians(-60));
  text("150", 0, 0);
  popMatrix();
}
