import consumer from "channels/consumer"

consumer.subscriptions.create("MemberCountChannel", {
  received(data) {
    document.getElementById("member_count").innerHTML = data["member_count"]
  }
});
