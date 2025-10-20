import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// Initialize Firebase Admin
admin.initializeApp();

/**
 * Sends a push notification when new content is created
 * @param snapshot - The Firestore document snapshot
 * @param contentType - The type of content (for logging and data payload)
 * @returns Promise<void>
 */
async function sendContentNotification(
  snapshot: functions.firestore.QueryDocumentSnapshot,
  contentType: string
): Promise<void> {
  const data = snapshot.data();

  if (!data) {
    console.log(`No data found in ${contentType} document ${snapshot.id}`);
    return;
  }

  // Only send notifications for published content
  if (data.status !== "published") {
    console.log(`Skipping notification for unpublished ${contentType}: ${snapshot.id}`);
    return;
  }

  // Extract content details
  const title = data.title ?? "New wisdom available";
  const summary = data.summary ?? data.subtitle ?? "Tap to explore the latest seasonal guidance.";
  const seasonName = data.season_name ?? data.season ?? "Current Season";

  console.log(`Sending notification for ${contentType}: ${title}`);

  try {
    // Send notification to the "new-content" topic
    const message: admin.messaging.Message = {
      topic: "new-content",
      notification: {
        title: `New ${contentType}: ${title}`,
        body: summary,
      },
      data: {
        contentId: snapshot.id,
        contentType: contentType,
        title: title,
        seasonName: seasonName,
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
      // Android-specific options
      android: {
        priority: "high",
        notification: {
          channelId: "gaiosophy_content_updates",
          priority: "high",
          defaultSound: true,
          defaultVibrateTimings: true,
        },
      },
      // iOS-specific options
      apns: {
        payload: {
          aps: {
            sound: "default",
            badge: 1,
            contentAvailable: true,
          },
        },
      },
    };

    const response = await admin.messaging().send(message);
    console.log(`Successfully sent notification for ${contentType} ${snapshot.id}:`, response);
  } catch (error) {
    console.error(`Error sending notification for ${contentType} ${snapshot.id}:`, error);
    throw error;
  }
}

/**
 * Triggered when a new document is created in the main 'content' collection
 */
export const notifyOnContentCreate = functions.firestore
  .document("content/{contentId}")
  .onCreate(async (snapshot, context) => {
    const data = snapshot.data();
    const typeValue = data?.type || "content";
    
    // Map type to readable name
    const typeMap: Record<string, string> = {
      plant: "Plant Ally",
      recipe: "Recipe",
      seasonal: "Seasonal Wisdom",
    };
    
    const contentType = typeMap[typeValue] || "Content";
    await sendContentNotification(snapshot, contentType);
  });

/**
 * Triggered when a new document is created in 'content_plant_allies' collection
 */
export const notifyOnPlantAllyCreate = functions.firestore
  .document("content_plant_allies/{contentId}")
  .onCreate(async (snapshot) => {
    await sendContentNotification(snapshot, "Plant Ally");
  });

/**
 * Triggered when a new document is created in 'content_recipes' collection
 */
export const notifyOnRecipeCreate = functions.firestore
  .document("content_recipes/{contentId}")
  .onCreate(async (snapshot) => {
    await sendContentNotification(snapshot, "Recipe");
  });

/**
 * Triggered when a new document is created in 'content_seasonal_wisdom' collection
 */
export const notifyOnSeasonalWisdomCreate = functions.firestore
  .document("content_seasonal_wisdom/{contentId}")
  .onCreate(async (snapshot) => {
    await sendContentNotification(snapshot, "Seasonal Wisdom");
  });

/**
 * Optional: Triggered when content is updated (can notify about content changes)
 * Uncomment if you want notifications on content updates as well
 */
/*
export const notifyOnContentUpdate = functions.firestore
  .document("content/{contentId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    
    // Only notify if status changed to published
    if (before.status !== "published" && after.status === "published") {
      const data = after;
      const typeValue = data?.type || "content";
      const typeMap: Record<string, string> = {
        plant: "Plant Ally",
        recipe: "Recipe",
        seasonal: "Seasonal Wisdom",
      };
      const contentType = typeMap[typeValue] || "Content";
      await sendContentNotification(change.after, contentType);
    }
  });
*/
