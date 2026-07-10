import { User } from "@/types/api";
import { Formatters } from "@/lib/formatters";
import { ShieldAlert, Eye, Edit, Trash2 } from "lucide-react";
import { ActionMenu } from "@/components/ui/ActionMenu";

const TH_CLASS = "align-middle whitespace-nowrap py-3 px-4 text-xs font-bold uppercase tracking-wider text-foreground/50";
const TD_CLASS = "align-middle whitespace-nowrap py-4 px-4 border-b border-glass-border/50";

interface UsersTableProps {
  users: User[];
  loading: boolean;
  authUser: User | null;
  onView: (user: User) => void;
  onEdit: (user: User) => void;
  onDelete: (id: number, name: string) => void;
}

export function UsersTable({ users, loading, authUser, onView, onEdit, onDelete }: UsersTableProps) {
  return (
    <div className="w-full overflow-x-auto">
      <table className="w-full border-collapse text-sm">
        <thead>
          <tr className="border-b border-glass-border bg-overlay-dark] dark:bg-overlay-light]">
            <th className={`${TH_CLASS} text-center`}>Pengguna</th>
            <th className={`${TH_CLASS} text-center`}>Kontak</th>
            <th className={`${TH_CLASS} text-center`}>Peran (Role)</th>
            <th className={`${TH_CLASS} text-center`}>Aksi</th>
          </tr>
        </thead>
        <tbody>
          {loading ? (
            <tr><td colSpan={4} className={`${TD_CLASS} text-center p-8 text-foreground/50 font-normal`}>Memuat data...</td></tr>
          ) : users.length === 0 ? (
            <tr><td colSpan={4} className={`${TD_CLASS} text-center p-8 text-foreground/50 font-normal`}>Tidak ada pengguna ditemukan.</td></tr>
          ) : (
            users.map((u) => (
              <tr key={u.id} className="hover:bg-overlay-dark] dark:hover:bg-overlay-light] transition-colors group">
                <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                  <div className="flex items-center justify-start gap-3">
                    <img src={u.image_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(u.full_name)}&background=1e5e44&color=fff`} alt={u.full_name} className="w-8 h-8 rounded-full object-cover border border-glass-border" />
                    <div className="text-left"><div>{u.full_name}</div><div className="text-xs text-foreground/50 font-normal">ID: {u.id}</div></div>
                  </div>
                </td>
                <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                  <div>{u.email}</div>
                  <div className="text-xs text-foreground/50 font-normal">{Formatters.phone(u.phone_number)}</div>
                </td>
                <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                  <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md text-xs font-semibold ${u.role === "admin" ? "bg-error-muted text-error" : u.role === "doctor" ? "bg-info-muted text-info" : u.role === "pharmacist" ? "bg-warning-muted text-warning" : "bg-success-muted text-success"}`}>
                    {u.role === "admin" && <ShieldAlert size={12} />}
                    {u.role.toUpperCase()}
                  </span>
                </td>
                <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                  <div className="flex justify-center">
                    <ActionMenu
                      items={[
                        ...(u.role === "patient" ? [{
                          label: "Lihat Detail",
                          icon: <Eye size={14} />,
                          onClick: () => onView(u)
                        }] : []),
                        {
                          label: "Ubah",
                          icon: <Edit size={14} />,
                          onClick: () => onEdit(u)
                        },
                        ...(u.id !== authUser?.id ? [{
                          label: "Hapus",
                          icon: <Trash2 size={14} />,
                          onClick: () => onDelete(u.id, u.full_name),
                          variant: "danger" as const
                        }] : [])
                      ]}
                    />
                  </div>
                </td>
              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  );
}
