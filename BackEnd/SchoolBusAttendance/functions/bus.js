const functions = require("firebase-functions");
const admin = require("firebase-admin");

/**
 * Lấy thông tin tên học sinh dựa trên student_id từ Realtime Database.
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

/**
 * Lấy thông tin rfid_id dựa trên student_id từ Realtime Database.
 *
 * @param {string} studentId - ID của học sinh cần lấy thông tin.
 * @return {Promise<string|null>} - Promise trả về rfid_id
 */
async function getRfidIdByStudentId(studentId) {
  try {
    // Lấy tham chiếu của nút "rfiddata"
    const rfidDataRef = admin.database().ref("rfiddata");

    // Sử dụng orderByChild và equalTo để tìm học sinh với student_id cụ thể
    const rfidDataSnapshot = await rfidDataRef.orderByChild("student_id")
        .equalTo(studentId).once("value");

    // Kiểm tra xem có bản ghi nào khớp không
    if (rfidDataSnapshot.exists()) {
      // Lấy giá trị từ snapshot
      const rfidDataInfo = Object.values(rfidDataSnapshot.val())[0];

      // Trả về rfid_id nếu có, ngược lại trả về null
      return rfidDataInfo ? rfidDataInfo.rfid_id : null;
    } else {
      // Trường hợp không tìm thấy thông tin rfid_id
      console.error("Không tìm thấy thông tin rfid_id với student_id:",
          studentId);
      return null;
    }
  } catch (error) {
    // Xử lý lỗi nếu có
    console.error("Lỗi khi lấy thông tin rfid_id:", error);
    throw error;
  }
}

/**
 * Lấy thông tin học sinh trên xe buýt với is_on_bus = true.
 *
 * @param {Object} req - Đối tượng yêu cầu (request) từ client.
 * @param {Object} res - Đối tượng phản hồi (response) đối với client.
 * @return {Promise<void>} - Promise không trả về giá trị.
 */
exports.getStudentOnBus = functions.https.onRequest(async (req, res) => {
  try {
    const busId = req.body.busId;
    console.log("busId:", busId);

    // Kiểm tra xem busId có được truyền vào không
    if (!busId) {
      return res.status(400).json({
        success: false,
        message: "Missing busId parameter",
      });
    }

    // Lấy dữ liệu học sinh từ Realtime Database
    const snapshot = await admin.database().ref("attendancestudent")
        .orderByChild("bus_id").equalTo(busId).once("value");

    if (!snapshot.val()) {
      return res.status(400).json({
        success: false,
        message: "Chưa có Học Sinh lên xe",
      });
    }
    console.log("Snapshot value:", snapshot.val());

    const studentsData = snapshot.val();

    const studentsOnBus = [];

    const promises = Object.values(studentsData).map(async (studentData) => {
      const studentInfo = {
        student_id: studentData.student_id,
        bus_id: studentData.bus_id,
        is_on_bus: studentData.is_on_bus,
        start_bus: studentData.start_bus,
        rfid_id: await getRfidIdByStudentId(studentData.student_id),
        student_name: await getStudentNameById(studentData.student_id),
      };
      studentsOnBus.push(studentInfo);
    });

    // Đợi tất cả các promise hoàn thành
    await Promise.all(promises);

    console.log("Dữ liệu trả về:", studentsOnBus);

    return res.status(200).json(studentsOnBus);
  } catch (error) {
    console.error("Lỗi:", error);
    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
});

exports.isRunning = functions.https.onRequest(async (req, res) => {
  try {
    const {busId, isRunning} = req.body;
    if (!busId || isRunning === undefined) {
      res.status(400).json({
        success: false,
        message: "Parameter are require!",
      },
      );
      return;
    }
    const runningRef = admin
        .database()
        .ref(`buses/${busId}/`);
    await runningRef.update({is_running: isRunning});

    res.status(200).json({
      success: true,
      message: "Data updated successfully.",
    },
    );
  } catch (error) {
    res.status(5000).json({
      success: false,
      message: "Internal server error",
    });
  }
});
