import consumer from "channels/consumer"

document.addEventListener("DOMContentLoaded", () => {
  const contributionTotalElement = document.getElementById("contribution_total");

  if (contributionTotalElement) {
    const contributionTotalChannel = consumer.subscriptions.create("ContributionTotalChannel", {
      received(data) {
        contributionTotalElement.innerHTML = data["contribution_total"];
      }
    });

    // Add logic to unsubscribe when leaving the page
    document.addEventListener("turbolinks:before-visit", () => {
      contributionTotalChannel.unsubscribe();
    });
  }
});

