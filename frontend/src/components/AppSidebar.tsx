import {
	Award,
	BadgeDollarSign,
	FolderDot,
	SquareTerminal,
} from "lucide-react";
import type * as React from "react";
import ico from "@/assets/2n-logo.ico";

import { NavMain } from "@/components/NavMain";
import { NavUser } from "@/components/NavUser";
import {
	Sidebar,
	SidebarContent,
	SidebarFooter,
	SidebarHeader,
	SidebarMenu,
	SidebarMenuButton,
	SidebarMenuItem,
	SidebarRail,
} from "@/components/ui/sidebar";

// This is sample data.
const data = {
	user: {
		name: "John Doe",
		email: "john.doe.it@gmail.com",
		avatar: "/avatars/shadcn.jpg",
	},
	navMain: [
		{
			title: "Users",
			url: "#",
			icon: SquareTerminal,
			isActive: true,
			items: [
				{
					title: "List",
					url: "/",
				},
			],
		},
		// NOTE: comment below is an anchor for code generators that allows to append code here - do not remove it, do not put extra code below it.
		// GENERATOR-ANCHOR
	],
};

export function AppSidebar({ ...props }: React.ComponentProps<typeof Sidebar>) {
	return (
		<Sidebar collapsible="icon" {...props}>
			<SidebarHeader>
				<SidebarMenu>
					<SidebarMenuItem>
						<SidebarMenuButton
							size="lg"
							className="data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground"
						>
							<div className="text-sidebar-primary-foreground flex aspect-square size-8 items-center justify-center rounded-lg">
								<img src={ico} alt="icon" className="h-5 w-5" />
							</div>
							<div className="grid flex-1 text-left text-sm leading-tight">
								<span className="truncate font-medium">
									2n.it Resources Manager
								</span>
							</div>
						</SidebarMenuButton>
					</SidebarMenuItem>
				</SidebarMenu>
			</SidebarHeader>
			<SidebarContent>
				<NavMain items={data.navMain} />
			</SidebarContent>
			<SidebarFooter>
				<NavUser user={data.user} />
			</SidebarFooter>
			<SidebarRail />
		</Sidebar>
	);
}
