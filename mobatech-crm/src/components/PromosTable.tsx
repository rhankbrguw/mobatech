import { Promo } from "@/types/api";
import { ActionMenu } from "@/components/ui/ActionMenu";
import { Edit, Trash2, Eye } from "lucide-react";

const TH_CLASS = "align-middle whitespace-nowrap py-3 px-4 text-xs font-bold uppercase tracking-wider text-foreground/50";
const TD_CLASS = "align-middle whitespace-nowrap py-4 px-4 border-b border-glass-border/50";

interface Props {
  promos: Promo[];
  loading: boolean;
  onView: (p: Promo) => void;
  onEdit: (p: Promo) => void;
  onDelete: (id: number, title: string) => void;
}

export function PromosTable({ promos, loading, onView, onEdit, onDelete }: Props) {
  return (
    <table className="w-full border-collapse text-sm">
      <thead>
        <tr className="border-b border-glass-border bg-overlay-dark] dark:bg-overlay-light]">
          <th className={`${TH_CLASS} text-center`}>Promo / Subtitle</th>
          <th className={`${TH_CLASS} text-center`}>Warna Tema</th>
          <th className={`${TH_CLASS} text-center`}>Status</th>
          <th className={`${TH_CLASS} text-center`}>Aksi</th>
        </tr>
      </thead>
      <tbody>
        {loading ? <tr><td colSpan={4} className="p-8 text-center text-foreground/50">Memuat...</td></tr> : promos.map((p) => (
          <tr key={p.id} className="hover:bg-overlay-dark] dark:hover:bg-overlay-light] transition-colors group">
            <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
              <div className="text-left"><div className="font-semibold">{p.title}</div><div className="text-xs text-foreground/60">{p.subtitle}</div></div>
            </td>
            <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
              <div className="flex items-center justify-center gap-2">
                <div className="w-4 h-4 rounded-full border border-glass-border shadow-sm" style={{backgroundColor: p.themeColor}}></div>
                <span className="font-mono text-xs text-foreground/75">{p.themeColor}</span>
              </div>
            </td>
            <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
              <span className={`inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${p.is_active ? 'bg-success-muted text-success' : 'bg-error-muted text-error'}`}>
                {p.is_active ? "Aktif" : "Tidak Aktif"}
              </span>
            </td>
            <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
              <div className="flex justify-center">
                <ActionMenu
                  items={[
                    { label: "Lihat Detail", icon: <Eye size={14} />, onClick: () => onView(p) },
                    { label: "Ubah", icon: <Edit size={14} />, onClick: () => onEdit(p) },
                    { label: "Hapus", icon: <Trash2 size={14} />, onClick: () => onDelete(p.id, `Hapus promo "${p.title}"?`), variant: "danger" as const }
                  ]}
                />
              </div>
            </td>
          </tr>
        ))}
        {!loading && promos.length === 0 && (
          <tr><td colSpan={4} className="p-8 text-center text-foreground/50">Tidak ada promo ditemukan.</td></tr>
        )}
      </tbody>
    </table>
  );
}
