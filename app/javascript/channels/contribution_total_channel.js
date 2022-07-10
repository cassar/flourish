import consumer from "channels/consumer"

consumer.subscriptions.create("ContributionTotalChannel", {
  received(data) {
    document.getElementById("contribution_total").innerHTML = data["contribution_total"]
  }
});
