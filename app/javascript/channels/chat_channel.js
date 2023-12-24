import consumer from "./consumer";
let notificationSound = new Audio("/assets/notification.mp3");

let isSoundEnabled = false;
let currentNotification = null;

function toggleSound() {
  isSoundEnabled = !isSoundEnabled;
  const button = document.getElementById("toggle-sound");
  if (button) {
    button.textContent = isSoundEnabled
      ? "Disable Sound Notifications"
      : "Enable Sound Notifications";
  }
}

document.addEventListener("turbo:load", () => {
  const toggleButton = document.getElementById("toggle-sound");
  if (toggleButton) {
    toggleButton.addEventListener("click", toggleSound);
  }

  findMessagesObject();
});

function findMessagesObject() {
  const messages = document.querySelectorAll("#messages");
  const chatName = document.querySelector(".chat");

  if (messages.length > 0) {
    createChatChannel(
      messages[0].dataset["chatId"],
      messages[0],
      chatName.textContent,
    );
  }
}

function createChatChannel(chatId, messages_holder, chatNameText) {
  const channelChat = consumer.subscriptions.create(
    { channel: "ChatChannel", chat: chatId },
    {
      connected() {
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        messages_holder.insertAdjacentHTML("beforeend", data["message"]);
        messages_holder.scrollTop = messages_holder.scrollHeight;

        playSound();

        displayNotification(chatNameText, data.message);
      },
    },
  );

  messages_holder.scrollTop = messages_holder.scrollHeight;

  const textarea = document.querySelector("#message_body");

  textarea.addEventListener("keypress", (event) => {
    if (event.keyCode != 13) return false;

    event.preventDefault();
    let message = event.target.value.replace("\n", "").trim();

    if (message == "") return false;

    channelChat.send({ message: message });
    event.target.value = "";
    OnInput(event);
  });

  textarea.setAttribute(
    "style",
    "height:" + textarea.scrollHeight + "px;overflow-y:hidden;",
  );
  textarea.addEventListener("input", OnInput, false);
}

function OnInput(event) {
  event.target.style.height = 0;
  event.target.style.height = event.target.scrollHeight + "px";
}

function playSound() {
  if (!isSoundEnabled) {
    return;
  }

  notificationSound
    .play()
    .catch((error) => console.error("Error playing sound:", error));
}

function displayNotification(chatName, messageText) {
  const notificationsContainer = document.getElementById(
    "notifications-container",
  );

  if (currentNotification) {
    currentNotification.remove();
  }

  const notification = document.createElement("div");
  notification.className = "chat-notification";
  notification.innerHTML = `<strong>${chatName}${messageText}</strong>`;

  notificationsContainer.appendChild(notification);

  currentNotification = notification;

  setTimeout(() => {
    if (currentNotification === notification) {
      currentNotification.remove();
      currentNotification = null;
    }
  }, 5000);
}
