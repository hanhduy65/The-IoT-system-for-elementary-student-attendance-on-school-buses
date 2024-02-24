const functions = require("firebase-functions");
const admin = require("firebase-admin");

const {getCurrentDateTime,
  getCurrentDateInVietnam} = require("./utils/dateUtils");

/**
 * Saves attendance information to the AttendanceReport.
 * @param {string} studentId - The unique identifier of the student.
 * @param {string} eventType - The type of attendance event
 * ("ON_BUS" or "OFF_BUS").
 * @return {Promise} A Promise that resolves when the data
 * is successfully updated.
 */
function saveToAttendanceReport(studentId, eventType) {
  // Get the current date
  const currentDate = getCurrentDateInVietnam();
  // Get the current time
  const currentTime = getCurrentDateTime();

  // Reference to the student's node in AttendanceReport
  const reportRef = admin.database()
      .ref(`AttendanceReport/${studentId}`);

  // Use the transaction method to ensure data consistency when
  return reportRef.transaction((currentData) => {
    // If the node doesn't exist, initialize it with an empty
    currentData = currentData || [];

    // Find or initialize the entry for the current date
    const currentDateEntry = currentData
        .find((entry) => entry.date === currentDate) ||
      {date: currentDate, history: []};

    currentDateEntry.history.push({
      event_type: eventType,
      timestamp: currentTime,
    });

    // Remove existing entry for the current date
    currentData = currentData
        .filter((entry) => entry.date !== currentDate);

    // Add the updated entry for the current date
    currentData.push(currentDateEntry);

    // Return the updated data
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

    // Truy vấn dữ liệu từ attendancestudent
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

exports.registerStudentId = functions.https.onRequest(async (req, res) => {
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

    // Truy vấn dữ liệu từ attendancestudent
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
