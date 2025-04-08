import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="memberships"
export default class extends Controller {
	static targets = ["email"]

	connect() {
		const user = "memberships";
		const domain = "flourish.buzz";
		const email = `${user}@${domain}`;
		this.emailTarget.innerHTML = email;
	}
}

