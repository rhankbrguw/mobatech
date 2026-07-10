import { Medicine } from "@/types/api";
import { Badge } from "@/components/ui/Badge";
import { Package, Eye, Edit, Trash2, ShieldAlert } from "lucide-react";
import { Formatters } from "@/lib/formatters";
import { ActionMenu } from "@/components/ui/ActionMenu";
import { APP_STRINGS } from "@/lib/constants";

interface MedicineTableRowProps {
  medicine: Medicine;
  role: string;
  onView: (medicine: Medicine) => void;
  onEdit: (medicine: Medicine) => void;
  onDelete: (id: number, name: string) => void;
}

const TD_CLASS = "py-3 px-4 align-middle whitespace-nowrap border-b border-glass-border/30";

export function MedicineTableRow({ medicine, role, onView, onEdit, onDelete }: MedicineTableRowProps) {
  const isLowStock = medicine.stock <= 10;
  
  return (
    <tr className="group hover:bg-overlay-dark] dark:hover:bg-overlay-light] transition-colors cursor-pointer" onClick={() => onView(medicine)}>
      {/* ── Medicine Info ── */}
      <td className={TD_CLASS}>
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-lg bg-overlay-dark dark:bg-overlay-light border border-glass-border/50 flex items-center justify-center overflow-hidden shrink-0">
            {medicine.image_url ? (
              <img src={medicine.image_url} alt={medicine.name} className="w-full h-full object-cover" />
            ) : (
              <Package size={20} className="text-foreground/40" />
            )}
          </div>
          <div>
            <div className="font-bold text-sm text-foreground mb-0.5 max-w-[200px] truncate" title={medicine.name}>
              {medicine.name}
            </div>
            <div className="text-xs text-foreground/60 max-w-[200px] truncate" title={`${medicine.generic_name} • ${medicine.dosage} ${medicine.unit}`}>
              {medicine.generic_name} • {medicine.dosage} {medicine.unit}
            </div>
          </div>
        </div>
      </td>

      {/* ── Category ── */}
      <td className={`${TD_CLASS} text-center`}>
        <span className="inline-flex items-center px-2 py-0.5 rounded-full bg-primary/10 text-primary text-[10px] font-extrabold uppercase tracking-widest">
          {medicine.category?.name || "Umum"}
        </span>
      </td>

      {/* ── Price ── */}
      <td className={`${TD_CLASS} text-center font-bold text-foreground`}>
        {Formatters.currency(medicine.price)}
      </td>

      {/* ── Stock ── */}
      <td className={`${TD_CLASS} text-center`}>
        <Badge variant={isLowStock ? "error" : "success"}>
          {medicine.stock} {medicine.unit}
        </Badge>
      </td>

      {/* ── Type / Prescription Rule ── */}
      <td className={`${TD_CLASS} text-center`}>
        {medicine.requires_prescription ? (
          <div className="flex items-center justify-center gap-1.5 text-xs font-semibold text-warning dark:text-warning bg-warning-muted rounded-full px-2 py-1 mx-auto w-max" title="Resep Dokter Diperlukan">
            <ShieldAlert size={12} /> Resep
          </div>
        ) : (
          <div className="text-xs font-medium text-foreground/50">Bebas</div>
        )}
      </td>

      {/* ── Actions ── */}
      <td className={`${TD_CLASS} text-center`}>
        <div className="inline-block" onClick={(e) => e.stopPropagation()} title={role === "admin" ? APP_STRINGS.common.clinicalOnly : undefined}>
          <ActionMenu
            items={[
              { label: "Lihat Detail", icon: <Eye size={14} />, onClick: () => onView(medicine) },
              { label: "Edit", icon: <Edit size={14} />, onClick: () => onEdit(medicine), disabled: role === "admin" },
              { label: "Hapus", icon: <Trash2 size={14} />, onClick: () => onDelete(medicine.id, medicine.name), disabled: role === "admin", variant: "danger" as const }
            ]}
          />
        </div>
      </td>
    </tr>
  );
}
