const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {getCurrentDateInVietnam} = require("./utils/dateUtils");

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

exports.sendRegisterIdRequest =
  functions.https.onRequest(async (req, response) => {
    try {
      const {busId, studentId} = req.body;

      if (!busId || !studentId) {
        response.status(400)
            .json(
                {
                  success: false,
                  message: "Parameters" +
                "'bus_id', 'studentId' are required.",
                });
        return;
      }

      const locationRef = admin.database()
          .ref(`registerIdRequests/bus_id${busId}/student_id`);

      // Set both latitude and longitude
      await locationRef.set(studentId);

      response.status(200).json(
          {
            success: true,
            message: "Create request successfully.",
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
