const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.getStudentById = functions.https.onRequest(async (req, res) => {
  try {
    const studentId = req.body.studentId;

    if (!studentId) {
      return res.status(400).json({
        success: false,
        message: "Missing studentId param!",
      });
    }

    const studentSnapshot = await admin.database().ref("students")
        .orderByChild("student_id").equalTo(studentId).once("value");
    let studentData = null;
    let teacherName = "";
    let parentName = "";

    studentSnapshot.forEach((childSnapshot) => {
      studentData = childSnapshot.val();
      return true;
    });

    const teacherSnapshot = await admin.database().ref("users/teachers")
        .orderByChild("user_id")
        .equalTo(studentData.teacher_id).once("value");

    teacherSnapshot.forEach((childSnapshot) => {
      teacherName = childSnapshot.val().full_name;
      return true;
    });

    const parentSnapshot = await admin.database().ref("users/parents")
        .orderByChild("user_id")
        .equalTo(studentData.parent_id).once("value");

    parentSnapshot.forEach((childSnapshot) => {
      parentName = childSnapshot.val().full_name;
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
    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
});
