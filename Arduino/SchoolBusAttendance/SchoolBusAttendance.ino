#include <Arduino.h>
#include <Wire.h>
#include <WiFiManager.h>
#include <Preferences.h>
#include <Adafruit_PN532.h>
#include <SoftwareSerial.h>
#include <HardwareSerial.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <WiFiClientSecure.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <Adafruit_Fingerprint.h>

#define SDA_PIN 21                                                                           // Chân kết nối với chân SDA của PN532 (một loại cảm biến RFID/NFC)
#define SCL_PIN 22                                                                           // Chân kết nối với chân SCL của PN532
#define RxPin 16                                                                             // Chân RX của UART (giao tiếp qua chuẩn UART) kết nối với chân TxPin của module vân tay
#define TxPin 17                                                                             // Chân TX của UART kết nối với chân RxPin của module vân tay
#define FIREBASE_FUNCTION_URL "https://us-central1-attendanceschoolbus.cloudfunctions.net/"  // base URL
#define BAUDRATE 57600                                                                       // Tốc độ baud của UART
#define SER_BUF_SIZE 1024                                                                    // Kích thước buffer cho dữ liệu đọc từ UART
#define LED_PIN 18                                                                           // Chân kết nối với đèn LED
#define BUTTON 23                                                                            //chân kết nối với Button

HardwareSerial MySerial(2);                                     // Sử dụng HardwareSerial với UART 2
Adafruit_PN532 nfc(SDA_PIN, SCL_PIN);                           // Sử dụng thư viện PN532 để tương tác với cảm biến NFC
SoftwareSerial HZ1050(4, 3);                                    // Sử dụng SoftwareSerial để giao tiếp với một thiết bị khác (module có mã HZ1050)
Adafruit_Fingerprint finger = Adafruit_Fingerprint(&MySerial);  // Sử dụng thư viện Adafruit_Fingerprint để tương tác với cảm biến vân tay
Preferences preferences;                                        // Đối tượng Preferences để quản lý lưu trữ thông tin cài đặt trong bộ nhớ flash
WiFiClientSecure sslClient;                                     // Sử dụng thư viện WiFiClientSecure để thiết lập kết nối an toàn với máy chủ

// Đối tượng HTTPClient để thực hiện yêu cầu HTTP
HTTPClient http;
HTTPClient http2;
HTTPClient http3;

String value_key_13MHz = "";  // Chuỗi để lưu trữ giá trị từ khóa của mô-đun 13MHz
String value_key_125kHz = "";       // Chuỗi để lưu trữ giá trị từ khóa của mô-đun 125kHz
uint8_t value_key_finger = 0;       // biến để lưu trữ giá trị từ khóa của vân tay

int preStateButton = LOW;  // Lưu trạng thái trước đó của nút
bool isRegister = false;   // đăng ký/đăng nhập

