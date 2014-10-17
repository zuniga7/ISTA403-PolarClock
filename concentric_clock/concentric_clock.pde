
/*
 * @author Haziel Zuniga
 * @author Stephen Kovalsky
 */

//dials to set alarm hour, min
int alarmHour = 1;
int alarmMin = 9;

boolean alarmOn = true;
int febLength = lenFeb(isLeap(year()));
int[] monthLengths = {31,febLength,31,30,31,30,31,31,30,31,30,31};


void setup () {
  size(300, 300);
  //allows window to be resized
  //if(frame != null) {
  //  frame.setResizable(true);
  //}
  fill(255);
  textSize(32);
  textAlign(CENTER);
}

void draw() {
  int second = second();
  int minute = minute();
  int hour = hour();
  
  if(alarmOn==true && (int)hour == alarmHour && (int)minute == alarmMin) {
    alarmAction();
    
    //click to turn to alarm off
    if(mousePressed) {
      alarmOn = false;
    }
  } else {
    background(0); 
  }
  
  drawConcentricClock();
  
  // display regular clock
  String amOrPm = (hour>=12)? "PM" : "AM";
  text(hour%12+ ":" +nf(minute, 2)+ ":" +nf(second, 2)+ " " +amOrPm, width/2, height/2);
}

void drawConcentricClock() {
  strokeWeight(12);
  noFill();
  
  //second hand
  stroke(0,255,255);
  arc(150, 150, 250, 250, -HALF_PI, (PI * second())/30 - PI/2);
  //line(0, 5, map(second(), 0, 59, 0, width), 5);
  
  //minute hand
  stroke(0,128,128);
  //line(0, 15, map(minute(), 0, 59, 0, width), 15);
  arc(150, 150, 225, 225, -HALF_PI,  (PI * minute())/30 - PI/2);
 
  //hour hand
  stroke(0,0,255);
  //line(0, 25, map(hour(), 0, 23, 0, width), 25);
  arc(150, 150, 200, 200, -HALF_PI,  (PI * hour())/12 - PI/2);
  
  //day hand
  stroke(0,0,128);
  arc(150, 150, 175, 175, -HALF_PI, (((2 * PI * day()) / monthLengths[month()-1]) - PI/2));

  //month hand
  stroke(0,64,128);
  arc(150, 150, 150, 150, -HALF_PI, (PI * month())/6- PI/2);
}

void alarmAction() {
  //rapidly change the background color
  background(random(255), random(255), random(255));
  
  //play an alarm sound??
}

//determines if its currently a leap year or not
boolean isLeap(int year) {
  if(year() % 4 != 0) {
    return false;
  } 
  else if(year() % 100 != 0) {
    return true;
  } 
  else if(year() % 400 != 0) {
    return false;
  }
  else {
    return true;
  }
}

//function determines the length of February based whether its a leap year or not
int lenFeb(boolean isleap) {
  if(isleap) {
    return 28;
  }
  else {
    return 29;
  }
}

