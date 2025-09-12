import type { ColumnDef } from "@tanstack/react-table";
import { ArrowUpDown, MoreHorizontal, Pencil } from "lucide-react";
import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import UsersApi from "@/api/users-api";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import {
	DropdownMenu,
	DropdownMenuContent,
	DropdownMenuItem,
	DropdownMenuLabel,
	DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
	HoverCard,
	HoverCardContent,
	HoverCardTrigger,
} from "@/components/ui/hover-card";

import DataTable from "./DataTable";

export type User = {
	id: string;
	email: string;
	fullName: string;
};

export default function UsersTable() {
	const navigate = useNavigate();
	const [data, setData] = useState<User[]>([]);

	useEffect(() => {
		UsersApi.index().then((responseData) => setData(responseData.records));
	}, []);

	const columns: ColumnDef<User>[] = [
		{
			accessorKey: "email",
			header: ({ column }) => (
				<Button
					variant="ghost"
					onClick={() => column.toggleSorting(column.getIsSorted() === "asc")}
				>
					Email
					<ArrowUpDown className="ml-2 h-4 w-4" />
				</Button>
			),
		},
		{
			accessorKey: "fullName",
			header: ({ column }) => (
				<Button
					variant="ghost"
					onClick={() => column.toggleSorting(column.getIsSorted() === "asc")}
				>
					Full name
					<ArrowUpDown className="ml-2 h-4 w-4" />
				</Button>
			),
			cell: ({ row }) => {
				const user = row.original;
				return (
					<HoverCard openDelay={300}>
						<HoverCardTrigger asChild>
							<span className="cursor-pointer">{user.fullName}</span>
						</HoverCardTrigger>
						<HoverCardContent className="w-80">
							<div className="flex flex-col gap-2">
								<div className="flex items-center gap-4">
									<Avatar>
										<AvatarFallback>
											{user.fullName
												.split(" ")
												.map((n) => n[0])
												.join("")
												.toUpperCase()}
										</AvatarFallback>
									</Avatar>
									<div>
										<p className="font-semibold">{user.fullName}</p>
										<p className="text-sm text-muted-foreground">
											{user.email}
										</p>
									</div>
								</div>
							</div>
						</HoverCardContent>
					</HoverCard>
				);
			},
		},
		{
			id: "actions",
			enableHiding: false,
			cell: ({ row }) => {
				const user = row.original;
				return (
					<div className="flex justify-end">
						<DropdownMenu>
							<DropdownMenuTrigger asChild>
								<Button variant="ghost">
									<span className="sr-only">Open menu</span>
									<MoreHorizontal />
								</Button>
							</DropdownMenuTrigger>
							<DropdownMenuContent align="end">
								<DropdownMenuLabel>Actions</DropdownMenuLabel>
								<DropdownMenuItem
									onClick={() => navigate(`/update_user/${user.id}`)}
								>
									<Pencil />
									Edit
								</DropdownMenuItem>
							</DropdownMenuContent>
						</DropdownMenu>
					</div>
				);
			},
		},
	];

	const COLUMN_LABELS: Record<string, string> = {
		email: "Email",
		fullName: "Full name",
	};

	return <DataTable columns={columns} data={data} labels={COLUMN_LABELS} />;
}
