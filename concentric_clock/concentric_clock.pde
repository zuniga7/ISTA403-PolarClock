/*
 * @author Haziel Zuniga
 * @author Stephen Kovalsky
 */

//dials to set alarm hour, min, sec 
int alarmHour = 0;
int alarmMin = 0;
int alarmSec = 0;

void setup () {
  size(300, 300);

  fill(0);
  textSize(32);
  textAlign(CENTER);
}

void draw() {
  int second = second();
  int minute = minute();
  int hour = hour();

  background(255, 255, 255);

  // display regular clock
  String amOrPm = (hour>=12)? "PM" : "AM";
  text(hour%12+ ":" +nf(minute, 2)+ ":" +nf(second, 2)+ " " +amOrPm, width/2, height/2);

  drawConcentricClock();
}

void drawConcentricClock() {
  strokeWeight(10);
  stroke(255, 0, 0);
  line(0, 5, map(second(), 0, 59, 0, width), 5);
  stroke(0, 255, 0);
  line(0, 15, map(minute(), 0, 59, 0, width), 15);
  stroke(0, 0, 255);
  line(0, 25, map(hour(), 0, 23, 0, width), 25);
}

void alarmAction() {
}

