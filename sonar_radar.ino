#include <Servo.h>

Servo myservo;
const int trigPin = 4;
const int echoPin = 5;

int minAngle = 30;
int maxAngle = 150;

void setup() {
  Serial.begin(115200);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  myservo.attach(3);  // 서보 핀
  myservo.write(90);
  delay(1000);
}

void loop() {
  for (int pos = minAngle; pos <= maxAngle; pos += 2) {
    myservo.write(pos);
    delay(100);  // 서보 안정화

    long duration = getEchoDuration();
    float distance = duration * 0.034 / 2;

    // ✅ Processing과 연동되는 형식으로 출력
    Serial.print(pos);
    Serial.print(",");
    Serial.print(distance, 2); // 소수점 둘째 자리까지
    Serial.println(".");
  }

  for (int pos = maxAngle; pos >= minAngle; pos -= 2) {
    myservo.write(pos);
    delay(100);

    long duration = getEchoDuration();
    float distance = duration * 0.034 / 2;

    Serial.print(pos);
    Serial.print(",");
    Serial.print(distance, 2);
    Serial.println(".");
  }
}

long getEchoDuration() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  return pulseIn(echoPin, HIGH, 30000);  // 타임아웃 30ms
}
