const functions = require("firebase-functions");
const admin = require("firebase-admin");

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
