class brush{
 float x;
 float y;
 color avgColor;
 PVector velocity;
 PVector accel;
 PVector jerk;
 boolean hitWall=false;
 
 brush(int x, int y){
  this.x = x;
  this.y = y;
  velocity = new PVector(.5,random(-3,3));
  accel = new PVector(random(-.03,.03),random(-.03,.03));
  jerk = new PVector(random(-.003,.003),random(-.003,.003));
 }
 brush(int x, int y, PVector velocity){
  this.x = x;
  this.y = y;
  this.velocity = velocity;
  accel = new PVector(random(-.3,.3),random(-.3,.3));
  jerk = new PVector(random(-.03,.03),random(-.03,.03));
 } 
 void drawStroke(color c){
   fill(c);
   ellipse(x, y, 8,8);
   hitWall = false;
   
   x+= velocity.x;
   y+= velocity.y;
   velocity.add(accel);
   accel.add(jerk);
   if(abs(velocity.x) > 5){
    accel.x = -accel.x; 
   }
   if(abs(velocity.y) > 5){
    accel.y = -accel.y; 
   }
   
   if(abs(accel.x) > 1){
    jerk.x = -jerk.x; 
   }
   if(abs(accel.y) > 1){
    jerk.y = -jerk.y; 
   }
   
   if(x<0 || x > width){
    velocity.x = -velocity.x; 
    hitWall = true;
   }
   
   if(y<0 || y>height){
    velocity.y = -velocity.y; 
    hitWall = true;
   }
 }
}
