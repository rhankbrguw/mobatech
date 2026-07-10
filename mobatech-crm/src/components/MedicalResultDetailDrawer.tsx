import { SideDrawer } from "@/components/ui/SideDrawer";

interface User { id: number; full_name: string; email: string; }
interface MedicalResult { id: number; created_at: string; user_id: number; appointment_id: number; doctor_name: string; test_type: string; test_name: string; result: string; notes: string; file_url: string; result_date: string; }

interface Props {
  isOpen: boolean;
  onClose: () => void;
  item: MedicalResult | null;
  users: User[];
}

export function MedicalResultDetailDrawer({ isOpen, onClose, item, users }: Props) {
  if (!item) return null;

  return (
    <SideDrawer isOpen={isOpen} onClose={onClose} title="Detail Hasil Medis">
      <div className="space-y-4 text-sm">
        <div className="break-words"><strong>Pasien:</strong> {users.find((u) => u.id === item.user_id)?.full_name || `User #${item.user_id}`}</div>
        <div className="break-words"><strong>Dokter:</strong> {item.doctor_name || "-"}</div>
        <div className="break-words"><strong>Tanggal:</strong> {item.result_date.slice(0, 10)}</div>
        <div className="break-words"><strong>Pemeriksaan:</strong> {item.test_name} ({item.test_type})</div>
        <div className="break-words">
          <strong>Hasil:</strong>
          <p className="mt-1 text-foreground/80 whitespace-pre-wrap">{item.result}</p>
        </div>
        {item.notes && (
          <div className="break-words">
            <strong>Catatan:</strong>
            <p className="mt-1 text-foreground/80 whitespace-pre-wrap">{item.notes}</p>
          </div>
        )}
        {item.file_url && (
          <div className="break-words mt-4">
            <strong>Dokumen:</strong> <br/>
            <a href={item.file_url} target="_blank" rel="noreferrer" className="text-primary hover:underline mt-1 inline-block">Unduh / Lihat File</a>
          </div>
        )}
      </div>
    </SideDrawer>
  );
}
