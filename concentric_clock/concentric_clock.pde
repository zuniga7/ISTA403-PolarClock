import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

/*
 * @author Haziel Zuniga
 * @author Stephen Kovalsky
 */

Minim minim;
AudioOutput out;
Oscil      wave;
Frequency  currentFreq;

//dials to set alarm hour, min
int alarmHour = 22;
int alarmMin = 49;
boolean linear = false;

boolean alarmOn = true;
int febLength = lenFeb(isLeap(year()));
int[] monthLengths = {
  31, febLength, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
};


// starting positions for our arc positions
float secPos = (PI * second())/30 - PI/2;
float minPos = (PI * minute())/30 - PI/2;
float hourPos = (PI * hour())/12 - PI/2;
float dayPos = (((2 * PI * day()) / monthLengths[month()-1]) - PI/2);
float monthPos = (PI * month())/6- PI/2;

void setup () {
  size(600, 600);
  //allows window to be resized
  if (frame != null) {
    frame.setResizable(true);
  }
  fill(255);
  
  textAlign(CENTER);
  minim = new Minim(this);
  Ani.init(this);
}

// keep track of when these change in the draw function so that 
// we can trigger the animations
int second = second();
int minute = minute();
int hour = hour();


void draw() {
  textSize(width/12);

  //click to turn to alarm off
  if (keyPressed && key == 'a') {
    alarmOn = !alarmOn;

  }

  if (alarmOn==true && (int)hour == alarmHour && (int)minute == alarmMin) {
    alarmAction();
  } else {
    background(0);
  }

  // on time change
  if (second != second()) {
    timeTransition();
    second = second();
    minute = minute();
    hour = hour();
  }
  drawConcentricClock();

  // display regular clock
  String amOrPm = (hour>=12)? "PM" : "AM";
  text(hour%12+ ":" +nf(minute, 2)+ ":" +nf(second, 2)+ " " +amOrPm, width/2, height/2);
}

void drawConcentricClock() {
  strokeWeight(12);
  noFill();

  if (!linear) {

    //second hand
    stroke(0, 255, 255);
    arc(width/2, height/2, width/2, height/2, -HALF_PI, secPos);

    //minute hand time
    stroke(0, 128, 128);
    strokeWeight(12);
    arc(width/2, height/2, (width/2)-25, (height/2)-25, -HALF_PI, minPos);

    //hour hand time
    stroke(0, 0, 250);
    strokeWeight(12);
    arc(width/2, height/2, (width/2)-50, (height/2)-50, -HALF_PI, hourPos);

    //day hand
    strokeWeight(12);
    stroke(0, 0, 128);
    arc(width/2, height/2, (width/2)-75, (height/2)-75, -HALF_PI, dayPos);

    //month hand
    stroke(0, 64, 128);
    arc(width/2, height/2, (width/2)-100, (height/2)-100, -HALF_PI, monthPos);

    if (mousePressed) {
      //minute hand alarm
      stroke(0, 250, 0);
      strokeWeight(6);
      arc(width/2, height/2, (width/2)-25, (height/2)-25, -HALF_PI, (PI * alarmMin)/30 - PI/2);

      //hour hand alarm
      stroke(250, 0, 0);
      strokeWeight(6);
      arc(width/2, height/2, (width/2)-50, (height/2)-50, -HALF_PI, (PI * alarmHour)/12 - PI/2);

      //print alarm time
      textSize(width/16);
      String amOrPm = (alarmHour>=12 && alarmHour < 24)? "PM" : "AM";

      if (alarmHour%12 == 0) {
        text("Alarm Time: " + 12 + ":" + nf(abs(alarmMin%60), 2)+ " " +amOrPm, width/2, height-(width/16));
      } else {
        text("Alarm Time: " + abs(alarmHour%12) + ":" +nf(abs(alarmMin%60), 2)+ " " +amOrPm, width/2, height-(width/16));
      }
    }


    // linear
  } else {
    stroke(0, 255, 255);
    line(0, height/2 - 12, map(second(), 0, 59, 0, width), height/2 - 12);
    stroke(0, 128, 128);
    line(0, height/2, map(minute(), 0, 59, 0, width), height/2);
    stroke(0, 0, 255);
    line(0, height/2 + 12, map(hour(), 0, 23, 0, width), height/2 + 12);
  }
}

void alarmAction() {
  //rapidly change the background color
  background(random(255), random(255), random(255));

  //play an alarm sound??
}

//determines if its currently a leap year or not
boolean isLeap(int year) {
  if (year() % 4 != 0) {
    return false;
  } else if (year() % 100 != 0) {
    return true;
  } else if (year() % 400 != 0) {
    return false;
  } else {
    return true;
  }
}

//function determines the length of February based whether its a leap year or not
int lenFeb(boolean isleap) {
  if (isleap) {
    return 28;
  } else {
    return 29;
  }
}

// takes care of moving the time rings from one position to the other
void timeTransition() {
  Ani.to(this, 1.0, "secPos", (PI * second())/30 - PI/2, Ani.ELASTIC_OUT);
  Ani.to(this, 1.0, "minPos", (PI * minute())/30 - PI/2, Ani.ELASTIC_OUT);
  Ani.to(this, 1.0, "hourPos", (PI * hour())/12 - PI/2, Ani.ELASTIC_OUT);
  Ani.to(this, 1.0, "dayPos", (((2 * PI * day()) / monthLengths[month()-1]) - PI/2), Ani.ELASTIC_OUT);
  Ani.to(this, 1.0, "monthPos", (PI * month())/6- PI/2, Ani.ELASTIC_OUT);
}

// change linear on key pressed
void keyPressed() {
  if (keyCode == TAB) {
    linear = !linear;

    if (linear) {
      secPos = second();
      minPos = minute();
      hourPos = hour();
    } else {
      secPos = (PI * second())/30 - PI/2;
      minPos = (PI * minute())/30 - PI/2;
      hourPos = (PI * hour())/12 - PI/2;
    }
  }
}

// adjust alarm time on drag... is alarmHour working?
void mouseDragged() {
  alarmMin = (int) map(mouseX, 0, width, 0, 59);
  alarmHour =(int) map(mouseY, 0, height, 0, 23);
}

