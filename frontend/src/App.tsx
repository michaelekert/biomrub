import { Route, Routes } from "react-router-dom";
// NOTE: comment below is an anchor for code generators that allows to append code here - do not remove it, do not put extra code below it.
// GENERATOR_IMPORT_ANCHOR
import { AlertProvider } from "@/providers/AlertProvider";
import LoginFormPage from "./pages/LoginFormPage.tsx";
import UsersListPage from "./pages/UsersListPage.tsx";
import UserUpdatePage from "./pages/UserUpdatePage.tsx";

export default function App() {
	return (
		<AlertProvider>
			<Routes>
				<Route path="/" element={<UsersListPage />} />
				<Route path="/login" element={<LoginFormPage />} />
				<Route path="/list_users" element={<UsersListPage />} />
				<Route path="/update_user/:id" element={<UserUpdatePage />} />
			</Routes>
		</AlertProvider>
	);
}
