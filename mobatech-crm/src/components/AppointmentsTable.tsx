import { Appointment } from "@/types/api";
import { Formatters } from "@/lib/formatters";
import { Badge, BadgeVariant } from "@/components/ui/Badge";
import { Check, X, Stethoscope, CheckCircle2, Eye, Inbox } from "lucide-react";
import { ActionMenu } from "@/components/ui/ActionMenu";
import { SkeletonTable } from "@/components/ui/SkeletonTable";
import { useRouter } from "next/navigation";

const TH_CLASS = "align-middle whitespace-nowrap py-3 px-4 text-xs font-bold uppercase tracking-wider text-foreground/50";
const TD_CLASS = "align-middle whitespace-nowrap py-4 px-4 border-b border-glass-border/50";

interface AppointmentsTableProps {
  items: Appointment[];
  loading: boolean;
  processingId?: number | null;
  onApprove: (id: number) => void;
  onCancel: (id: number) => void;
  onComplete: (id: number) => void;
  onViewDetails: (item: Appointment) => void;
}

export function AppointmentsTable({ items, loading, processingId, onApprove, onCancel, onComplete, onViewDetails }: AppointmentsTableProps) {
  const router = useRouter();
  const getStatusBadge = (status: string) => {
    let variant: BadgeVariant = "warning";
    let label = "Menunggu";

    switch (status) {
      case "approved":
        variant = "success";
        label = "Disetujui";
        break;
      case "cancelled":
        variant = "error";
        label = "Dibatalkan";
        break;
      case "completed":
        variant = "info";
        label = "Selesai";
        break;
    }

    return <Badge variant={variant}>{label}</Badge>;
  };

  if (loading) {
    return <SkeletonTable rows={5} columns={6} />;
  }

  return (
    <div className="w-full overflow-x-auto">
      <table className="w-full border-collapse text-sm">
        <thead>
          <tr className="border-b border-glass-border bg-overlay-dark] dark:bg-overlay-light]">
            <th className={`${TH_CLASS} text-center`}>Tanggal Daftar</th>
            <th className={`${TH_CLASS} text-center`}>Pasien</th>
            <th className={`${TH_CLASS} text-center`}>Dokter & Jadwal</th>
            <th className={`${TH_CLASS} text-center`}>Catatan</th>
            <th className={`${TH_CLASS} text-center`}>Status</th>
            <th className={`${TH_CLASS} text-center`}>Aksi</th>
          </tr>
        </thead>
        <tbody>
          {items.map((item) => (
            <tr key={item.id} className="hover:bg-overlay-dark] dark:hover:bg-overlay-light] transition-colors group">
              <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                {Formatters.date(item.created_at, "datetime")}
              </td>
              <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                {item.user?.full_name || `Pasien #${item.user_id}`}
                <div className="text-xs text-foreground/60 font-normal">{item.user?.email}</div>
              </td>
              <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                <div>{item.doctor?.name}</div>
                <div className="text-xs text-foreground/60 font-normal">
                  {item.schedule ? `${Formatters.date(item.schedule.date, "long")} (${item.schedule.start_time} - ${item.schedule.end_time})` : "Jadwal tidak ditemukan"}
                </div>
              </td>
              <td className={`${TD_CLASS} text-center font-medium text-foreground max-w-[150px] truncate`}>
                {item.notes || "-"}
              </td>
              <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                {getStatusBadge(item.status)}
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
                      ...(item.status === "pending" ? [
                        {
                          label: "Setujui",
                          icon: <Check size={14} />,
                          onClick: () => onApprove(item.id),
                          disabled: processingId === item.id,
                          variant: "success" as const,
                        },
                        {
                          label: "Tolak",
                          icon: <X size={14} />,
                          onClick: () => onCancel(item.id),
                          disabled: processingId === item.id,
                          variant: "danger" as const,
                        }
                      ] : []),
                      ...(item.status === "approved" ? [
                        {
                          label: "Proses Rekam Medis",
                          icon: <Stethoscope size={14} />,
                          onClick: () => router.push(`/dashboard/medical-results?appointment_id=${item.id}&user_id=${item.user_id}&doctor_name=${encodeURIComponent(item.doctor?.name || '')}`),
                          variant: "info" as const,
                        },
                        {
                          label: "Akhiri Sesi",
                          icon: <CheckCircle2 size={14} />,
                          onClick: () => onComplete(item.id),
                          disabled: processingId === item.id,
                        }
                      ] : [])
                    ]}
                  />
                </div>
              </td>
            </tr>
          ))}
          {items.length === 0 && (
            <tr>
              <td colSpan={6} className={`${TD_CLASS} text-center py-16`}>
                <div className="flex flex-col items-center justify-center text-foreground/50">
                  <Inbox className="w-12 h-12 mb-3 text-foreground/20" />
                  <p className="text-sm font-normal">Tidak ada antrean saat ini</p>
                </div>
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
}
