const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.getStudentOnBus = functions.https.onRequest(async (req, res) => {
  try {
    // Lấy dữ liệu học sinh từ Realtime Database
    const snapshot = await admin.database().ref("attendancestudent")
        .orderByChild("is_on_bus").equalTo(true).once("value");
    const studentsOnBus = [];

    snapshot.forEach((childSnapshot) => {
      const student = childSnapshot.val();
      studentsOnBus.push(student);
    });

    const studentsArray =
      Object.keys(studentsOnBus).map((studentId) => ({
        student_id: studentsOnBus[studentId].student_id,
        bus_id: studentsOnBus[studentId].bus_id,
        is_on_bus: studentsOnBus[studentId].is_on_bus,
        start_bus: studentsOnBus[studentId].start_bus,
      }));

    // Trả về dữ liệu dưới dạng JSON với trường "students"
    return res.status(200).json(studentsArray);
  } catch (error) {
    console.error("Error:", error);
    return res.status(500).json({error: "Internal Server Error"});
  }
});

exports.getStudentById = functions.https.onRequest(async (req, res) => {
  try {
    const studentId = req.body.studentId;

    // Lấy dữ liệu học sinh từ Realtime Database
    const studentSnapshot = await admin.database().ref("students")
        .orderByChild("student_id").equalTo(studentId).once("value");
    let studentData = null;
    let teacherName = "";
    let parentName = "";

    studentSnapshot.forEach((childSnapshot) => {
      studentData = childSnapshot.val();
      // Nếu bạn muốn ngừng lặp sau khi tìm thấy học sinh
      return true;
    });

    const teacherSnapshot = await admin.database().ref("teachers")
        .orderByChild("teacher_id")
        .equalTo(studentData.teacher_id).once("value");

    teacherSnapshot.forEach((childSnapshot) => {
      teacherName = childSnapshot.val().teacher_name;
      return true;
    });

    const parentSnapshot = await admin.database().ref("parents")
        .orderByChild("parent_id")
        .equalTo(studentData.parent_id).once("value");

    parentSnapshot.forEach((childSnapshot) => {
      parentName = childSnapshot.val().parent_name;
      return true;
    });

    const formatData = {
      student_id: studentData.student_id,
      student_name: studentData.student_name,
      bus_id: studentData.bus_id,
      class_name: studentData.class_name,
      parent_name: parentName,
      teacher_name: teacherName,
    };
    return res.status(200).json(formatData);
  } catch (error) {
    console.error("Error:", error);
    return res.status(500).json({error: "Internal Server Error"});
  }
});

/**
 *  Get the current date and time in 'Asia/Ho_Chi_Minh' timezone.
 * @return {string} The formatted date and time string.
 */
function getCurrentDateTime() {
  const date = new Date();
  const options = {
    timeZone: "Asia/Ho_Chi_Minh",
    hour12: false,
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
  };

  const formatter = new Intl.DateTimeFormat("en-US", options);
  const dateTimeString = formatter.format(date);
  return dateTimeString;
}

exports.updateAttendance = functions.https.onRequest(async (req, res) => {
  try {
    const rfidId = req.body.rfidId;

    // Kiểm tra xem RFID ID có trong danh sách rfiddata không
    const rfidSnapshot = await admin.database().ref("rfiddata")
        .orderByChild("rfid_id").equalTo(rfidId).once("value");

    if (!rfidSnapshot.exists()) {
      return res.status(404).json({error: "RFID ID not found."});
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
                start_bus: getCurrentDateTime(),
              });
            } else {
              childSnapshot.ref.update({
                is_on_bus: false,
                end_bus: getCurrentDateTime(),
              });
            }

            console.log("Attendance updated successfully.");
            return res.status(200).json({success: true});
          });
        })
        .catch((error) => {
          console.error("Error:", error);
          return res.status(500).json({error: "Internal Server Error"});
        });
  } catch (error) {
    console.error("Error:", error);
    return res.status(500).json({error: "Internal Server Error"});
  }
});
