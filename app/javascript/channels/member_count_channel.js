import consumer from "channels/consumer"

document.addEventListener("DOMContentLoaded", () => {
  const memberCountElement = document.getElementById("member_count");

  if (memberCountElement) {
    const memberCountChannel = consumer.subscriptions.create("MemberCountChannel", {
      received(data) {
        memberCountElement.innerHTML = data["member_count"];
      }
    });

    // Add logic to unsubscribe when leaving the page
    document.addEventListener("turbolinks:before-visit", () => {
      memberCountChannel.unsubscribe();
    });
  }
});

