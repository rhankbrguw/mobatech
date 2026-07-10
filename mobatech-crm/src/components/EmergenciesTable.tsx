import { EmergencyRequest } from "@/types/api";
import { Formatters } from "@/lib/formatters";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";

const TH_CLASS = "align-middle whitespace-nowrap py-3 px-4 text-xs font-bold uppercase tracking-wider text-foreground/50";
const TD_CLASS = "align-middle whitespace-nowrap py-4 px-4 border-b border-glass-border/50";

interface Props {
  items: EmergencyRequest[];
  loading: boolean;
  updateStatus: (id: number, status: string) => void;
}

export function EmergenciesTable({ items, loading, updateStatus }: Props) {
  const getStatusBadge = (status: string) => {
    switch (status) {
      case "Pending":
        return <Badge variant="error" className="animate-pulse">Kritis (Menunggu)</Badge>;
      case "Dispatched":
        return <Badge variant="warning">Ambulans Jalan</Badge>;
      case "Arrived":
        return <Badge variant="info">Tiba di Lokasi</Badge>;
      case "Resolved":
        return <Badge variant="success">Selesai</Badge>;
      default:
        return <Badge variant="neutral">{status}</Badge>;
    }
  };

  if (loading && items.length === 0) {
    return <div className="p-8 text-center text-foreground/50 animate-pulse text-sm">Memuat data...</div>;
  }

  return (
    <table className="w-full border-collapse text-sm">
      <thead>
        <tr className="border-b border-glass-border bg-overlay-dark] dark:bg-overlay-light]">
          <th className={`${TH_CLASS} text-center`}>Waktu Laporan</th>
          <th className={`${TH_CLASS} text-center`}>Nama Pasien</th>
          <th className={`${TH_CLASS} text-center`}>Kondisi</th>
          <th className={`${TH_CLASS} text-center`}>Lokasi & Kontak</th>
          <th className={`${TH_CLASS} text-center`}>Status</th>
          <th className={`${TH_CLASS} text-center`}>Aksi</th>
        </tr>
      </thead>
      <tbody>
        {items.map((item) => (
          <tr key={item.id} className="hover:bg-overlay-dark] dark:hover:bg-overlay-light] transition-colors group">
            <td className={`${TD_CLASS} text-center font-medium text-foreground text-foreground/80`}>{Formatters.date(item.created_at, "datetimesec")}</td>
            <td className={`${TD_CLASS} text-center font-medium text-foreground text-error dark:text-error`}>{item.patient_name}</td>
            <td className={`${TD_CLASS} text-center font-medium text-foreground text-foreground/80 max-w-[150px] truncate`}>{item.condition}</td>
            <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
              <div className="text-foreground/80 font-medium truncate max-w-[200px]">{item.location}</div>
              <div className="text-xs text-foreground/60 mt-1">{Formatters.phone(item.phone_number)}</div>
            </td>
            <td className={`${TD_CLASS} text-center font-medium text-foreground`}>{getStatusBadge(item.status)}</td>
            <td className={`${TD_CLASS} text-center font-medium text-foreground space-x-2 whitespace-nowrap`}>
              {item.status === "Pending" && (
                <Button size="sm" onClick={() => updateStatus(item.id, "Dispatched")} className="bg-warning-muted text-warning dark:text-warning border border-warning-muted hover:bg-warning-muted">
                  Kirim Ambulans
                </Button>
              )}
              {item.status === "Dispatched" && (
                <Button size="sm" onClick={() => updateStatus(item.id, "Arrived")} className="bg-info-muted text-info dark:text-info border border-info-muted hover:bg-info-muted">
                  Tiba di Lokasi
                </Button>
              )}
              {item.status === "Arrived" && (
                <Button size="sm" onClick={() => updateStatus(item.id, "Resolved")} className="bg-success-muted text-success dark:text-success border border-success-muted hover:bg-success-muted">
                  Selesai
                </Button>
              )}
            </td>
          </tr>
        ))}
        {items.length === 0 && (
          <tr>
            <td colSpan={6} className="p-8 text-center text-foreground/50 text-sm">Tidak ada keadaan darurat saat ini</td>
          </tr>
        )}
      </tbody>
    </table>
  );
}
