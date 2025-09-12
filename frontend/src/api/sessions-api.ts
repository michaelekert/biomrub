import camelcaseKeys from "camelcase-keys";
import { formatApiErrors } from "@/lib/utils";

const SessionsApi = {
	async getCsrfToken() {
		const response = await fetch("/sessions/csrf_token");
		const data = await response.json();
		return data.csrf_token;
	},

	async create(params) {
		const response = await fetch(`/sessions`, {
			method: "POST",
			credentials: "include",
			headers: {
				"Content-Type": "application/json",
				Accept: "application/json",
			},
			body: JSON.stringify(params),
		});
		const responseJson = await response.json();
		const responseData = camelcaseKeys(responseJson, { deep: true });

		if (!response.ok) {
			const errorMessages = formatApiErrors(responseData.errors);

			throw new Error(errorMessages);
		}
	},

	async destroy() {
		// NOTE: having csrf token here is not needed (csrf protection is disabled on BE for login & logout). But its here
		// just to showcase how to send it.
		// TODO: Remove it from here after first endpoint that really needs it has been implemented.
		const csrfToken = await SessionsApi.getCsrfToken();
		const payload = {
			_csrf_token: csrfToken,
		};
		const response = await fetch(`/sessions`, {
			method: "DELETE",
			credentials: "include",
			headers: {
				"Content-Type": "application/json",
				Accept: "application/json",
			},
			body: JSON.stringify(payload),
		});
		const responseJson = await response.json();
		const responseData = camelcaseKeys(responseJson, { deep: true });

		if (response.status === 401) {
			window.location.href = "/login";
			return;
		}

		if (!response.ok) {
			const errorMessages = formatApiErrors(responseData.errors);

			throw new Error(errorMessages);
		}

		return;
	},
};
export default SessionsApi;
