import { createContext, useCallback, useContext, useState } from "react";

import { AlertDialog, AlertDialogContent } from "@/components/ui/alert-dialog";

const AlertContext = createContext();

export function useAlert() {
	const context = useContext(AlertContext);
	if (!context) throw new Error("useAlert must be used within AlertProvider");
	return context;
}

export function AlertProvider({ children }) {
	const [alertContent, setAlertContent] = useState(null);
	const [open, setOpen] = useState(false);

	const showAlert = useCallback((content) => {
		setAlertContent(content);
		setOpen(true);
	}, []);

	const hideAlert = useCallback(() => {
		setOpen(false);
		setTimeout(() => setAlertContent(null), 200); // allow exit animation
	}, []);

	return (
		<AlertContext.Provider value={{ showAlert, hideAlert }}>
			{children}
			<AlertDialog
				open={open}
				onOpenChange={(isOpen) => !isOpen && hideAlert()}
			>
				<AlertDialogContent>{alertContent}</AlertDialogContent>
			</AlertDialog>
		</AlertContext.Provider>
	);
}
