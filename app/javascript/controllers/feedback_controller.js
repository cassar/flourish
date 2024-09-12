import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="feedback"
export default class extends Controller {
	static targets = ["email"]

	connect() {
		const user = "feedback";
		const domain = "flourish.buzz";
		const email = `${user}@${domain}`;
		this.emailTarget.innerHTML = email;
	}
}
