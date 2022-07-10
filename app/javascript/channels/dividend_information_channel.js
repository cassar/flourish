import consumer from "channels/consumer"

consumer.subscriptions.create("DividendInformationChannel", {
  received(data) {
    document.getElementById("dividend_amount").innerHTML = data["dividend_amount"]
    document.getElementById("dividend_date").innerHTML = data["dividend_date"]
  }
});
