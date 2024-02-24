const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.addTokenDevice = functions.https.onRequest(async (req, res) => {
  try {
    const {parentId, tokenDevice} = req.body;

    if (!parentId || !tokenDevice) {
      return res.status(400).json({
        success: false,
        message: "Missing parentId or tokenDevice param",
      });
    }

    // Kiểm tra xem parentId có tồn tại trong cơ sở dữ liệu không
    const userRef = admin.database().ref(`/users/parents/${parentId}`);
    const userSnapshot = await userRef.once("value");
    const userData = userSnapshot.val();

    if (!userData) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    // Sử dụng hàm set để thêm hoặc cập nhật dữ liệu
    await userRef.set({...userData, token_device: tokenDevice});

    return res.status(200).json({
      success: true,
      message: "Token device added successfully",
    });
  } catch (error) {
    console.error("Error:", error);
    return res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

exports.getGPSByParentId = functions.https.
    onRequest(async (req, response) => {
      try {
        const parentId = req.body.parentId;

        if (!parentId) {
          response.status(400)
              .json({
                "success": false,
                "message": "Parameters 'parentId' are required.",
              });
          return;
        }

        // Tìm nút con student có trường parentId
        const studentSnapshot = await admin.database()
            .ref("students")
            .orderByChild("parent_id")
            .equalTo(parentId)
            .once("value");

        if (!studentSnapshot.exists()) {
          response.status(404)
              .json({
                "success": false,
                "message": "Students not found for the specified parentId.",
              });
          return;
        }

        console.log("student data: " + studentSnapshot.val());

        // Lấy giá trị của trường bus_id từ nút con student
        const busIds = Object.values(studentSnapshot.val())
            .map((student) => student.bus_id).filter(Boolean);

        if (busIds.length === 0) {
          response.status(404)
              .json({
                "success": false,
                "message": "BusId not found for the specified parentId.",
              });
          return;
        }

        const busId = busIds[0];
        console.log("bus ID: " + busId);
        if (!busId) {
          response.status(404)
              .json({
                "success": false,
                "message": "BusId not found for the specified parentId.",
              });
          return;
        }

        // Sử dụng busId để lấy thông tin GPS từ nút buses/location_live
        const locationRef = admin.database()
            .ref(`buses/${busId}/location_live`);

        const snapshot = await locationRef.once("value");
        const locationData = snapshot.val();

        if (!locationData) {
          response.status(404).json({
            "success": false,
            "message": "Location data not found for the specified busId.",
          });
          return;
        }

        response.status(200).json({
          "latitude": locationData.latitude,
          "longitude": locationData.longitude,
        });
      } catch (error) {
        console.error("Error:", error);
        response.status(500).json({
          "success": false,
          "message": "Internal server error",
        });
      }
    });

exports.getStudentIdsByParent = functions.https.onRequest(async (req, res) => {
  try {
    const {parentId} = req.body;

    const studentsRef = admin.database().ref("students");

    // Sử dụng orderByChild và equalTo để tìm học sinh với student_id cụ thể
    const studentSnapshot = await studentsRef.orderByChild("parent_id")
        .equalTo(parentId).once("value");

    // Kiểm tra xem có bản ghi nào khớp không
    if (studentSnapshot.exists()) {
      // Lấy giá trị từ snapshot
      const studentInfo = Object.values(studentSnapshot.val())[0];

      // Trả về tên học sinh nếu có, ngược lại trả về null
      const studentId = studentInfo ? studentInfo.student_id : null;
      return res.status(200).json({student_id: studentId});
    } else {
      // Trường hợp không tìm thấy học sinh
      return res.status(400)
          .json({success: false, message: "Not Found Parent ID"});
    }
  } catch (error) {
    console.error("Error:", error);
    return res.status(500)
        .json({success: false, message: "Internal server error"});
  }
});
