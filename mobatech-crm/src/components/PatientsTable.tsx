import { Badge } from "@/components/ui/Badge";
import { Formatters } from "@/lib/formatters";
import { Eye, Inbox } from "lucide-react";
import { ActionMenu } from "@/components/ui/ActionMenu";
import { SkeletonTable } from "@/components/ui/SkeletonTable";

const TH_CLASS = "align-middle whitespace-nowrap py-3 px-4 text-xs font-bold uppercase tracking-wider text-foreground/50";
const TD_CLASS = "align-middle whitespace-nowrap py-4 px-4 border-b border-glass-border/50";

export interface FamilyMember {
  id: number;
  name: string;
  relation: string;
  date_of_birth: string;
}

export interface User {
  id: number;
  created_at: string;
  full_name: string;
  email: string;
  phone_number: string;
  blood_type: string;
  height: number;
  weight: number;
  allergies: string;
  date_of_birth: string;
  gender: string;
  family_members?: FamilyMember[];
}

interface PatientsTableProps {
  items: User[];
  loading: boolean;
  onViewDetails?: (item: User) => void;
}

export function PatientsTable({ items, loading, onViewDetails }: PatientsTableProps) {
  if (loading) {
    return <SkeletonTable rows={5} columns={5} />;
  }

  return (
    <div className="w-full overflow-x-auto">
      <table className="w-full border-collapse text-sm">
        <thead>
          <tr className="border-b border-glass-border bg-overlay-dark] dark:bg-overlay-light]">
            <th className={`${TH_CLASS} text-center`}>Tanggal Daftar</th>
            <th className={`${TH_CLASS} text-center`}>Identitas Pasien</th>
            <th className={`${TH_CLASS} text-center`}>Kontak</th>
            <th className={`${TH_CLASS} text-center`}>Data Medis Dasar</th>
            <th className={`${TH_CLASS} text-center`}>Anggota Keluarga</th>
            <th className={`${TH_CLASS} text-center`}>Aksi</th>
          </tr>
        </thead>
        <tbody>
          {items.length === 0 ? (
            <tr>
              <td colSpan={6} className={`${TD_CLASS} text-center py-16`}>
                <div className="flex flex-col items-center justify-center text-foreground/50">
                  <Inbox className="w-12 h-12 mb-3 text-foreground/20" />
                  <p className="text-sm font-normal">Tidak ada pasien ditemukan.</p>
                </div>
              </td>
            </tr>
          ) : (
            items.map((user) => (
              <tr key={user.id} className="hover:bg-overlay-dark] dark:hover:bg-overlay-light] transition-colors group">
                <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                  {Formatters.date(user.created_at, "short")}
                </td>
                <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                  <div>{user.full_name || "Tanpa Nama"}</div>
                  <div className="text-xs text-foreground/60 capitalize mt-1 font-normal">
                    {user.gender ? (user.gender.toLowerCase() === 'male' || user.gender.toLowerCase() === 'laki-laki' ? 'Laki-laki' : 'Perempuan') : '-'}
                    {user.date_of_birth && ` • ${user.date_of_birth}`}
                  </div>
                </td>
                <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                  <div>{user.email}</div>
                  <div className="text-xs text-foreground/60 mt-1 font-normal">{Formatters.phone(user.phone_number)}</div>
                </td>
                <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                  <div className="flex flex-wrap justify-center gap-1 text-xs font-normal">
                    <Badge variant="neutral" className="bg-primary/10 text-primary border-primary/20">
                      Gol. Darah: {user.blood_type || "-"}
                    </Badge>
                    {(user.height > 0 || user.weight > 0) && (
                      <Badge variant="info">
                        {user.height} cm / {user.weight} kg
                      </Badge>
                    )}
                    {user.allergies && (
                      <Badge variant="error">
                        Alergi: {user.allergies}
                      </Badge>
                    )}
                  </div>
                </td>
                <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                  <Badge variant="neutral">
                    {user.family_members?.length || 0} Terhubung
                  </Badge>
                </td>
                <td className={`${TD_CLASS} text-center font-medium text-foreground`}>
                  <div className="flex justify-center">
                    <ActionMenu
                      items={[
                        ...(onViewDetails ? [{
                          label: "Lihat Detail",
                          icon: <Eye size={14} />,
                          onClick: () => onViewDetails(user),
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
