import { Edit, Trash2, Pill, Eye, Inbox } from "lucide-react";
import { useRouter } from "next/navigation";
import { Card } from "@/components/ui/Card";
import { Formatters } from "@/lib/formatters";
import { ActionMenu } from "@/components/ui/ActionMenu";
import { SkeletonTable } from "@/components/ui/SkeletonTable";

const TH_CLASS = "align-middle whitespace-nowrap py-3 px-4 text-xs font-bold uppercase tracking-wider text-foreground/50";
const TD_CLASS = "align-middle whitespace-nowrap py-4 px-4 border-b border-glass-border/50";

interface User { id: number; full_name: string; email: string; }
interface MedicalResult { id: number; created_at: string; user_id: number; appointment_id: number; doctor_name: string; test_type: string; test_name: string; result: string; notes: string; file_url: string; result_date: string; }

export function MedicalResultsTable({ 
  loading, 
  results, 
  users, 
  onEdit, 
  onDelete,
  onViewDetails,
  userRole 
}: { 
  loading: boolean;
  results: MedicalResult[];
  users: User[];
  onEdit: (r: MedicalResult) => void;
  onDelete: (id: number) => void;
  onViewDetails?: (r: MedicalResult) => void;
  userRole?: string;
}) {
  const router = useRouter();

  return (
    <Card noPadding>
      <div className="w-full overflow-x-auto">
        {loading ? (
          <SkeletonTable rows={5} columns={6} />
        ) : (
          <table className="w-full border-collapse text-sm">
            <thead>
              <tr className="border-b border-glass-border bg-overlay-dark] dark:bg-overlay-light]">
                <th className={`${TH_CLASS} text-center`}>Tanggal</th>
                <th className={`${TH_CLASS} text-center`}>Pasien</th>
                <th className={`${TH_CLASS} text-center`}>Dokter</th>
                <th className={`${TH_CLASS} text-center`}>Pemeriksaan</th>
                <th className={`${TH_CLASS} text-center`}>Ringkasan Hasil</th>
                <th className={`${TH_CLASS} text-center`}>Aksi</th>
              </tr>
            </thead>
            <tbody>
              {results.length === 0 ? (
                <tr>
                  <td colSpan={6} className="text-center py-16">
                    <div className="flex flex-col items-center justify-center text-foreground/50">
                      <Inbox className="w-12 h-12 mb-3 text-foreground/20" />
                      <p className="text-sm">Belum ada data hasil medis.</p>
                    </div>
                  </td>
                </tr>
              ) : results.map((r) => (
                <tr key={r.id} className="hover:bg-overlay-dark] dark:hover:bg-overlay-light] transition-colors group">
                  <td className={`${TD_CLASS} text-center font-medium text-foreground text-xs`}>
                    {Formatters.date(r.result_date, "short")}
                  </td>
                  <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                    {users.find((u) => u.id === r.user_id)?.full_name || users.find((u) => u.id === r.user_id)?.email || `User #${r.user_id}`}
                  </td>
                  <td className={`${TD_CLASS} text-center font-medium text-foreground text-foreground/80`}>{r.doctor_name || "-"}</td>
                  <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                    <div>{r.test_name}</div>
                    <span className="px-1.5 py-0.5 bg-primary/10 text-primary rounded text-xs mt-1 inline-block">{r.test_type}</span>
                  </td>
                  <td className={`${TD_CLASS} text-center font-medium text-foreground text-foreground/70 max-w-xs truncate`}>{r.result}</td>
                  <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                    <div className="flex justify-center" title={userRole === "admin" ? "Aksi klinis hanya untuk Dokter/Apoteker" : undefined}>
                      <ActionMenu
                        items={[
                          ...(onViewDetails ? [{
                            label: "Lihat Detail",
                            icon: <Eye size={14} />,
                            onClick: () => onViewDetails(r),
                          }] : []),
                          {
                            label: "E-Resep",
                            icon: <Pill size={14} />,
                            onClick: () => router.push(`/dashboard/pharmacy?action=create_prescription&appointment_id=${r.appointment_id || ''}&user_id=${r.user_id}&doctor_name=${encodeURIComponent(r.doctor_name || '')}&diagnosis=${encodeURIComponent(r.result || '')}`),
                            variant: "info" as const,
                          },
                          {
                            label: "Edit",
                            icon: <Edit size={14} />,
                            onClick: () => onEdit(r),
                            disabled: userRole === "admin",
                          },
                          {
                            label: "Hapus",
                            icon: <Trash2 size={14} />,
                            onClick: () => onDelete(r.id),
                            disabled: userRole === "admin",
                            variant: "danger" as const,
                          }
                        ]}
                      />
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </Card>
  );
}
