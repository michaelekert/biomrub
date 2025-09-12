import { Check, X } from "lucide-react";
import type { ReactNode } from "react";
import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";

export type EditingCell<T extends { id: number } = { id: number }> = {
	id: number;
	columnId: keyof T;
} | null;

export function useEditable<T extends { id: number }>() {
	const [editingCell, setEditingCell] = useState<EditingCell<T>>(null);
	return { editingCell, setEditingCell };
}

type EditableCellProps<T extends { id: number }> = {
	row: T;
	columnId: keyof T;
	editingCell: EditingCell<T>;
	setEditingCell: (cell: EditingCell<T>) => void;
	handleSave: (id: number, columnId: keyof T, newValue: any) => void;
	type?: "text" | "select";
	options?: { value: any; label: string }[];
	displayValue?: ReactNode;
};

export function EditableCell<T extends { id: number }>({
	row,
	columnId,
	editingCell,
	setEditingCell,
	handleSave,
	type = "text",
	options = [],
	displayValue,
}: EditableCellProps<T>) {
	const isEditing =
		editingCell?.id === row.id && editingCell?.columnId === columnId;

	const rawValue = row[columnId];
	const [localValue, setLocalValue] = useState<any>(rawValue);

	useEffect(() => {
		setLocalValue(row[columnId]);
	}, [row, columnId]);

	const coerceFromSelect = (raw: string) => {
		const sample = options[0]?.value;
		if (typeof sample === "number") {
			const n = Number(raw);
			return Number.isNaN(n) ? raw : n;
		}
		return raw;
	};

	if (isEditing) {
		if (type === "select") {
			return (
				<div className="flex items-center space-x-2">
					<select
						value={
							localValue === undefined || localValue === null
								? ""
								: String(localValue)
						}
						onChange={(e) => setLocalValue(coerceFromSelect(e.target.value))}
						onKeyDown={(e) => {
							if (e.key === "Enter") handleSave(row.id, columnId, localValue);
							if (e.key === "Escape") setEditingCell(null);
						}}
						className="border rounded px-2 py-1 w-full"
					>
						{options.map((opt) => (
							<option key={String(opt.value)} value={String(opt.value)}>
								{opt.label}
							</option>
						))}
					</select>
					<Button
						size="sm"
						variant="ghost"
						onClick={() => handleSave(row.id, columnId, localValue)}
					>
						<Check />
					</Button>
					<Button
						size="sm"
						variant="ghost"
						onClick={() => setEditingCell(null)}
					>
						<X />
					</Button>
				</div>
			);
		}

		return (
			<div className="flex items-center space-x-2">
				<input
					value={localValue ?? ""}
					onChange={(e) => setLocalValue(e.target.value)}
					className="border rounded px-2 py-1 w-full"
					onKeyDown={(e) => {
						if (e.key === "Enter") handleSave(row.id, columnId, localValue);
						if (e.key === "Escape") setEditingCell(null);
					}}
				/>
				<Button
					size="sm"
					variant="ghost"
					onClick={() => handleSave(row.id, columnId, localValue)}
				>
					<Check />
				</Button>
				<Button size="sm" variant="ghost" onClick={() => setEditingCell(null)}>
					<X />
				</Button>
			</div>
		);
	}

	const readOnlyContent =
		displayValue ??
		((type === "select" && options.length > 0
			? (options.find((o) => String(o.value) === String(rawValue))?.label ??
				rawValue)
			: rawValue) as ReactNode);

	return (
		<Button
			className="cursor-pointer"
			onClick={() => setEditingCell({ id: row.id, columnId })}
		>
			{readOnlyContent}
		</Button>
	);
}
