const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.getAttendanceReportByStudentId =
functions.https.onRequest(async (req, res) => {
  try {
    const {studentId} = req.body;

    // Kiểm tra xem studentId có tồn tại không
    const studentSnapshot = await admin.database()
        .ref("AttendanceReport")
        .child(studentId)
        .once("value");

    if (!studentSnapshot.exists()) {
      return res.status(404).json(
          {
            success: false,
            message: "Student not found.",
          });
    }

    const studentData = studentSnapshot.val();
    studentData.reverse();
    return res.status(200).json(studentData);
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