/**
2 s:C=US, O=Google Trust Services LLC, CN=GTS Root R1
   i:C=BE, O=GlobalSign nv-sa, OU=Root CA, CN=GlobalSign Root CA
   a:PKEY: rsaEncryption, 4096 (bit); sigalg: RSA-SHA256
   v:NotBefore: Jun 19 00:00:42 2020 GMT; NotAfter: Jan 28 00:00:42 2028 GMT
*/
const char* root_ca = \
  "-----BEGIN CERTIFICATE-----\n"
  "MIIFYjCCBEqgAwIBAgIQd70NbNs2+RrqIQ/E8FjTDTANBgkqhkiG9w0BAQsFADBX\n"
  "MQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEQMA4GA1UE\n"
  "CxMHUm9vdCBDQTEbMBkGA1UEAxMSR2xvYmFsU2lnbiBSb290IENBMB4XDTIwMDYx\n"
  "OTAwMDA0MloXDTI4MDEyODAwMDA0MlowRzELMAkGA1UEBhMCVVMxIjAgBgNVBAoT\n"
  "GUdvb2dsZSBUcnVzdCBTZXJ2aWNlcyBMTEMxFDASBgNVBAMTC0dUUyBSb290IFIx\n"
  "MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAthECix7joXebO9y/lD63\n"
  "ladAPKH9gvl9MgaCcfb2jH/76Nu8ai6Xl6OMS/kr9rH5zoQdsfnFl97vufKj6bwS\n"
  "iV6nqlKr+CMny6SxnGPb15l+8Ape62im9MZaRw1NEDPjTrETo8gYbEvs/AmQ351k\n"
  "KSUjB6G00j0uYODP0gmHu81I8E3CwnqIiru6z1kZ1q+PsAewnjHxgsHA3y6mbWwZ\n"
  "DrXYfiYaRQM9sHmklCitD38m5agI/pboPGiUU+6DOogrFZYJsuB6jC511pzrp1Zk\n"
  "j5ZPaK49l8KEj8C8QMALXL32h7M1bKwYUH+E4EzNktMg6TO8UpmvMrUpsyUqtEj5\n"
  "cuHKZPfmghCN6J3Cioj6OGaK/GP5Afl4/Xtcd/p2h/rs37EOeZVXtL0m79YB0esW\n"
  "CruOC7XFxYpVq9Os6pFLKcwZpDIlTirxZUTQAs6qzkm06p98g7BAe+dDq6dso499\n"
  "iYH6TKX/1Y7DzkvgtdizjkXPdsDtQCv9Uw+wp9U7DbGKogPeMa3Md+pvez7W35Ei\n"
  "Eua++tgy/BBjFFFy3l3WFpO9KWgz7zpm7AeKJt8T11dleCfeXkkUAKIAf5qoIbap\n"
  "sZWwpbkNFhHax2xIPEDgfg1azVY80ZcFuctL7TlLnMQ/0lUTbiSw1nH69MG6zO0b\n"
  "9f6BQdgAmD06yK56mDcYBZUCAwEAAaOCATgwggE0MA4GA1UdDwEB/wQEAwIBhjAP\n"
  "BgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTkrysmcRorSCeFL1JmLO/wiRNxPjAf\n"
  "BgNVHSMEGDAWgBRge2YaRQ2XyolQL30EzTSo//z9SzBgBggrBgEFBQcBAQRUMFIw\n"
  "JQYIKwYBBQUHMAGGGWh0dHA6Ly9vY3NwLnBraS5nb29nL2dzcjEwKQYIKwYBBQUH\n"
  "MAKGHWh0dHA6Ly9wa2kuZ29vZy9nc3IxL2dzcjEuY3J0MDIGA1UdHwQrMCkwJ6Al\n"
  "oCOGIWh0dHA6Ly9jcmwucGtpLmdvb2cvZ3NyMS9nc3IxLmNybDA7BgNVHSAENDAy\n"
  "MAgGBmeBDAECATAIBgZngQwBAgIwDQYLKwYBBAHWeQIFAwIwDQYLKwYBBAHWeQIF\n"
  "AwMwDQYJKoZIhvcNAQELBQADggEBADSkHrEoo9C0dhemMXoh6dFSPsjbdBZBiLg9\n"
  "NR3t5P+T4Vxfq7vqfM/b5A3Ri1fyJm9bvhdGaJQ3b2t6yMAYN/olUazsaL+yyEn9\n"
  "WprKASOshIArAoyZl+tJaox118fessmXn1hIVw41oeQa1v1vg4Fv74zPl6/AhSrw\n"
  "9U5pCZEt4Wi4wStz6dTZ/CLANx8LZh1J7QJVj2fhMtfTJr9w4z30Z209fOU0iOMy\n"
  "+qduBmpvvYuR7hZL6Dupszfnw0Skfths18dG9ZKb59UhvmaSGZRVbNQpsg3BZlvi\n"
  "d0lIKO2d1xozclOzgjXPYovJJIultzkMu34qQb9Sz/yilrbCgj8=\n"
  "-----END CERTIFICATE-----\n";

//khai báo hàm
void setupWifi();
void initialize_RFID_13MHz();
void updateAttendance(String id);
void updateAttendance2(String id);
uint8_t getFingerprintID();
void updateAttendance3(String id);
void taskRFID125kHzFunction(void *pvParameters);
void taskRFID13MHzFunction(void *pvParameters);
void taskSendData2CloudFunction(void *pvParameters);
void taskFingerprintFunction(void *pvParameters);
void taskButtonFunction(void *pvParameters);

