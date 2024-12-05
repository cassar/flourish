import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cooperative"
export default class extends Controller {
	static targets = ["email"]

	connect() {
		const user = "cooperative";
		const domain = "flourish.buzz";
		const email = `${user}@${domain}`;
		this.emailTarget.innerHTML = email;

	}
}
