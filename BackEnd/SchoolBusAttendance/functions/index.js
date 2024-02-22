const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

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

exports.getStudentById = functions.https.onRequest(async (req, res) => {
  try {
    const studentId = req.body.studentId;

    if (!studentId) {
      return res.status(400).json({
        success: false,
        message: "Missing studentId param!",
      });
    }

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

/**
 * Lấy ngày hiện tại ở múi giờ của Việt Nam ('Asia/Ho_Chi_Minh').
 * @return {string} Ngày hiện tại theo định dạng 'YYYY-MM-DD'.
 */
function getCurrentDateInVietnam() {
  const date = new Date();
  const options = {
    timeZone: "Asia/Ho_Chi_Minh",
    year: "numeric",
    month: "numeric",
    day: "numeric",
  };

  const formatter = new Intl.DateTimeFormat("en-US", options);
  const dateString = formatter.format(date);

  // Chia chuỗi thành mảng dựa trên dấu "/"
  const dateArray = dateString.split("/");

  // Đảo ngược thứ tự để có định dạng "1900/1/27"
  const reversedDateString = dateArray.reverse().join("-");

  return reversedDateString;
}
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

exports.registerAccount = functions.https.onRequest(async (req, res) => {
  try {
    const {username, password, roleId} = req.body;

    // Xác định đường dẫn dựa trên roleId
    const rolePaths = {
      1: "/parents/",
      2: "/teachers/",
      3: "/supervisors/",
      4: "/admin_school/",
    };

    // Sử dụng roleId để xác định đường dẫn
    const userPath = rolePaths[roleId];

    if (!userPath) {
      res.status(400).json(
          {
            success: false,
            message: "Invalid roleId",
          },
      );
      return;
    }

    // Kiểm tra xem tên người dùng đã được sử dụng chưa
    const matchingUserSnapshot = await admin
        .database()
        .ref("users" + userPath)
        .orderByChild("email")
        .equalTo(username)
        .once("value");

    const userData = matchingUserSnapshot.val();
    console.log("matching user: " + userData);
    if (!userData) {
      res.status(400).json({
        success: false,
        message: "No Data matching",
      });
      return;
    }

    // Kiểm tra xem tên người dùng đã được sử dụng chưa
    const existingUserSnapshot = await admin
        .database()
        .ref("users" + userPath)
        .orderByChild("user_name")
        .equalTo(username)
        .once("value");

    console.log("existing user: " + existingUserSnapshot.val());
    if (existingUserSnapshot.val()) {
      res.status(400).json({
        success: false,
        message: "Username already exists",
      });
      return;
    }

    // Tạo một đối tượng người dùng mới
    const newUser = {
      user_name: username,
      user_pass: password,
    };

    const userId = Object.keys(userData)[0];

    console.log("<<<<<<<<<user id: " + userId);

    // Thêm người dùng mới vào cơ sở dữ liệu
    await admin.database()
        .ref("users" + userPath + userId)
        .update(newUser);

    res.status(201).json({
      success: true,
      message: "User registered successfully",
    });
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

exports.login = functions.https.onRequest(async (req, res) => {
  try {
    const {username, password, roleId} = req.body;

    // Specify an array of paths based on the roleId
    const rolePaths = {
      1: "/parents/",
      2: "/teachers/",
      3: "/supervisors/",
      4: "/admin_school/",
    };

    // Use the roleId to determine the path
    const userPath = rolePaths[roleId];

    if (!userPath) {
      res.status(400).json({
        success: false,
        message: "Invalid roleId",
      });
      return;
    }

    // Search for the user in the specified path
    const userSnapshot = await admin
        .database()
        .ref("users" + userPath)
        .orderByChild("user_name")
        .equalTo(username)
        .once("value");

    const userData = userSnapshot.val();

    console.log("userData: " + userData);

    if (!userData || Object.keys(userData).length === 0) {
      res.status(401).json({
        success: false,
        message: "Incorrect user name",
      });
      return;
    }

    // Choose the first user found for simplicity;
    // you may need a more sophisticated logic
    const userId = Object.keys(userData)[0];
    const user = userData[userId];

    // Compare passwords, handle roles,
    // and send response accordingly
    if (password === user.user_pass) {
      res.status(200).json({
        user_id: user.user_id,
        user_name: username,
        role_id: user.role_id,
        full_name: user.full_name,
        phone: user.phone,
      });
    } else {
      res.status(401).json({
        success: false,
        message: "Incorrect password",
      });
    }
  } catch (error) {
    console.error("Error:", error);
    res.status(401).json({
      success: false,
      message: error,
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

    // Set both latitude and longitude
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

exports.getGPSByBusId = functions.https.onRequest(async (req, response) => {
  try {
    const busId = req.body.busId;

    if (!busId) {
      response.status(400)
          .json({
            success: false,
            message: "Parameters" +
            "'bus_id' are required.",
          },
          );
      return;
    }

    const locationRef = admin.database()
        .ref(`buses/${busId}/location_live`);
    // Lấy thông tin GPS từ nút buses/location_live
    const snapshot = await locationRef.once("value");
    const locationData = snapshot.val();

    if (!locationData) {
      response.status(404).json({
        success: false,
        message: "Location data not found for the specified busId.",
      });
      return;
    }

    response.status(200).json({
      latitude: locationData.latitude,
      longitude: locationData.longitude,
    });
  } catch (error) {
    console.error("Error:", error);
    response.status(500).json({
      success: false,
      message: "Internal server error",
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
        const parentId = await getParentIdByStudentId(updatedData.student_id);
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

exports.getGPSByParentId = functions.https.onRequest(async (req, response) => {
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
