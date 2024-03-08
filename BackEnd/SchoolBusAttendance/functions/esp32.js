const functions = require("firebase-functions");
const admin = require("firebase-admin");

const {getCurrentDateTime,
  getCurrentDateInVietnam} = require("./utils/dateUtils");

/**
 * Lưu thông tin điểm danh.
 * @param {string} studentId - id của học sinh.
 * @param {string} eventType - lên/xuống xe
 * @return {Promise} data khi được cập nhất thành công
 */
function saveToAttendanceReport(studentId, eventType) {
  const currentDate = getCurrentDateInVietnam();
  const currentTime = getCurrentDateTime();

  const reportRef = admin.database()
      .ref(`AttendanceReport/${studentId}`);

  return reportRef.transaction((currentData) => {
    currentData = currentData || [];

    // thêm dữ liệu vào nút curentDate, nếu ko có thì khởi tạo
    const currentDateEntry = currentData
        .find((entry) => entry.date === currentDate) ||
      {date: currentDate, history: []};

    currentDateEntry.history.push({
      event_type: eventType,
      timestamp: currentTime,
    });

    // Lọc currentData khác ngày currentDate
    currentData = currentData
        .filter((entry) => entry.date !== currentDate);

    // Add
    currentData.push(currentDateEntry);

    return currentData;
  });
}

exports.updateAttendance = functions.https.onRequest(async (req, res) => {
  try {
    const {id, key} = req.body;

    const node = {
      0: "rfid_id",
      1: "finger_id",
    };

    const newNode = node[key];

    // Kiểm tra xem RFID ID có trong danh sách rfiddata không
    const rfidSnapshot = await admin.database().ref("rfiddata")
        .orderByChild(newNode).equalTo(id).once("value");

    if (!rfidSnapshot.exists()) {
      return res.status(404).json({message: "ID not found."});
    }

    // Lấy thông tin từ danh sách rfiddata
    let studentId = null;

    // Lặp qua từng child của rfiddata
    rfidSnapshot.forEach((childSnapshot) => {
      studentId = childSnapshot.val().student_id;
      return true;
    });

    const attendanceRef = admin.database()
        .ref("attendancestudent")
        .orderByChild("student_id")
        .equalTo(studentId);

    const timestamp = getCurrentDateTime();

    // Lấy dữ liệu từ attendancestudent
    attendanceRef.once("value")
        .then((snapshot) => {
        // Lặp qua từng child của attendancestudent
          snapshot.forEach((childSnapshot) => {
            const studentData = childSnapshot.val();
            const isOnBus = studentData.is_on_bus;

            // Cập nhật dữ liệu trong attendancestudent
            if (isOnBus === false) {
              childSnapshot.ref.update({
                is_on_bus: true,
                start_bus: timestamp,
              });
              saveToAttendanceReport(studentId, "ON_BUS");
            } else {
              childSnapshot.ref.update({
                is_on_bus: false,
                end_bus: timestamp,
              });
              saveToAttendanceReport(studentId, "OFF_BUS");
            }
            console.log("Attendance updated successfully.");
            return res.status(200).json({success: true});
          });
        })
        .catch((error) => {
          console.error("Error:", error);
          return res.status(500).json({message: "Internal Server Error"});
        });
  } catch (error) {
    console.error("Error:", error);
    return res.status(500).json({message: "Internal Server Error"});
  }
});

exports.initFingerId = functions.https.onRequest(async (req, res) => {
  try {
    const rfidDataSnapshot = await admin
        .database()
        .ref("rfiddata")
        .once("value");

    const rfidData = rfidDataSnapshot.val();

    // Khởi tạo biến id và danh sách finger_id
    let id;
    const fingerIds = rfidData.map((item) => item.finger_id);

    do {
      id = Math.floor(Math.random() * 127) + 1;
    } while (fingerIds.includes(id));

    return res.status(200).json({id});
  } catch (error) {
    console.error("Error:", error);
    return res.status(500).json({message: "Internal Server Error"});
  }
});

exports.registerId =
  functions.https.onRequest(async (req, res) => {
    try {
      const {id, deviceId, key} = req.body;

      if (!id || !deviceId) {
        res.status(400)
            .json(
                {
                  success: false,
                  message: "Parameters" +
                " are required.",
                });
        return;
      }
      console.log("id, device, key " + id, deviceId, key);
      // lấy student id
      const studentIdSnapshot = await admin.database()
          .ref(`registerIdRequests/tag${deviceId}`)
          .orderByChild("student_id")
          .once("value");

      const isAcceptRef = admin.database()
          .ref(`registerIdRequests/tag${deviceId}/isAccept`);

      const studentId = studentIdSnapshot.val().student_id;
      const isAccept = studentIdSnapshot.val().isAccept;
      console.log("studentId: " + studentId);
      const rfidRef = admin.database()
          .ref("rfiddata")
          .orderByChild("student_id")
          .equalTo(studentId);

      console.log("<<<<<<<<<<<<<rf " + rfidRef);
      rfidRef.once("value")
          .then((snapshot) => {
            snapshot.forEach(async (childSnapshot) => {
              console.log("<<<<<<<<<<<<<refffff " + childSnapshot.ref);
              if (isAccept) {
                if (!key) {
                  childSnapshot.ref.update({
                    rfid_id: id,
                  });
                } else {
                  childSnapshot.ref.update({
                    finger_id: id,
                  });
                }
                await isAcceptRef.ref.set(false);
                return res.status(200).json(
                    {
                      success: true,
                      message: "Create Id for student succesfully!",
                    });
              } else {
                return res.status(400).json({
                  success: false,
                  message: "Not Found Request!!",
                });
              }
            });
          })
          .catch((error) => {
            console.error("Error:", error);
            return res.status(500).json({
              succes: false,
              message: "Internal Server Error",
            });
          });
    } catch (error) {
      console.error("Error:", error);
      return res.status(500).json(
          {
            success: false,
            message: "Internal Server Error",
          },
      );
    }
  });
