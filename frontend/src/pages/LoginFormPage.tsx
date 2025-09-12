import { GalleryVerticalEnd } from "lucide-react";
import { useId, useState } from "react";
import { useNavigate } from "react-router-dom";
import SessionsApi from "@/api/sessions-api";
import logo2n from "@/assets/2nlogo-icon.svg";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { cn } from "@/lib/utils";

export default function LoginFormPage({
	className,
	...props
}: React.ComponentProps<"div">) {
	const [email, setEmail] = useState("");
	const [password, setPassword] = useState("");
	// TODO: implement alerts to handle errors
	const [error, setError] = useState<string | null>(null);
	const navigate = useNavigate();
	const passwordId = useId();
	const emailId = useId();

	const handleSubmit = async (e: React.FormEvent) => {
		e.preventDefault();
		setError(null);

		SessionsApi.create({ email, password })
			.then(() => navigate("/list_users"))
			.catch((error) => setError(error.message));
	};

	return (
		<div className="grid min-h-svh lg:grid-cols-2">
			<div className="flex flex-col gap-4 p-6 md:p-10">
				<div className="flex justify-center gap-2 md:justify-start">
					<a href="/login" className="flex items-center gap-2 font-medium">
						<div className="flex h-6 w-6 items-center justify-center rounded-md bg-primary text-primary-foreground">
							<GalleryVerticalEnd className="size-4" />
						</div>
						2n.it
					</a>
				</div>
				<div className="flex flex-1 items-center justify-center">
					<div className="w-full max-w-xs">
						<form
							onSubmit={handleSubmit}
							className={cn("flex flex-col gap-6", className)}
							{...props}
						>
							<div className="flex flex-col items-center gap-2 text-center">
								<h1 className="text-2xl font-bold">Login to your account</h1>
								<p className="text-balance text-sm text-muted-foreground">
									Enter your email below to login to your account
								</p>
							</div>

							{error && (
								<div className="text-sm text-red-500 text-center">{error}</div>
							)}

							<div className="grid gap-6">
								<div className="grid gap-2">
									<Label htmlFor={emailId}>Email</Label>
									<Input
										id={emailId}
										type="email"
										placeholder="m@example.com"
										required
										value={email}
										onChange={(e) => setEmail(e.target.value)}
									/>
								</div>
								<div className="grid gap-2">
									<div className="flex items-center">
										<Label htmlFor={passwordId}>Password</Label>
									</div>
									<Input
										id={passwordId}
										type="password"
										required
										value={password}
										onChange={(e) => setPassword(e.target.value)}
									/>
								</div>
								<Button type="submit" className="w-full">
									Login
								</Button>
							</div>
						</form>
					</div>
				</div>
			</div>
			<div className="relative hidden bg-muted lg:flex items-center justify-center">
				<img
					src={logo2n}
					alt="icon"
					className="w-1/2 h-auto object-contain dark:brightness-[0.2] dark:grayscale"
				/>
			</div>
		</div>
	);
}
