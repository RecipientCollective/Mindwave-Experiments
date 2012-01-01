/*
____ ____ ____ _ ___  _ ____ _  _ ___    ____ ____ _    _    ____ ____ ___ _ _  _ ____
|__/ |___ |    | |__] | |___ |\ |  |     |    |  | |    |    |___ |     |  | |  | |___
|  \ |___ |___ | |    | |___ | \|  |     |___ |__| |___ |___ |___ |___  |  |  \/  |___

+------------------------------------------------------------------------------------+
|          Mindwave processing experiment  by Recipient.cc colelctive                |
|        This program is free software: you can redistribute it and/or modify        |
|        it under the terms of the GNU General Public License as published by        |
|        the Free Software Foundation, either version 3 of the License, or           |
|        (at your option) any later version.                                         |
|                                                                                    |
|        This program is distributed in the hope that it will be useful,             |
|        but WITHOUT ANY WARRANTY; without even the implied warranty of              |
|        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
|        GNU General Public License for more details.                                |
|                                                                                    |
|        You should have received a copy of the GNU General Public License           |
|        along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
|                                                                                    |
|        REFERENCES                                                                  |
|        http://processing.org                                                       |
|        http://blog.blprnt.com/blog/blprnt/processing-json-the-new-york-times       |
|        https://github.com/agoransson/JSON-processing                               |
|                                                                                    |
+------------------------------------------------------------------------------------+
*/

import controlP5.*;
import processing.net.*; 
import org.json.*;
Client myBrainwave; 
ControlP5 controlP5;

String dataIn; 
Boolean Debug = false;
 
void setup() { 
  size(850, 650); 
  background(102);
  controlP5 = new ControlP5(this);
  
  //min,max,start,x,y,larghezza ,altezza
  
  controlP5.addSlider("delta",0,300000,0,10,10,750,50).setId(1);
  controlP5.addSlider("theta",0,300000,0,10,64,750,50).setId(2);
  controlP5.addSlider("lowAlpha",0,300000,0,10,118,750,50).setId(3);
  controlP5.addSlider("highAlpha",0,300000,0,10,172,750,50).setId(4);
  controlP5.addSlider("lowBeta",0,300000,0,10,226,750,50).setId(5);
  controlP5.addSlider("highBeta",0,300000,0,10,280,750,50).setId(6);
  controlP5.addSlider("lowGamma",0,300000,0,10,334,750,50).setId(7);
  controlP5.addSlider("highGamma",0,300000,0,10,388,750,50).setId(8);
  controlP5.addSlider("attention",0,100,0,10,442,750,50).setId(9);
  controlP5.addSlider("meditation",0,100,0,10,496,750,50).setId(10);
  controlP5.addToggle("DebugMode",false,10,550,50,50);
  // Connect to the local machine at port 13854.
  //we use socket connection.
  // This example will not run if you haven't
  // previously started "ThinkGear connector" server
  myBrainwave = new Client(this, "127.0.0.1", 13854); 
  myBrainwave.write("{\"enableRawOutput\": false, \"format\": \"Json\"}");
  
} 
 
void draw() { 
  if (myBrainwave.available() > 0) { 
   dataIn = myBrainwave.readString();
   if (Debug) {
   //debug print 
   println(dataIn);  
   }
 try{
    JSONObject nytData = new JSONObject(dataIn);
    JSONObject results = nytData.getJSONObject("eegPower");
    JSONObject resultsM = nytData.getJSONObject("eSense");
    //JSONObject resultsB = nytData.getJSONObject("blinkStrength");
    //int total = nytData.length();
    int delta = results.getInt("delta");
    controlP5.controller("delta").setValue(delta);
    int theta = results.getInt("theta");
    controlP5.controller("theta").setValue(theta);
    int lowAlpha = results.getInt("lowAlpha");
    controlP5.controller("lowAlpha").setValue(lowAlpha);
    int highAlpha = results.getInt("highAlpha");
    controlP5.controller("highAlpha").setValue(highAlpha);
    int lowBeta = results.getInt("lowBeta");
    controlP5.controller("lowBeta").setValue(lowBeta);
    int highBeta = results.getInt("highBeta");
    controlP5.controller("highBeta").setValue(highBeta);
    int lowGamma = results.getInt("lowGamma");
    controlP5.controller("lowGamma").setValue(lowGamma);
    int highGamma = results.getInt("highGamma");
    controlP5.controller("highGamma").setValue(highGamma);
    int attention = resultsM.getInt("attention");
    controlP5.controller("attention").setValue(attention);
    int meditation = resultsM.getInt("meditation");
    controlP5.controller("meditation").setValue(meditation);
    
    
    
    //println(highGamma);
    
    } catch (JSONException e) {
    if (Debug){
println ("There was an error parsing the JSONObject.");
println(e);    
              } 
    }
}
}

void keyPressed() {
  
if (Debug){
  if (key == 'q') {
    print("___---====Json + Raw OFF====---___");
    myBrainwave.write("{\"enableRawOutput\": false, \"format\": \"Json\"}");
  }
  if (key == 'w') {
    print("___---====Json + Raw ON====---___");
    myBrainwave.write("{\"enableRawOutput\": true, \"format\": \"Json\"}");
  }
   if (key == 'e') {
    print("___---====BinaryPacket + Raw OFF====---___");
    myBrainwave.write("{\"enableRawOutput\": false, \"format\": \"BinaryPacket\"}");
  }
  if (key == 'r') {
    print("___---====BinaryPacket + Raw ON====---___");
    myBrainwave.write("{\"enableRawOutput\": true, \"format\": \"BinaryPacket\"}");
  }
  
  } else {
    println("enable debug mode to view data in and modify format");
  }
}

void DebugMode(boolean theFlag) {
  if(theFlag==true) {
    Debug = true;
    println("DEBUG TOGGLE ON.");
  } else {
    Debug = false;
    println("DEBUG TOGGLE OFF.");
  }
}
