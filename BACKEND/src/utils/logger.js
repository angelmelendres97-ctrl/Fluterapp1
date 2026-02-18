const logInfo = (message, payload = {}) => {
  console.log(`[INFO] ${message}`, payload);
};

const logError = (message, payload = {}) => {
  console.error(`[ERROR] ${message}`, payload);
};

module.exports = { logInfo, logError };
