import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress supercollider;

void setup() {
  size(500, 400);
  background(#FF760D);
  noFill();
  stroke(255);
  smooth();
  
  oscP5 = new OscP5(this, 12000);
  supercollider = new NetAddress("127.0.0.1", 57120);
}

float noise_num = 0;

void draw() {
  fill(#FF760D, 50);  
  rect(0, 0, width, height);
  
  stroke(255);
  ellipse(mouseX, mouseY, 20, 20);
  
  //Perlin noise
  //float x;
  
  //x = noise(noise_num) + width;
  
  //noise_num = noise_num + 0.1;

  //OscMessage msg = new OscMessage("/starhit");
  //msg.add(map(mouseY, 0, height, 0, 1));
  //oscP5.send(msg, supercollider);
}

void mouseDragged() {
  OscMessage msgx = new OscMessage("/mousex");
  OscMessage msgy = new OscMessage("/mousey");
  
  msgx.add(abs(mouseX));
  msgy.add(abs(mouseY));
  
  oscP5.send(msgx, supercollider);
  oscP5.send(msgy, supercollider);
  
  //oscP5.send(new OscMessage("/starhit").add(mouseX), supercollider);
  //oscP5.send(new OscMessage("/starhit").add(mouseY), supercollider);
  
  println("sending osc");
  println(abs(mouseX), " Mouse X position");
  println(abs(mouseY), " Mouse Y position");
}