void setup(void) {
  Serial.begin(9600);                                  // Khởi động cổng serial cho PC
  MySerial.setRxBufferSize(SER_BUF_SIZE);              // Đặt kích thước buffer đọc cho Serial
  MySerial.begin(BAUDRATE, SERIAL_8N1, RxPin, TxPin);  // Bắt đầu Serial với tốc độ baud và cấu hình nhất định
  HZ1050.begin(9600);                                  // Bắt đầu serial kết nối với đầu đọc RFID 125kHz
  finger.begin(57600);                                 //kết nối với vân tay
  nfc.begin();                                         // Bắt đầu kết nối với đầu đọc RFID 13.56MHz

  initialize_RFID_13MHz();

  setupWifi();
  pinMode(LED_PIN, OUTPUT);
  pinMode(BUTTON, INPUT);  //Cài đặt chân  ở trạng thái đọc dữ liệu
  // Tạo các nhiệm vụ
  xTaskCreatePinnedToCore(taskRFID125kHzFunction, "RFID125kHz", 10000, NULL, 1, NULL, 1);
  xTaskCreatePinnedToCore(taskRFID13MHzFunction, "RFID13MHz", 10000, NULL, 1, NULL, 1);
  xTaskCreatePinnedToCore(taskSendData2CloudFunction, "sendData2Cloud", 10000, NULL, 1, NULL, 1);
  xTaskCreatePinnedToCore(taskFingerprintFunction, "Fingerprint", 10000, NULL, 1, NULL, 1);
  xTaskCreatePinnedToCore(taskButtonFunction, "Button", 10000, NULL, 1, NULL, 1);
}

void loop(void) {
  // Empty loop as tasks are managed by FreeRTOS Scheduler
}

//Hàm khởi tạo cho module RFID 13.56MHz
void initialize_RFID_13MHz() {
  // Lấy thông tin firmware version của module RFID
  uint32_t versiondata = nfc.getFirmwareVersion();
  if (!versiondata) {
    Serial.print("Không tìm thấy board PN53x");
    while (1)
      ;  // Lặp vô hạn nếu không tìm thấy board
  }
  // Cấu hình chế độ hoạt động cho module RFID
  nfc.SAMConfig();
}

//Hàm xử lý thông tin từ thẻ RFID 13.56MHz
String process_RFID_13MHz(uint8_t uid[], uint8_t uidLength) {
  String value = "";
  // Duyệt qua các byte trong UID của thẻ RFID và thêm vào chuỗi kết quả
  for (uint8_t i = 0; i < uidLength; i++) {
    value += uid[i];
  }
  // In ra thông tin UID của thẻ RFID
  Serial.println(">>>>>>>>>>>>>>>13.56MHz");
  Serial.println(value);
  return value;
}

//Hàm xử lý thông tin từ thẻ RFID 125kHz
String process_RFID_125kHz() {
  long value = 0;
  // Kiểm tra xem có dữ liệu mới từ module RFID 125kHz hay không
  if (HZ1050.available() > 0) {
    // Đọc 4 byte dữ liệu từ module RFID 125kHz
    for (int j = 0; j < 4; j++) {
      while (HZ1050.available() == 0) {};  // Đợi có dữ liệu mới
      int i = HZ1050.read();
      value += ((long)i << (24 - (j * 8)));  // Xây dựng giá trị từ 4 byte dữ liệu
    }
    Serial.println(value);
    return String(value);
  }
}

void taskButtonFunction(void *pvParameters) {
  for (;;) {
    int buttonStatus = digitalRead(BUTTON);  // Trạng thái hiện tại của nút
    if (buttonStatus != preStateButton) {
      // Trạng thái của nút đã thay đổi
      if (buttonStatus == HIGH) {
        // Nút được nhấn
        isRegister = !isRegister;
      }
    }
    Serial.print("is Register: ");
    Serial.println(isRegister);
    preStateButton = buttonStatus;
    vTaskDelay(1000 / portTICK_PERIOD_MS);
  }
}

//upload lên server
void taskSendData2CloudFunction(void *pvParameters) {
  for (;;) {
    // Nếu giá trị value_key_13 được thay đồi thì mới update
    if (value_key_13MHz.length() > 0) {
      Serial.print("Leng 13.56MHz: ");
      Serial.println(value_key_13MHz.length());
      isRegister ? registerIdStudentFunction() : updateAttendance(value_key_13MHz, 0, http);
      // Đặt lại giá trị để chuẩn bị cho lần đọc tiếp theo
      value_key_13MHz = "";
      delay(1000);
    }

    //tương tự
    if (value_key_125kHz.length() > 0) {
      Serial.print("Leng 125KHz: ");
      Serial.println(value_key_125kHz.length());
      isRegister ? registerIdStudentFunction() : updateAttendance(value_key_125kHz, 0, http2);
      value_key_125kHz = "";
      delay(1000);
    }

    if (value_key_finger > 0) {
      isRegister ? registerIdStudentFunction() : updateAttendance(String(value_key_finger), 1, http3);
      value_key_finger = 0;
      delay(1000);
    }
    // Delay giữa các lần lặp của nhiệm vụ
    vTaskDelay(1000 / portTICK_PERIOD_MS);
  }
}

