import processing.serial.*;    // Importing the serial library to communicate with the Arduino 
Serial myPort;      // Initializing a vairable named 'myPort' for serial communication

String PM2_5Value = "0";   // Variable for changing the background color
String pm_air4thai = "0";
String pm_netpie = "0";
PImage bg;
PFont f;

String today = "2019-" + str(month()) + "-" + str(day());
String api_air4thai = "http://air4thai.pcd.go.th/webV2/history/api/data.php?stationID=35t&param=PM25&type=hr&sdate=" + today + "&edate=" + today + "&stime=00&etime=24";

void setup(){  
  size(1280, 720);     // Size of the serial window, you can increase or decrease as you want
  //size(480,360);
  surface.setResizable(true);
  bg = loadImage("map.png");
  f = createFont("TH Sarabun New Bold", 100*height/720, true);
  textAlign(RIGHT);
  
  //println(Serial.list());
  //String portName = Serial.list()[0];
  //myPort = new Serial(this, portName, 115200); // Set the com port and the baud rate according to the Arduino IDE  
  //myPort.bufferUntil ('\n');   // Receiving the data from the Arduino IDE
} 

void serialEvent(Serial myPort){
  PM2_5Value = myPort.readStringUntil('\n');  // Changing the background color according to received data
  //print(PM2_5Value);
}

void draw ( ){
  call_air4thai();
  call_netpie();
  
  image(bg, 0, 0, width, height);
  textFont(f);
  
  textSize(100*height/720);
  text(pm_netpie, width/1.72, height/5);
  
  textSize(70*height/720);
  text(pm_air4thai, width/5.5, height/1.65);
  //println(mouseX + ", " + mouseY);
  //println(pm_air4thai);
  delay(5000);
}

void call_air4thai(){
  String[] lines = loadStrings(api_air4thai);
  
  JSONObject json = parseJSONObject(lines[0]);
  JSONArray stations = json.getJSONArray("stations");
  
  JSONObject station = stations.getJSONObject(0);
  JSONArray datum = station.getJSONArray("data");
  
  JSONObject data = datum.getJSONObject(datum.size()-1);
  pm_air4thai = str(data.getInt("PM25"));
}

void call_netpie(){
  
  String api_air4thai = "https://api.netpie.io/feed/01dustyfeed?apikey=hKf5ouC4ofhsah5AAegsVurlIOE6ZtDh&granularity=10seconds&since=24hours&filter=pm2_5";
  String[] lines = loadStrings(api_air4thai);
  
  JSONObject json = parseJSONObject(lines[0]);
  JSONArray lastest_data = json.getJSONArray("lastest_data");
  
  JSONObject pm2_5 = lastest_data.getJSONObject(0);
  JSONArray values = pm2_5.getJSONArray("values");
  
  JSONArray data = values.getJSONArray(0);
  pm_netpie = str(data.getInt(1));
}
