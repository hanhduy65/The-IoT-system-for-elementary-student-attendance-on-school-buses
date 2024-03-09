const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {getCurrentDateInVietnam} = require("./utils/dateUtils");

/**
 * Lấy thông tin bus id học sinh dựa trên student_id.
 *
 * @param {string} studentId - ID của học sinh cần lấy thông tin.
 * @return {Promise<string|null>} - Promise trả về bus id học sinh
 */
async function getBusIdById(studentId) {
  try {
    // Lấy tham chiếu của nút "students"
    const studentsRef = admin.database().ref("students");

    // Sử dụng orderByChild và equalTo để tìm học sinh với student_id cụ thể
    const studentSnapshot = await studentsRef.orderByChild("student_id")
        .equalTo(studentId).once("value");

    // Kiểm tra xem có bản ghi nào khớp không
    if (studentSnapshot.exists()) {
      // Lấy giá trị từ snapshot
      const studentInfo = Object.values(studentSnapshot.val())[0];

      // Trả về tên học sinh nếu có, ngược lại trả về null
      return studentInfo ? studentInfo.bus_id : null;
    } else {
      // Trường hợp không tìm thấy học sinh
      console.error("Không tìm thấy thông tin học sinh với student_id:",
          studentId);
      return null;
    }
  } catch (error) {
    // Xử lý lỗi nếu có
    console.error("Lỗi khi lấy thông tin học sinh:", error);
    throw error;
  }
}

/**
 * Lấy thông tin tên học sinh dựa trên student_id.
 *
 * @param {string} studentId - ID của học sinh cần lấy thông tin.
 * @return {Promise<string|null>} - Promise trả về tên học sinh
 */
async function getStudentNameById(studentId) {
  try {
    // Lấy tham chiếu của nút "students"
    const studentsRef = admin.database().ref("students");

    // Sử dụng orderByChild và equalTo để tìm học sinh với student_id cụ thể
    const studentSnapshot = await studentsRef.orderByChild("student_id")
        .equalTo(studentId).once("value");

    // Kiểm tra xem có bản ghi nào khớp không
    if (studentSnapshot.exists()) {
      // Lấy giá trị từ snapshot
      const studentInfo = Object.values(studentSnapshot.val())[0];

      // Trả về tên học sinh nếu có, ngược lại trả về null
      return studentInfo ? studentInfo.student_name : null;
    } else {
      // Trường hợp không tìm thấy học sinh
      console.error("Không tìm thấy thông tin học sinh với student_id:",
          studentId);
      return null;
    }
  } catch (error) {
    // Xử lý lỗi nếu có
    console.error("Lỗi khi lấy thông tin học sinh:", error);
    throw error;
  }
}

exports.getStudentsNoFinger = functions.https.onRequest(async (req, res) => {
  try {
    const busId = req.query.busId;
    const studentSnapshot = await admin
        .database()
        .ref("rfiddata")
        .once("value");

    console.log("<<<<<<student: " + studentSnapshot.val());
    const studentData = Object.values(studentSnapshot.val());
    const studentNoFinger = studentData.filter((studentData) =>
      !studentData.finger_id);
    if (studentNoFinger.length == 0) {
      return res.status(404).json(
          {
            success: false,
            message: "No students without Finger were found!",
          },
      );
    }
    const studentsNoFingerList = [];

    const promises = Object.values(studentNoFinger)
        .map(async (studentNoFinger) => {
          const studentInfo = {
            student_id: studentNoFinger.student_id,
            student_name: await getStudentNameById(studentNoFinger.student_id),
          };
          if (await getBusIdById(studentNoFinger.student_id) == busId) {
            studentsNoFingerList.push(studentInfo);
          }
        });

    // Đợi tất cả các promise hoàn thành
    await Promise.all(promises);
    if (studentsNoFingerList.length > 0) {
      res.status(200).json(studentsNoFingerList);
    } else {
      res.status(404).json(
          {
            success: false,
            message: "No students without Finger were found in this bus!",
          },
      );
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

exports.getStudentsNoRFID = functions.https.onRequest(async (req, res) => {
  try {
    const busId = req.query.busId;
    const studentSnapshot = await admin
        .database()
        .ref("rfiddata")
        .once("value");

    console.log("<<<<<<student: " + studentSnapshot.val());
    const studentData = Object.values(studentSnapshot.val());
    const studentNoRFID = studentData.filter((studentData) =>
      !studentData.rfid_id);
    if (studentNoRFID.length == 0) {
      return res.status(404).json(
          {
            success: false,
            message: "No students without RFID were found!",
          },
      );
    }
    const studentsNoRFIDList = [];

    const promises = Object.values(studentNoRFID)
        .map(async (studentNoFinger) => {
          const studentInfo = {
            student_id: studentNoFinger.student_id,
            student_name: await getStudentNameById(studentNoFinger.student_id),
          };
          if (await getBusIdById(studentNoFinger.student_id) == busId) {
            studentsNoRFIDList.push(studentInfo);
          }
        });

    // Đợi tất cả các promise hoàn thành
    await Promise.all(promises);
    if (studentsNoRFIDList.length > 0) {
      res.status(200).json(studentsNoRFIDList);
    } else {
      res.status(404).json(
          {
            success: false,
            message: "No students without Finger were found in this bus!",
          },
      );
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

exports.getBusIdBySupervior = functions.https.onRequest(async (req, res) => {
  try {
    const supervisorId = req.body.supervisorId;
    const curentDate = getCurrentDateInVietnam();
    console.log("date: " + curentDate);
    if (!supervisorId) {
      return res.status(400).json(
          {
            success: false,
            message: "Missing supervisorId param",
          },
      );
    }
    const busSnapshot = await admin
        .database()
        .ref(`/dailySchedules/${curentDate}/${supervisorId}`)
        .once("value");

    const busData = busSnapshot.val();
    if (!busData) {
      return res.status(400).json({
        success: false,
        message: "There is no schedule today",
      });
    } else {
      return res.status(200).json(
          {
            bus_id: busData,
          },
      );
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

// Cloud Function để lưu thông tin GPS vào nút buses/location_live
exports.sendGPS = functions.https.onRequest(async (req, response) => {
  try {
    const {busId, latitude, longitude} = req.body;

    if (!busId || !latitude || !longitude) {
      response.status(400)
          .json(
              {
                success: false,
                message: "Parameters" +
              "'bus_id', 'latitude', and 'longitude' are required.",
              });
      return;
    }

    const locationRef = admin.database().ref(`buses/${busId}/location_live`);

    // lưu latitude, longitude
    await locationRef.set({
      latitude: latitude,
      longitude: longitude,
    });

    response.status(200).json(
        {
          success: true,
          message: "Location updated successfully.",
        },
    );
  } catch (error) {
    console.error("Error:", error);
    response.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

exports.registerId =
  functions.https.onRequest(async (req, res) => {
    try {
      const {studentId, deviceId} = req.body;

      if (!studentId || !deviceId) {
        res.status(400)
            .json(
                {
                  success: false,
                  message: "Parameters" +
                " are required.",
                });
        return;
      }
      console.log("studentId, device, key " + studentId, deviceId);
      // lấy id
      const studentIdSnapshot = await admin.database()
          .ref(`registerIdRequests/device${deviceId}`)
          .orderByChild("id")
          .once("value");

      const isAcceptRef = admin.database()
          .ref(`registerIdRequests/device${deviceId}/isAccept`);

      const id = studentIdSnapshot.val().id;
      const isAccept = studentIdSnapshot.val().isAccept;
      const isFinger = studentIdSnapshot.val().isFinger;

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
                if (!isFinger) {
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
