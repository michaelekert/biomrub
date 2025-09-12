import {
	AlertDialogAction,
	AlertDialogCancel,
	AlertDialogDescription,
	AlertDialogFooter,
	AlertDialogHeader,
	AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { useAlert } from "@/providers/AlertProvider";

function AlertModal({
	onConfirm,
	title = "Are you absolutely sure?",
	description = "This action cannot be undone. Deleting this project will permanently remove the project itself along with all associated project work valuations",
}) {
	const { hideAlert } = useAlert();

	return (
		<>
			<AlertDialogHeader>
				<AlertDialogTitle>{title}</AlertDialogTitle>
				<AlertDialogDescription>{description}</AlertDialogDescription>
			</AlertDialogHeader>
			<AlertDialogFooter>
				<AlertDialogCancel onClick={hideAlert}>Cancel</AlertDialogCancel>
				<AlertDialogAction
					onClick={() => {
						onConfirm();
						hideAlert();
					}}
				>
					Continue
				</AlertDialogAction>
			</AlertDialogFooter>
		</>
	);
}

export default AlertModal;
