import { Edit, Trash2, Pill, Eye } from "lucide-react";
import { Formatters } from "@/lib/formatters";
import { ActionMenu } from "@/components/ui/ActionMenu";
import { User, MedicalResult } from "@/types/api";

const TD_CLASS = "align-middle whitespace-nowrap py-4 px-4 border-b border-glass-border/50";

interface MedicalResultsTableRowProps {
  result: MedicalResult;
  users: User[];
  userRole?: string;
  onEdit: (r: MedicalResult) => void;
  onDelete: (id: number) => void;
  onViewDetails?: (r: MedicalResult) => void;
  onCreatePrescription?: (r: MedicalResult) => void;
}

function buildActionMenuItems(
  r: MedicalResult,
  userRole: string | undefined,
  onEdit: (r: MedicalResult) => void,
  onDelete: (id: number) => void,
  onViewDetails?: (r: MedicalResult) => void,
  onCreatePrescription?: (r: MedicalResult) => void
) {
  const isAdmin = userRole === "admin";
  return [
    ...(onViewDetails ? [{ label: "Lihat Detail", icon: <Eye size={14} />, onClick: () => onViewDetails(r) }] : []),
    ...(!r.has_prescription && onCreatePrescription ? [{
      label: "E-Resep", icon: <Pill size={14} />, onClick: () => onCreatePrescription(r), disabled: isAdmin, variant: "info" as const
    }] : []),
    ...(r.has_prescription ? [{ label: "E-Resep Selesai", icon: <Pill size={14} />, onClick: () => {}, disabled: true }] : []),
    { label: "Edit", icon: <Edit size={14} />, onClick: () => onEdit(r), disabled: isAdmin },
    { label: "Hapus", icon: <Trash2 size={14} />, onClick: () => onDelete(r.id), disabled: isAdmin, variant: "danger" as const },
  ];
}

export function MedicalResultsTableRow({
  result: r, users, userRole, onEdit, onDelete, onViewDetails, onCreatePrescription
}: MedicalResultsTableRowProps) {
  const user = users.find((u) => u.id === r.user_id);
  const userName = user?.full_name || user?.email || `User #${r.user_id}`;
  const menuItems = buildActionMenuItems(r, userRole, onEdit, onDelete, onViewDetails, onCreatePrescription);

  return (
    <tr className="hover:bg-overlay-dark] dark:hover:bg-overlay-light] transition-colors group">
      <td className={`${TD_CLASS} text-center font-medium text-foreground text-xs`}>
        {Formatters.date(r.result_date, "short")}
      </td>
      <td className={`${TD_CLASS} text-center font-medium text-foreground`}>{userName}</td>
      <td className={`${TD_CLASS} text-center font-medium text-foreground text-foreground/80`}>{r.doctor_name || "-"}</td>
      <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
        <div>{r.test_name}</div>
        <span className="px-1.5 py-0.5 bg-primary/10 text-primary rounded text-xs mt-1 inline-block">{r.test_type}</span>
      </td>
      <td className={`${TD_CLASS} text-center font-medium text-foreground text-foreground/70 max-w-xs truncate`}>{r.result}</td>
      <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
        <div className="flex justify-center" title={userRole === "admin" ? "Aksi klinis hanya untuk Dokter/Apoteker" : undefined}>
          <ActionMenu items={menuItems} />
        </div>
      </td>
    </tr>
  );
}
