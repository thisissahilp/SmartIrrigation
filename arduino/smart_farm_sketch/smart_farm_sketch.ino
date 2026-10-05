/*
 * SMART FARM IRRIGATION CONTROLLER - ARDUINO UNO + HC-05
 * Hardware Communication Watchdog & Heartbeat Protocol
 * 
 * Communication Protocol:
 *   "1" (0x31) -> Turn Pump ON
 *   "0" (0x30) -> Turn Pump OFF
 *   "H" (0x48) -> Heartbeat signal from Flutter app (sent every 500ms)
 * 
 * Hardware Watchdog:
 *   If pump is ON and no "H" heartbeat is received within 2000ms,
 *   the Arduino automatically deactivates the relay to prevent over-watering.
 */

#include <SoftwareSerial.h>

// SoftwareSerial for HC-05 (D10 = Arduino RX -> HC-05 TX, D11 = Arduino TX -> HC-05 RX)
SoftwareSerial btSerial(10, 11); 

const int RELAY_PIN = 7;             // Relay signal pin
const bool RELAY_ACTIVE_LOW = true;  // Set true for active-LOW relay modules

unsigned long lastHeartbeat = 0;
const unsigned long SAFETY_TIMEOUT = 2000; // 2 seconds safety timeout
bool pumpOn = false;

void setRelay(bool turnOn) {
  if (RELAY_ACTIVE_LOW) {
    digitalWrite(RELAY_PIN, turnOn ? LOW : HIGH);
  } else {
    digitalWrite(RELAY_PIN, turnOn ? HIGH : LOW);
  }
}

void setup() {
  Serial.begin(9600);      // Hardware serial monitor
  btSerial.begin(9600);    // HC-05 Bluetooth module baud rate

  pinMode(RELAY_PIN, OUTPUT);
  setRelay(false); // Ensure relay is OFF on startup

  Serial.println("==================================================");
  Serial.println("SMART FARM IRRIGATION CONTROLLER INITIALIZED");
  Serial.println("Watchdog Safety Timeout: 2000 ms");
  Serial.println("Protocol: '1'=ON, '0'=OFF, 'H'=Heartbeat");
  Serial.println("==================================================");
}

void loop() {
  // 1. Process incoming Bluetooth serial data
  while (btSerial.available() > 0) {
    char ch = btSerial.read();

    if (ch == '1') {
      pumpOn = true;
      lastHeartbeat = millis();
      setRelay(true);
      Serial.println("[PUMP ON] Command '1' received. Relay ACTIVATED.");
      btSerial.println("PUMP ON");
    } 
    else if (ch == '0') {
      pumpOn = false;
      setRelay(false);
      Serial.println("[PUMP OFF] Command '0' received. Relay DEACTIVATED.");
      btSerial.println("PUMP OFF");
    } 
    else if (ch == 'H' || ch == 'h') {
      if (pumpOn) {
        lastHeartbeat = millis();
        // Serial.println("[HEARTBEAT] 'H' received. Timer reset.");
      }
    }
  }

  // 2. HARDWARE SAFETY COMMUNICATION WATCHDOG
  // Check if BLE connection dropped or phone went out of range while pump is ON
  if (pumpOn && (millis() - lastHeartbeat > SAFETY_TIMEOUT)) {
    pumpOn = false;
    setRelay(false);
    Serial.println("⚠️ SAFETY WATCHDOG TRIGGERED: BLE Heartbeat timeout (>2000ms). Relay SHUT OFF.");
    btSerial.println("WATCHDOG_SAFETY_TIMEOUT");
  }
}
