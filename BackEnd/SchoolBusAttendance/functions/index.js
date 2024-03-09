const admin = require("firebase-admin");
// Import the functions
const {updateAttendance,
  sendRegisterStudentIdRequest,
  initFingerId: initFingerId} = require("./esp32");
const {getAttendanceReportByStudentId} = require("./attendance");
const {sendGPS,
  getBusIdBySupervior,
  getStudentsNoFinger,
  getStudentsNoRFID,
  registerId,
} = require("./supervisor");
const {registerAccount, login} = require("./account");
const {addTokenDevice,
  getStudentIdsByParent,
  getGPSByParentId} = require("./parent");
const {sendNotification} = require("./notification");
const {getStudentOnBus,
  isRunning} = require("./bus");
const {getStudentById} = require("./student");

admin.initializeApp();

// Export the functions
exports.updateAttendance = updateAttendance;
exports.registerAccount = registerAccount;
exports.login = login;
exports.getAttendanceReportByStudentId = getAttendanceReportByStudentId;
exports.getStudentById = getStudentById;
exports.getStudentOnBus = getStudentOnBus;
exports.isRunning = isRunning;
exports.addTokenDevice = addTokenDevice;
exports.getStudentIdsByParent = getStudentIdsByParent;
exports.getGPSByParentId = getGPSByParentId;
exports.sendNotification = sendNotification;
exports.sendGPS = sendGPS;
exports.getBusIdBySupervior = getBusIdBySupervior;
exports.registerId = registerId;
exports.getStudentsNoFinger = getStudentsNoFinger;
exports.getStudentsNoRFID = getStudentsNoRFID;
exports.sendRegisterStudentIdRequest = sendRegisterStudentIdRequest;
exports.initFingerId = initFingerId;
