const functions = require("firebase-functions");
const admin = require("firebase-admin");

const {getCurrentDateTime} = require("./utils/dateUtils");

/**
 *
 * @param {string} studentId - ID của học sinh cần lấy thông tin.
 * @return {Promise<string|null>} - Promise trả về parentId
 */
async function getParentIdByStudentId(studentId) {
  const studentSnapshot = await admin.database()
      .ref("students")
      .orderByChild("student_id")
      .equalTo(studentId)
      .once("value");

  if (studentSnapshot.exists()) {
    const studentData = studentSnapshot.val();
    const firstKey = Object.keys(studentData)[0];
    const parentId = studentData[firstKey].parent_id;
    return parentId;
  } else {
    return null;
  }
}

exports.sendNotification = functions.database
    .ref("/attendancestudent/{pushId}")
    .onUpdate(async (change, context) => {
      const updatedData = change.after.val();
      const previousData = change.before.val();

      // Kiểm tra nếu trạng thái is_on_bus chuyển từ false sang true
      if (previousData.is_on_bus != updatedData.is_on_bus) {
        const parentId =
                await getParentIdByStudentId(updatedData.student_id);
        console.log("parent ID: " + parentId);
        let token = "";

        // Kiểm tra xem parentId có tồn tại không
        if (parentId !== null) {
          // Sử dụng parentId để truy cập token_device trong database
          const tokenSnapshot = await admin.database()
              .ref(`users/parents/${parentId}/token_device`).once("value");
          token = tokenSnapshot.val();

          // Tiếp tục xử lý với giá trị token
        } else {
          // Xử lý khi không tìm thấy parentId
          return;
        }

        console.log("token: " + token);
        // Tạo payload cho thông báo
        const payload = {
          notification: {
            title: "Thông báo",
            body: updatedData.is_on_bus ? "Học sinh đã lên xe: " +
                        getCurrentDateTime() :
                        "Học sinh đã xuống xe: " + getCurrentDateTime(),
            sound: "beep",
            channel_id: "HUNGRY",
            android_chanel_id: "HUNGRY",
            priority: "high",
          },
        };
        console.log("body: " + JSON.stringify(payload));
        // Gửi thông báo
        try {
          const res = await admin.messaging()
              .sendToDevice(token, payload);
          console.log("thành công: ", JSON.stringify(res));
        } catch (error) {
          console.log("Lỗi rồi: " + error);
        }
      }
    });
