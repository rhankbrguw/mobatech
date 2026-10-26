import Image from "next/image";
import { User } from "@/types/api";
import { Formatters } from "@/lib/formatters";
import { Eye, Edit, Trash2 } from "lucide-react";
import { ActionMenu } from "@/components/ui/ActionMenu";
import { Badge } from "@/components/ui/Badge";
import { APP_STRINGS } from "@/constants";

const TH_CLASS = "align-middle whitespace-nowrap py-3 px-3 sm:px-4 text-xs font-bold uppercase tracking-wider text-foreground/50";
const TD_CLASS = "align-middle whitespace-nowrap py-3.5 sm:py-4 px-3 sm:px-4 border-b border-glass-border/50 text-xs sm:text-sm";

interface PharmacistsTableProps {
  pharmacists: User[];
  loading: boolean;
  onView: (pharmacist: User) => void;
  onEdit: (pharmacist: User) => void;
  onDelete: (id: number, name: string) => void;
}

export function PharmacistsTable({
  pharmacists,
  loading,
  onView,
  onEdit,
  onDelete,
}: PharmacistsTableProps) {
  return (
    <div className="w-full overflow-x-auto custom-scrollbar">
      <table className="w-full min-w-[640px] border-collapse text-sm">
        <thead>
          <tr className="border-b border-glass-border bg-overlay-dark dark:bg-overlay-light">
            <th className={`${TH_CLASS} text-left pl-6`}>Apoteker</th>
            <th className={`${TH_CLASS} text-left pl-4`}>Email & Kontak</th>
            <th className={`${TH_CLASS} text-center`}>Peran (Role)</th>
            <th className={`${TH_CLASS} text-center pr-6`}>Aksi</th>
          </tr>
        </thead>
        <tbody>
          {loading ? (
            <tr><td colSpan={4} className={`${TD_CLASS} text-center p-8 text-foreground/50 font-normal`}>{APP_STRINGS.common.loadError}...</td></tr>
          ) : pharmacists.length === 0 ? (
            <tr><td colSpan={4} className={`${TD_CLASS} text-center p-8 text-foreground/50 font-normal`}>{APP_STRINGS.pharmacists.empty}</td></tr>
          ) : (
            pharmacists.map((p) => {
              const avatar = p.image_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(p.full_name)}&background=113C2B&color=fff`;
              const id = p.id || (p as { ID?: number }).ID || 0;
              return (
                <tr key={id} className="hover:bg-overlay-dark dark:hover:bg-overlay-light transition-colors group">
                  <td className={`${TD_CLASS} text-left pl-6 font-medium text-foreground`}>
                    <div className="flex items-center gap-3">
                      <Image unoptimized width={36} height={36} src={avatar} alt={p.full_name} className="w-9 h-9 rounded-full object-cover border border-glass-border shrink-0" />
                      <div className="min-w-0">
                        <div className="font-semibold text-foreground truncate">{p.full_name}</div>
                        <div className="text-xs text-foreground/50 font-normal">ID: {id}</div>
                      </div>
                    </div>
                  </td>
                  <td className={`${TD_CLASS} text-left pl-4 font-medium text-foreground`}>
                    <div className="truncate">{p.email}</div>
                    <div className="text-xs text-foreground/50 font-normal">{Formatters.phone(p.phone_number)}</div>
                  </td>
                  <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                    <Badge variant="warning">
                      APOTEKER
                    </Badge>
                  </td>
                  <td className={`${TD_CLASS} text-center pr-6 font-medium text-foreground`}>
                    <div className="flex justify-center">
                      <ActionMenu
                        items={[
                          { label: "Lihat Detail", icon: <Eye size={14} />, onClick: () => onView(p) },
                          { label: "Ubah", icon: <Edit size={14} />, onClick: () => onEdit(p) },
                          { label: "Hapus", icon: <Trash2 size={14} />, onClick: () => onDelete(id, p.full_name), variant: "danger" },
                        ]}
                      />
                    </div>
                  </td>
                </tr>
              );
            })
          )}
        </tbody>
      </table>
    </div>
  );
}