//in ra id của thẻ
void taskRFID125kHzFunction(void *pvParameters) {
  for (;;) {
    // Kiểm tra xem có dữ liệu từ module RFID 125kHz không
    if (HZ1050.available() > 0) {
      Serial.println(">>>>>>>>>check 125kHz");
      // Đọc và xử lý thông tin từ thẻ RFID 125kHz
      controlLed();
      value_key_125kHz = process_RFID_125kHz();
      Serial.print("value 125KHz: ");
      Serial.println(value_key_125kHz);
      delay(1000);
    }
    // Delay giữa các lần lặp của nhiệm vụ
    vTaskDelay(1000 / portTICK_PERIOD_MS);
  }
}

void taskRFID13MHzFunction(void *pvParameters) {
  for (;;) {
    // Khai báo biến để lưu trữ UID của thẻ RFID 13.56MHz
    uint8_t uid[] = { 0, 0, 0, 0, 0, 0, 0 };
    uint8_t uidLength;

    // Kiểm tra xem có thẻ RFID 13.56MHz nằm trong phạm vi đọc hay không
    if (nfc.readPassiveTargetID(PN532_MIFARE_ISO14443A, uid, &uidLength)) {
      Serial.println(">>>>>>>>>>check 13.56Mhz");
      controlLed();
      value_key_13MHz = process_RFID_13MHz(uid, uidLength);
      Serial.print("value 13.56MHz: ");
      Serial.println(value_key_13MHz);
      delay(1000);
    }

    // Delay giữa các lần lặp của nhiệm vụ
    vTaskDelay(1000 / portTICK_PERIOD_MS);
  }
}

//gọi hàm vân tay
void taskFingerprintFunction(void *pvParameters) {
  for (;;) {
    uint8_t finger = getFingerprintID();
    delay(200);
  }
}

//xử lí vân tay
uint8_t getFingerprintID() {
  // Bước 1: Lấy hình ảnh từ cảm biến vân tay
  uint8_t p = finger.getImage();  //uint8_t: một kiểu dữ liệu nguyên không dấu (unsigned integer) và có độ rộng cố định là 8 bit.
  switch (p) {
    case FINGERPRINT_OK:              //#define FINGERPRINT_OK 0x00, Command execution is complete
      Serial.println("Image taken");  // In ra nếu hình ảnh được lấy thành công
      break;
    case FINGERPRINT_NOFINGER:               //#define FINGERPRINT_NOFINGER 0x02         //!< No finger on the sensor
      Serial.println("No finger detected");  // In ra nếu không phát hiện ngón tay
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:        //#define FINGERPRINT_PACKETRECIEVEERR 0x01 //!< Error when receiving data package
      Serial.println("Communication error");  // In ra nếu có lỗi trong quá trình giao tiếp
      return p;
    case FINGERPRINT_IMAGEFAIL:         //#define FINGERPRINT_IMAGEFAIL 0x03        //!< Failed to enroll the finger
      Serial.println("Imaging error");  // In ra nếu có lỗi trong quá trình tạo hình ảnh
      return p;
    default:
      Serial.println("Unknown error");  // In ra nếu có lỗi không xác định
      return p;
  }

  // Bước 2: Chuyển đổi hình ảnh thành mẫu vân tay
  p = finger.image2Tz();
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image converted");  // In ra nếu hình ảnh được chuyển đổi thành công
      break;
    case FINGERPRINT_IMAGEMESS:           //#define FINGERPRINT_IMAGEMESS 0x06                                                 \
       //!< Failed to generate character file due to overly disorderly
                                          //!< fingerprint image
      Serial.println("Image too messy");  // In ra nếu hình ảnh quá mơ hồ
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");  // In ra nếu có lỗi trong quá trình giao tiếp
      return p;
    case FINGERPRINT_FEATUREFAIL:
      //#define FINGERPRINT_FEATUREFAIL 0x07                                               \
      //!< Failed to generate character file due to the lack of character point
      //!< or small fingerprint image
      Serial.println("Could not find fingerprint features");  // In ra nếu không tìm thấy đặc trưng của vân tay
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      //#define FINGERPRINT_INVALIDIMAGE  0x15                                             \
      //!< Failed to generate image because of lack of valid primary image
      Serial.println("Could not find fingerprint features");  // In ra nếu không tìm thấy đặc trưng của vân tay (ảnh không hợp lệ)
      return p;
    default:
      Serial.println("Unknown error");
      return p;
  }

  // Bước 3: Tìm kiếm vân tay trong cơ sở dữ liệu
  p = finger.fingerSearch();
  if (p == FINGERPRINT_OK) {
    Serial.println("Found a print match!");  // In ra nếu tìm thấy khớp vân tay trong cơ sở dữ liệu
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    Serial.println("Communication error");  // In ra nếu có lỗi trong quá trình giao tiếp
    return p;
  } else if (p == FINGERPRINT_NOTFOUND) {
    Serial.println("Did not find a match");  // In ra nếu không tìm thấy khớp vân tay trong cơ sở dữ liệu
    return p;
  } else {
    Serial.println("Unknown error");  // In ra nếu có lỗi không xác định
    return p;
  }
  // Tìm thấy khớp vân tay!
  Serial.print("Found ID #");
  Serial.print(finger.fingerID);
  value_key_finger = finger.fingerID;
  return finger.fingerID;  // Trả về ID của vân tay tìm thấy
}

