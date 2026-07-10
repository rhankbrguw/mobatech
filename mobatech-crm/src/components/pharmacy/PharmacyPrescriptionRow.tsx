import { Button } from "@/components/ui/Button";
import { ActionMenu } from "@/components/ui/ActionMenu";
import { StatusPill } from "@/components/StatusPill";
import { Eye, Pill } from "lucide-react";
import { Prescription } from "@/types/api";
import { Formatters } from "@/lib/formatters";

const TD_CLASS = "align-middle whitespace-nowrap py-4 px-4 border-b border-glass-border/50";

interface PharmacyPrescriptionRowProps {
  prescription: Prescription;
  onView: (p: Prescription) => void;
  onProcess: (id: number) => void;
}

export function PharmacyPrescriptionRow({ prescription: p, onView, onProcess }: PharmacyPrescriptionRowProps) {
  return (
    <tr className="hover:bg-overlay-dark] dark:hover:bg-overlay-light] transition-colors group">
      <td className={`${TD_CLASS} text-center font-medium text-foreground text-xs`}>{Formatters.date(p.created_at, "datetime")}</td>
      <td className={`${TD_CLASS} text-center font-medium text-foreground text-xs`}>RES-{p.id} (U-{p.user_id})</td>
      <td className={`${TD_CLASS} text-center font-medium text-foreground`}>{p.doctor_name || "Anonim"}</td>
      <td className={`${TD_CLASS} text-center font-medium text-foreground max-w-[150px] truncate`} title={p.diagnosis}>{p.diagnosis || "-"}</td>
      <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
        <div className="flex justify-center">
          <StatusPill status={p.status} />
        </div>
      </td>
      <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
        <div className="inline-block" onClick={(e) => e.stopPropagation()}>
          <ActionMenu
            items={[
              { label: "Lihat Daftar Obat", icon: <Eye size={14} />, onClick: () => onView(p) },
              ...(p.status === "pending"
                ? [{ label: "Tebus Resep", icon: <Pill size={14} />, onClick: () => onProcess(p.id), variant: "success" as const }]
                : [])
            ]}
          />
        </div>
      </td>
    </tr>
  );
}
