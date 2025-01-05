import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="support"
export default class extends Controller {
	static targets = ["email"]

	connect() {
		const user = "support";
		const domain = "flourish.buzz";
		const email = `${user}@${domain}`;
		this.emailTarget.innerHTML = email;
	}
}

