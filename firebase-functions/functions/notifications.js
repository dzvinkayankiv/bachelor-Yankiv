const {logger} = require("firebase-functions");
const {messaging, firestore} = require("./firebase");

/**
 * Надсилає FCM нотифікацію користувачу
 * @param {string} fcwToken - FCM токен користувача
 * @param {string} title - Заголовок нотифікації
 * @param {string} body - Текст нотифікації
 * @param {string} [uid] - ID користувача (опціонально)
 */
async function sendNotificationToUser(fcwToken, title, body, uid) {
  if (!fcwToken) {
    logger.log("FCM токен не вказаний.");
    return;
  }

  const message = {
    notification: {
      title: title,
      body: body,
    },
    token: fcwToken,
  };

  try {
    const response = await messaging.send(message);
    logger.info("FCM повідомлення надіслано:", response);
    if (!uid) {
      logger.warn("[sendNotificationToUser] Не передано uid!");
    }
  } catch (error) {
    logger.error("Помилка надсилання FCM:", error);
  }
}

/**
 * Надсилаєм нотифікацію всім користувачам з newsValue=true
 * @param {string} title - Заголовок нотифікації
 * @param {string} body - Текст нотифікації
 */
async function sendNotificationToAllUsers(title, body) {
  logger.log("[sendNotificationToAllUsers] Початок розсилки новин");
  let usersSnapshot;
  try {
    usersSnapshot = await firestore
        .collection("users")
        .where("newsValue", "==", true)
        .get();
  } catch (e) {
    logger.error("Помилка отримання користувачів:", e);
    return;
  }
  logger.log("Кількість користувачів з newsValue == true:", usersSnapshot.size);
  const tokens = [];
  usersSnapshot.forEach((userDoc) => {
    const userData = userDoc.data();
    if (
      userData &&
      typeof userData.fcwToken === "string" &&
      userData.fcwToken.trim() !== ""
    ) {
      tokens.push(userData.fcwToken);
    } else {
      logger.warn(
          `[User ${userDoc.id}] Пропущено: fcwToken відсутній або невалідний`,
      );
    }
  });
  if (tokens.length === 0) {
    logger.warn("Жодного токена для надсилання повідомлення.");
    return;
  }
  const message = {
    notification: {
      title,
      body,
    },
    tokens,
  };
  try {
    const response = await messaging.sendEachForMulticast(message);
    logger.log(
        `Надіслано повідомлень: ${response.successCount}, ` +
        `з помилками: ${response.failureCount}`,
    );
  } catch (error) {
    logger.error("Помилка надсилання FCM:", error);
  }
}

module.exports = {
  sendNotificationToUser,
  sendNotificationToAllUsers,
};
