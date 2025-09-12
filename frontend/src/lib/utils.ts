import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
	return twMerge(clsx(inputs));
}

// TODO: refine error handling
export function formatApiErrors(errors, prefix = "") {
	if (!errors || Object.keys(errors).length === 0) {
		return "An unknown error occured";
	}

	if (Array.isArray(errors)) {
		return errors
			.flatMap((item) => formatApiErrors(item, prefix)) // NOTE: skip index
			.join(" | ");
	}

	if (typeof errors === "object" && errors !== null) {
		return Object.entries(errors)
			.flatMap(([key, value]) => {
				let nextPrefix: string | undefined;

				if (key === "record") {
					nextPrefix = prefix; // NOTE: omit "record"
				} else if (prefix) {
					nextPrefix = `${prefix}.${key}`;
				} else {
					nextPrefix = key;
				}

				return formatApiErrors(value, nextPrefix);
			})
			.join(" | ");
	}

	return `${prefix}: ${errors}`;
}
