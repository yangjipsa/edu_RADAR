#include <Servo.h>

Servo myservo;
const int trigPin = 4;
const int echoPin = 5;

int minAngle = 30;
int maxAngle = 150;

void setup() {
  Serial.begin(9600);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  myservo.attach(3);  // 서보 핀
  myservo.write(90);
  delay(1000);
}

void loop() {
  for (int pos = minAngle; pos <= maxAngle; pos += 5) {
    myservo.write(pos);
    delay(200);  // 서보 안정화

    long duration = getEchoDuration();
    float distance = duration * 0.034 / 2;

    Serial.print("ANGLE : ");
    Serial.print(pos);
    Serial.print(", DISTANCE : ");
    Serial.println(distance);
  }

  for (int pos = maxAngle; pos >= minAngle; pos -= 5) {
    myservo.write(pos);
    delay(200);  // 서보 안정화

    long duration = getEchoDuration();
    float distance = duration * 0.034 / 2;

    Serial.print("ANGLE : ");
    Serial.print(pos);
    Serial.print(", DISTANCE : ");
    Serial.println(distance);
  }
}

long getEchoDuration() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  return pulseIn(echoPin, HIGH, 30000);  // 최대 30ms 대기 (5m)
}
