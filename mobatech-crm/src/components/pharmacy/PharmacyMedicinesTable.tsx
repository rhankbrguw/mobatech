import { Medicine } from "@/types/api";
import { MedicineTableRow } from "./MedicineTableRow";
import { MedicineEmptyState } from "./MedicineEmptyState";
import { Card } from "@/components/ui/Card";
import { APP_STRINGS } from "@/lib/constants";

interface PharmacyMedicinesTableProps {
  medicines: Medicine[];
  role: string;
  onView: (medicine: Medicine) => void;
  onEdit: (medicine: Medicine) => void;
  onDelete: (id: number, name: string) => void;
}

const TH_CLASS = "align-middle whitespace-nowrap py-3 px-4 text-xs font-bold uppercase tracking-wider text-foreground/50";

export function PharmacyMedicinesTable({ medicines, role, onView, onEdit, onDelete }: PharmacyMedicinesTableProps) {
  if (medicines.length === 0) return <MedicineEmptyState />;

  return (
    <Card noPadding>
      <div className="w-full overflow-x-auto">
        <table className="w-full border-collapse text-sm">
          <thead>
            <tr className="border-b border-glass-border bg-overlay-dark] dark:bg-overlay-light]">
              <th className={`${TH_CLASS} text-center`}>{APP_STRINGS.pharmacy.medicineName}</th>
              <th className={`${TH_CLASS} text-center`}>{APP_STRINGS.pharmacy.category}</th>
              <th className={`${TH_CLASS} text-center`}>{APP_STRINGS.pharmacy.price}</th>
              <th className={`${TH_CLASS} text-center`}>{APP_STRINGS.pharmacy.stock}</th>
              <th className={`${TH_CLASS} text-center`}>Tipe</th>
              <th className={`${TH_CLASS} text-center w-20`}>{APP_STRINGS.common.action}</th>
            </tr>
          </thead>
          <tbody>
            {medicines.map((m) => (
              <MedicineTableRow
                key={m.id}
                medicine={m}
                role={role}
                onView={onView}
                onEdit={onEdit}
                onDelete={onDelete}
              />
            ))}
          </tbody>
        </table>
      </div>
    </Card>
  );
}
