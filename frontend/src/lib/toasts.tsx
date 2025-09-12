import { toast } from "sonner";

type ToastVariant = "default" | "success" | "error" | "warning" | "info";

const defaultTitles: Record<ToastVariant, string> = {
	default: "Notice",
	success: "Success",
	error: "Error",
	warning: "Warning",
	info: "Info",
};

export default function showToast({
	title,
	description,
	variant = "default",
}: {
	title?: string;
	description?: string;
	variant?: ToastVariant;
}) {
	const id = toast(title ?? defaultTitles[variant], {
		description,
		type: variant,
		action: {
			label: "Close",
			onClick: () => toast.dismiss(id),
		},
	});

	return id;
}
