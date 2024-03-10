#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

const char* ssid = "Alonzos";
const char* password = "2tacosdecarnitas";
const int valvePin = D1; // Change to the pin you're using

ESP8266WebServer server(80);

void handleValveOpen() {
    digitalWrite(valvePin, HIGH); // Opens the valve
    server.send(200, "text/plain", "Valve Opened");
}

void handleValveClose() {
    digitalWrite(valvePin, LOW); // Closes the valve
    server.send(200, "text/plain", "Valve Closed");
}

void setup() {
    pinMode(valvePin, OUTPUT);
    digitalWrite(valvePin, LOW); // Ensure valve is closed on startup

    Serial.begin(115200);
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println(WiFi.localIP());
    Serial.println("Connected to WiFi");

    server.on("/openValve", handleValveOpen);
    server.on("/closeValve", handleValveClose);
    server.begin();
}

void loop() {
    server.handleClient();
}
