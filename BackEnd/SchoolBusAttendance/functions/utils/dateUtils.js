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

module.exports = {
  getCurrentDateInVietnam,
  getCurrentDateTime,
};
