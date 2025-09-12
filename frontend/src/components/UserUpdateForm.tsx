"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useEffect, useState } from "react";
import { useForm } from "react-hook-form";
import { useNavigate } from "react-router-dom";
import Select from "react-select";
import { z } from "zod";
import UsersApi from "@/api/users-api";
import { Button } from "@/components/ui/button";
import {
	Form,
	FormControl,
	FormDescription,
	FormField,
	FormItem,
	FormLabel,
	FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import showToast from "@/lib/toasts";

const UserSchema = z.object({
	email: z.string().email({ message: "Invalid email address" }),
	fullName: z.string(),
});

export default function UserUpdateForm({ id }: { id: number }) {
	const navigate = useNavigate();

	const form = useForm<z.infer<typeof UserSchema>>({
		resolver: zodResolver(UserSchema),
		defaultValues: {
			email: "",
			fullName: "",
		},
	});

	useEffect(() => {
		UsersApi.show(id)
			.then((record) => {
				form.reset({
					email: record.email,
					fullName: record.fullName,
				});
			})
			.catch((error) => {
				showToast({
					variant: "error",
					description: `Failed to load user data: ${error.message}`,
				});
			});
	}, [id, form.reset]);

	async function onSubmit(values: z.infer<typeof UserSchema>) {
		UsersApi.update(id, values)
			.then(() => {
				navigate("/list_users");
				showToast({ variant: "success", description: "User updated" });
			})
			.catch((error) =>
				showToast({ variant: "error", description: error.message }),
			);
	}

	return (
		<Form {...form}>
			<form onSubmit={form.handleSubmit(onSubmit)} className="space-y-8">
				<FormField
					control={form.control}
					name="email"
					render={({ field }) => (
						<FormItem>
							<FormLabel>Email</FormLabel>
							<FormControl>
								<Input placeholder="Enter new email" {...field} />
							</FormControl>
							<FormDescription>Change e-mail</FormDescription>
							<FormMessage />
						</FormItem>
					)}
				/>

				<FormField
					control={form.control}
					name="fullName"
					render={({ field }) => (
						<FormItem>
							<FormLabel>Full name</FormLabel>
							<FormControl>
								<Input placeholder="Enter full name" {...field} />
							</FormControl>
							<FormDescription>Change full name</FormDescription>
							<FormMessage />
						</FormItem>
					)}
				/>

				<Button className="w-full mt-auto" type="submit">
					Submit
				</Button>
			</form>
		</Form>
	);
}
