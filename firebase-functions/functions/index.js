const {onDocumentUpdated, onDocumentCreated} = require(
    "firebase-functions/v2/firestore");
const {onSchedule} = require(
    "firebase-functions/v2/scheduler");
const {sendNotificationToUser, sendNotificationToAllUsers} = require(
    "./notifications");
const {admin} = require("./firebase");
const {logger} = require("firebase-functions");

const THRESHOLD = 5;

exports.checkRemains = onDocumentUpdated(
    "/users/{uid}/cosmetics/{cosmeticId}",
    async (event) => {
      console.log("Тригер checkRemains спрацював");
      const {uid, cosmeticId} = event.params;

      const userDoc = await admin
          .firestore()
          .collection("users")
          .doc(uid)
          .get();
      if (!userDoc.exists) {
        logger.error(`Документ користувача не знайдено для uid: ${uid}`);
        return null;
      }
      const userData = userDoc.data();

      if (!userData.endCountOfProductValue) {
        logger.log(`У користувача ${uid} не увімкнено endCountOfProductValue`);
        return null;
      }

      const cosmeticDoc = await userDoc.ref
          .collection("cosmetics")
          .doc(cosmeticId)
          .get();
      if (!cosmeticDoc.exists) {
        logger.error(`Документ косметики не знайдено для id: ${cosmeticId}`);
        return null;
      }
      const cosmeticData = cosmeticDoc.data();

      if (!event.data.before.data() || !event.data.after.data()) {
        logger.error("Відсутні дані події");
        return null;
      }

      const newValue = event.data.after.data().remains;
      const oldValue = event.data.before.data().remains;

      logger.log("Старий залишок:", oldValue, "Новий залишок:", newValue);

      if (
        newValue <= THRESHOLD &&
      oldValue > THRESHOLD &&
      newValue >= 0
      ) {
        logger.log("Досягнуто порогового залишку!", {
          uid,
          cosmeticId,
          newValue,
        });

        if (!userData.fcwToken) {
          logger.error(`Відсутній FCM токен для користувача ${uid}`);
          return null;
        }

        console.log("FCM-повідомлення успішно надіслано");
        const notificationTitle = "У вас закінчується косметика!";
        const notificationBody = cosmeticData ? cosmeticData.name : "";
        await sendNotificationToUser(userData.fcwToken,
            notificationTitle,
            notificationBody,
            uid,
        );
      }

      return null;
    },
);

exports.checkEndDate = onSchedule(
    {
      schedule: "every day 00:00",
      timeZone: "Europe/Kiev",
    },
    async () => {
      const now = new Date();
      const usersSnapshot = await admin.firestore().collection("users").get();

      for (const userDoc of usersSnapshot.docs) {
        const userData = userDoc.data();
        if (!userData || !userData.endDateOfProductValue) continue;

        const cosmeticsSnapshot = await userDoc.ref.collection("cosmetics")
            .get();

        for (const cosmeticDoc of cosmeticsSnapshot.docs) {
          const data = cosmeticDoc.data();

          if (!data.expirationDate) {
            console.warn(
                `У косметики ${cosmeticDoc.id} відсутня дата`);
            continue;
          }

          let expirationDate;
          if (typeof data.expirationDate.toDate === "function") {
            expirationDate = data.expirationDate.toDate();
          } else {
            expirationDate = new Date(data.expirationDate);
          }

          if (!(expirationDate instanceof Date) ||
          isNaN(expirationDate.getTime())) {
            console.error("expirationDate — некоректна дата", {
              expirationDate,
              raw: data.expirationDate,
            });
            continue;
          }

          const diffInMonths =
          (expirationDate.getFullYear() - now.getFullYear()) * 12 +
          (expirationDate.getMonth() - now.getMonth());

          console.log(
              `Косметика: ${cosmeticDoc.id}, 
              різниця місяців: ${diffInMonths}`,
          );

          if (diffInMonths === 1) {
            if (!userData.fcwToken) {
              console.warn(
                  `У користувача ${userDoc.id} відсутній FCM токен`,
              );
              continue;
            }

            console.log(
                `Косметика ${cosmeticDoc.id} — 
                закінчується через 1 місяць`,
            );

            await sendNotificationToUser(
                userData.fcwToken,
                "У вас закінчується термін дії косметики!",
                data.name || "",
                userDoc.id,
            );
          }
        }
      }

      return null;
    },
);

exports.checkNews = onDocumentCreated(
    "/news/{colId}/news/{newsId}",
    async (event) => {
      const newsData = event.data.data();
      const newsId = event.params.newsId;

      logger.log(`Створено нову новину! ID: ${newsId}`, newsData);

      await sendNotificationToAllUsers(
          "Зʼявилася нова новина!",
          newsData.title || "Без назви",
      );

      return null;
    },
);
