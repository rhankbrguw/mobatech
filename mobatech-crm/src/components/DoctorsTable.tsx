import React from "react";
import { Doctor } from "@/types/api";
import { APP_STRINGS } from "@/lib/constants";
import { useAuthStore } from "@/store/useAuthStore";
import { Formatters } from "@/lib/formatters";
import { Badge } from "@/components/ui/Badge";
import { Edit, Trash2, Calendar, Eye, Inbox } from "lucide-react";
import { SkeletonTable } from "@/components/ui/SkeletonTable";
import { ActionMenu } from "@/components/ui/ActionMenu";

const TH_CLASS = "align-middle whitespace-nowrap py-3 px-4 text-xs font-bold uppercase tracking-wider text-foreground/50";
const TD_CLASS = "align-middle whitespace-nowrap py-4 px-4 border-b border-glass-border/50";

export function DoctorsTable({
  items,
  loading,
  onViewDetails,
  openSchedules,
  openForm,
  setDeleteId,
}: {
  items: Doctor[];
  loading: boolean;
  onViewDetails: (item: Doctor) => void;
  openSchedules: (item: Doctor) => void;
  openForm: (item: Doctor) => void;
  setDeleteId: (id: number) => void;
}) {
  const user = useAuthStore((state) => state.user);
  const isDoctor = user?.role === "doctor";
  if (loading) {
    return <SkeletonTable rows={5} columns={6} />;
  }

  return (
    <div className="w-full overflow-x-auto">
      <table className="w-full border-collapse text-sm">
        <thead>
          <tr className="border-b border-glass-border bg-overlay-dark] dark:bg-overlay-light]">
            <th className={`${TH_CLASS} text-center`}>{APP_STRINGS.doctors.tableHeaderName}</th>
            <th className={`${TH_CLASS} text-center`}>Poliklinik</th>
            <th className={`${TH_CLASS} text-center`}>{APP_STRINGS.doctors.tableHeaderSpec}</th>
            <th className={`${TH_CLASS} text-center`}>{APP_STRINGS.doctors.tableHeaderContact}</th>
            <th className={`${TH_CLASS} text-center`}>{APP_STRINGS.doctors.tableHeaderStatus}</th>
            <th className={`${TH_CLASS} text-center`}>{APP_STRINGS.doctors.tableHeaderActions}</th>
          </tr>
        </thead>
        <tbody>
          {items.length === 0 ? (
            <tr>
              <td colSpan={6} className={`${TD_CLASS} text-center py-16`}>
                <div className="flex flex-col items-center justify-center text-foreground/50">
                  <Inbox className="w-12 h-12 mb-3 text-foreground/20" />
                  <p className="text-sm font-normal">Data tidak ditemukan</p>
                </div>
              </td>
            </tr>
          ) : items.map((item) => (
            <tr key={item.id} className="hover:bg-overlay-dark] dark:hover:bg-overlay-light] transition-colors group">
              <td className={`${TD_CLASS} text-center font-medium text-foreground`}>{item.name}</td>
              <td className={`${TD_CLASS} text-center font-medium text-foreground`}>{item.polyclinic?.name || "-"}</td>
              <td className={`${TD_CLASS} text-center font-medium text-foreground`}>{item.specialization}</td>
              <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                <span className="font-normal">{Formatters.phone(item.contact_info)}</span>
              </td>
              <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                <Badge variant={item.is_active ? "success" : "error"}>
                  {item.is_active ? APP_STRINGS.doctors.statusActive : APP_STRINGS.doctors.statusInactive}
                </Badge>
              </td>
              <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                <div className="flex justify-center">
                  <ActionMenu
                    items={[
                      {
                        label: "Lihat Detail",
                        icon: <Eye size={14} />,
                        onClick: () => onViewDetails(item),
                      },
                      {
                        label: "Jadwal",
                        icon: <Calendar size={14} />,
                        onClick: () => openSchedules(item),
                      },
                      {
                        label: "Ubah",
                        icon: <Edit size={14} />,
                        onClick: () => openForm(item),
                      },
                      ...(!isDoctor ? [{
                        label: "Hapus",
                        icon: <Trash2 size={14} />,
                        onClick: () => setDeleteId(item.id),
                        variant: "danger" as const,
                      }] : [])
                    ]}
                  />
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
