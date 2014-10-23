/* --------------------------------------------------------------------------
 * SimpleOpenNI Draw Simple Figure
 
 lei chen 2014
 */

import SimpleOpenNI.*;

SimpleOpenNI  context;

PVector hand;

float len;
color torsoColor = color(149, 165, 166);
color fumeColor= color(231, 76, 60);

//draw cigi

Smoke[] fumes = new Smoke[500];
int fumesCount =500;
float noiseScale = 200, noiseStrength = 10, noiseZRange = 0.4;
float overlayAlpha = 80, fumesAlpha = 90, strokeWidth = 0.3;

float age = 100;
float r = 20;
float xOffset = 0.0;
float yOffset = 0.0;
boolean cigi = false;



void setup()
{
  context = new SimpleOpenNI(this);
   
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  
  // enable depthMap generation 
  context.enableDepth();
   
  // enable skeleton generation for all joints
  context.enableUser();

  stroke(0,0,255);
  strokeWeight(3);
  smooth();
  
  size(context.depthWidth(), context.depthHeight()*2); 
  
  
  //DRAW CIGI
  for(int i=0; i<fumes.length; i++) fumes[i] = new Smoke();

  
}

void draw()
{
  background(0);
  stroke(255);
  len = (PVector.dist(getJointPosition(SimpleOpenNI.SKEL_NECK),getJointPosition(SimpleOpenNI.SKEL_TORSO)))/3;
  // update the cam
  context.update();
  hand = getJointPosition(SimpleOpenNI.SKEL_LEFT_HAND);
  
  // draw depthImageMap
  //image(context.depthImage(),0,0);
  
  // draw the skeleton if it's available
  if(context.isTrackingSkeleton(1)) {
    drawSimpleFigure();
    if(cigi == true){
    drawCigi(getJointPosition(SimpleOpenNI.SKEL_LEFT_HAND));
    }
  }
}




void drawSimpleFigure() {





//HEAD AND NECK
//
//drawLine(getJointPosition(SimpleOpenNI.SKEL_HEAD),getJointPosition(SimpleOpenNI.SKEL_NECK) );
//


//drawbody

drawBody(getJointPosition(SimpleOpenNI.SKEL_NECK), getJointPosition(SimpleOpenNI.SKEL_LEFT_SHOULDER), getJointPosition(SimpleOpenNI.SKEL_TORSO), getJointPosition(SimpleOpenNI.SKEL_RIGHT_SHOULDER));
drawHip(getJointPosition(SimpleOpenNI.SKEL_TORSO), getJointPosition(SimpleOpenNI.SKEL_LEFT_HIP),getJointPosition(SimpleOpenNI.SKEL_RIGHT_HIP));


//DRAW LEFT LEG
drawLeg(getJointPosition(SimpleOpenNI.SKEL_TORSO), getJointPosition(SimpleOpenNI.SKEL_LEFT_HIP),getJointPosition(SimpleOpenNI.SKEL_LEFT_KNEE), getJointPosition(SimpleOpenNI.SKEL_LEFT_FOOT), true);


//DRAW RIGHT LEG
drawLeg(getJointPosition(SimpleOpenNI.SKEL_TORSO), getJointPosition(SimpleOpenNI.SKEL_RIGHT_HIP),getJointPosition(SimpleOpenNI.SKEL_RIGHT_KNEE), getJointPosition(SimpleOpenNI.SKEL_RIGHT_FOOT), false);


//DRAW LEFT ARM
drawArm(getJointPosition(SimpleOpenNI.SKEL_NECK), getJointPosition(SimpleOpenNI.SKEL_LEFT_SHOULDER),getJointPosition(SimpleOpenNI.SKEL_LEFT_ELBOW), getJointPosition(SimpleOpenNI.SKEL_LEFT_HAND), true);

//DRAW RIGHT ARM
drawArm(getJointPosition(SimpleOpenNI.SKEL_NECK), getJointPosition(SimpleOpenNI.SKEL_RIGHT_SHOULDER),getJointPosition(SimpleOpenNI.SKEL_RIGHT_ELBOW), getJointPosition(SimpleOpenNI.SKEL_RIGHT_HAND), false);


//DRAW HEAD
drawHead(getJointPosition(SimpleOpenNI.SKEL_NECK));





}



PVector getJointPosition(int joint) {
  PVector jointPositionRealWorld = new PVector();
  PVector jointPositionProjective = new PVector();
  context.getJointPositionSkeleton(1, joint, jointPositionRealWorld);
  context.convertRealWorldToProjective(jointPositionRealWorld, jointPositionProjective);
  
  return jointPositionProjective;
}



void drawBody( PVector neck, PVector lShoulder, PVector torso, PVector rShoulder ){
  
  fill(torsoColor);
  noStroke();  
  
  
  beginShape();
  vertex(neck.x, neck.y-len);
  vertex(lShoulder.x, lShoulder.y);
  vertex(torso.x - len, torso.y);
  vertex(torso.x + len, torso.y);
  vertex(rShoulder.x, rShoulder.y);
  endShape(CLOSE);  
}



void drawHip(PVector torso, PVector lHip, PVector rHip){
  fill(torsoColor);
  noStroke();  
  
  beginShape();
  vertex(torso.x - len, torso.y);
  vertex(lHip.x, lHip.y);
  vertex(rHip.x, rHip.y);
  vertex(torso.x + len, torso.y);
  
  endShape(CLOSE);  
 

}


void drawLeg(PVector torso, PVector hip, PVector knee, PVector foot, Boolean left){
  fill(torsoColor);
  noStroke();  
  
  beginShape();
  vertex(torso.x, torso.y);
  vertex(hip.x, hip.y);
  vertex(knee.x, knee.y);
  vertex(foot.x, foot.y);
  if(left == true){  
  vertex(knee.x+len/2, knee.y);
  }
  else {
    vertex(knee.x-len/2, knee.y);
  }
  
  vertex(torso.x, torso.y);
  
  endShape(CLOSE);  
 

}

void drawArm(PVector neck, PVector shoulder, PVector elbow, PVector hand, Boolean left){
  fill(torsoColor);
  
  PVector center = PVector.add(neck, shoulder);
  center.div(2);

  noStroke();  
  
  beginShape();



  vertex(center.x, center.y);
  vertex(shoulder.x, shoulder.y);
  vertex(elbow.x, elbow.y);
  vertex(hand.x, hand.y);
  if(left == true){  
  vertex(elbow.x+len/3, elbow.y);
  }
  else {
    vertex(elbow.x-len/3, elbow.y);
  }

  
  endShape();  
 

}


void drawHead( PVector neck){
  fill(torsoColor);
  ellipse(neck.x, neck.y-20, len*1.5, len*1.5);
}

PVector getP(PVector p1, PVector p2, float num){
  PVector p = PVector.add(p1, p1);
  p.div(num);
  
  return p;
  
}






void drawLine(PVector position1, PVector position2){
  line(position1.x, position1.y, position2.x, position2.y);
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}

void keyPressed()
{
  switch(key)
  {
  case 'c':
    cigi = true;
    break;
    
    case 'd':
    cigi = false;
    break;
  }
 
  
  
}  


void drawCigi(PVector hand){
  
  for(int i=0; i<fumesCount; i++) {

    stroke(fumeColor);
    fumes[i].update(hand);
}
    strokeWeight(5);
    stroke(255);
    line(hand.x-r, hand.y-r, hand.x, hand.y);



}

