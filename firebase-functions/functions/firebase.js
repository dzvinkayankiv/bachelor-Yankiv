const admin = require("firebase-admin");

if (!admin.apps.length) {
  admin.initializeApp();
}

const messaging = admin.messaging();
const firestore = admin.firestore();

module.exports = {
  admin,
  messaging,
  firestore,
};