//control led
void controlLed() {
  digitalWrite(LED_PIN, HIGH);
  delay(1000);
  digitalWrite(LED_PIN, LOW);  // Tắt đèn LED
}

// set up Wifi
void setupWifi() {
  // Đọc thông tin SSID từ bộ nhớ flash
  preferences.begin("wifi-credentials", false);
  String savedSSID = preferences.getString("ssid", "");

  // Nếu có thông tin SSID đã lưu, thử kết nối với nó
  if (savedSSID.length() > 0) {
    Serial.println("Trying to connect using saved WiFi credentials...");

    // Đọc thông tin mật khẩu từ bộ nhớ flash
    String savedPassword = preferences.getString("password", "");

    // Nếu có thông tin mật khẩu đã lưu, thêm nó vào quy trình kết nối
    if (savedPassword.length() > 0) {
      WiFi.begin(savedSSID.c_str(), savedPassword.c_str());
    } else {
      WiFi.begin(savedSSID.c_str());
    }

    // Đợi kết nối
    int attempts = 0;
    while (WiFi.status() != WL_CONNECTED && attempts < 20) {
      delay(500);
      Serial.print(".");
      attempts++;
    }

    // Kiểm tra xem kết nối đã thành công hay không
    if (WiFi.status() == WL_CONNECTED) {
      Serial.println("Connected to WiFi using saved credentials");
      Serial.print("IP Address: ");
      Serial.println(WiFi.localIP());
      preferences.end();
      return;
    }
  }

  // Nếu không có hoặc kết nối thất bại, tạo AP để cấu hình
  Serial.println("Starting WiFi configuration portal.");
  WiFiManager wifiManager;
  if (!wifiManager.autoConnect("AutoConnectAP")) {
    Serial.println("Failed to connect and hit timeout");
    // Đợi 10 giây để cho bạn nhấn reset
    delay(10000);
    // Đặt lại để thử lại, hãy chắc chắn là bạn đã xóa cài đặt cứng trước đó
    ESP.restart();
    delay(5000);
  }

  // Lưu SSID và mật khẩu vào bộ nhớ flash nếu kết nối thành công
  preferences.putString("ssid", WiFi.SSID());
  preferences.putString("password", WiFi.psk());
  preferences.end();

  // In ra thông tin kết nối WiFi
  Serial.println("Connected to WiFi");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());
}

/**
hàm gửi ID của thẻ RFID hoặc ID của vân tay tương ứng với mỗi học sinh
*/
void updateAttendance(String id, int key, HTTPClient &http) {
  String url = FIREBASE_FUNCTION_URL;
  url.concat("updateAttendance");

  sslClient.setCACert(root_ca);  // Sử dụng chứng chỉ SSL
  http.begin(sslClient, url);
  http.addHeader("Content-Type", "application/json");

  // Tạo dữ liệu JSON để gửi
  String jsonData = "{ \"id\":" + id + ", \"key\":" + String(key) + "}";

  int httpResponseCode = http.POST(jsonData);

  // Xử lý kết quả
  if (httpResponseCode > 0) {
    String payload = http.getString();
    Serial.println("Server response: " + payload);
    // to do
  } else {
    Serial.println("Error on HTTP request");
    // to do
  }

  http.end();

  delay(5000);
}

void registerIdStudentFunction() {
  // to do
  Serial.println(">>>>>>>>>>>>>>>Register check");
}