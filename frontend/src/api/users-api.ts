import camelcaseKeys from "camelcase-keys";
import snakecaseKeys from "snakecase-keys";
import { formatApiErrors } from "@/lib/utils";
import SessionsApi from "./sessions-api";

const UsersApi = {
	async index() {
		const response = await fetch(`/users`);
		const responseJson = await response.json();
		const responseData = camelcaseKeys(responseJson, { deep: true });

		if (response.status === 401) {
			console.warn("Unauthorized - redirecting to login");

			window.location.href = "/login";

			return;
		}

		if (!response.ok) {
			const errorMessages = formatApiErrors(responseData.errors);

			throw new Error(errorMessages);
		}

		return responseData;
	},
	async show(id: number) {
		const response = await fetch(`/users/${id}`, {
			method: "GET",
			headers: {
				"Content-Type": "application/json",
			},
		});

		const responseJson = await response.json();
		const responseData = camelcaseKeys(responseJson, { deep: true });

		if (!response.ok) {
			const errorMessages = formatApiErrors(responseData.errors);
			throw new Error(JSON.stringify(errorMessages));
		}

		return responseData.record;
	},
	async update(id: any, data: { email: any; fullName: any }) {
		const csrfToken = await SessionsApi.getCsrfToken();

		const payload = {
			_csrf_token: csrfToken,
			id,
			record: snakecaseKeys({ ...data }, { deep: true }),
		};
		const response = await fetch(`/users/${id}`, {
			method: "PATCH",
			headers: {
				"Content-Type": "application/json",
				Accept: "application/json",
			},
			body: JSON.stringify(payload),
		});

		if (!response.ok) {
			const errorData = await response.json();
			const emailError = errorData.errors.record.email;
			throw new Error(emailError || "Failed to update user");
		}
	},
};

export default UsersApi;
