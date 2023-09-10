import consumer from "channels/consumer"

document.addEventListener("DOMContentLoaded", () => {
  const dividendAmountElement = document.getElementById("dividend_amount");
  const dividendDateElement = document.getElementById("dividend_date");

  if (dividendAmountElement && dividendDateElement) {
    const dividendInformationChannel = consumer.subscriptions.create("DividendInformationChannel", {
      received(data) {
        dividendAmountElement.innerHTML = data["dividend_amount"];
        dividendDateElement.innerHTML = data["dividend_date"];
      }
    });

    // Add logic to unsubscribe when leaving the page
    document.addEventListener("turbolinks:before-visit", () => {
      dividendInformationChannel.unsubscribe();
    });
  }
});

