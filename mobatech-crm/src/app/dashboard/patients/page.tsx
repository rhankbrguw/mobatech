"use client";

import { useState, useEffect } from "react";
import { api, ApiError } from "@/lib/api";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { APP_STRINGS } from "@/lib/constants";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card } from "@/components/ui/Card";
import { Badge } from "@/components/ui/Badge";
import { Search } from "lucide-react";

interface FamilyMember {
  id: number;
  name: string;
  relation: string;
  date_of_birth: string;
}

interface User {
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

export default function PatientsPage() {
  const [items, setItems] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState("");

  const [toast, setToast] = useState<{
    isOpen: boolean;
    message: string;
    type: "success" | "error" | "warning" | "info";
  }>({
    isOpen: false,
    message: "",
    type: "success",
  });

  const loadItems = async () => {
    try {
      setLoading(true);
      const res = await api.get<User[]>("/api/admin/users");
      setItems(res.data || []);
    } catch (err) {
      const msg = err instanceof ApiError ? err.message : APP_STRINGS.login.networkError;
      setToast({ isOpen: true, message: msg, type: "error" });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadItems();
  }, []);

  const filteredItems = items.filter((user) =>
    user.full_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    user.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
    user.phone_number.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="space-y-6 animate-slide-in">
      <PageHeader
        title="Daftar Pasien"
        description="Kelola dan pantau data demografi pasien yang terdaftar di aplikasi mobile."
      />

      {/* Filter / Search Bar */}
      <div className="flex items-center gap-3 bg-background/50 dark:bg-white/5 p-3 rounded-xl border border-glass-border shadow-sm">
        <Search size={18} className="text-foreground/50 ml-2" />
        <input
          type="text"
          placeholder="Cari nama, email, atau no HP pasien..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="flex-1 bg-transparent border-none outline-none text-sm text-foreground"
        />
      </div>

      <Card noPadding className="overflow-x-auto">
        {loading ? (
          <div className="p-8 text-center text-foreground/50 animate-pulse text-sm">Memuat data...</div>
        ) : (
          <table className="w-full text-left border-collapse text-sm">
            <thead>
              <tr className="border-b border-glass-border bg-black/5 dark:bg-white/5 font-semibold">
                <th className="p-4">Tanggal Daftar</th>
                <th className="p-4">Identitas Pasien</th>
                <th className="p-4">Kontak</th>
                <th className="p-4">Data Medis Dasar</th>
                <th className="p-4">Anggota Keluarga</th>
              </tr>
            </thead>
            <tbody>
              {filteredItems.length === 0 ? (
                <tr>
                  <td colSpan={5} className="p-8 text-center text-foreground/50">
                    Tidak ada pasien ditemukan.
                  </td>
                </tr>
              ) : (
                filteredItems.map((user) => (
                  <tr key={user.id} className="border-b border-glass-border/50 hover:bg-black/5 dark:hover:bg-white/5 transition-colors">
                    <td className="p-4 text-foreground/80">
                      {new Date(user.created_at).toLocaleDateString("id-ID", { day: "2-digit", month: "short", year: "numeric" })}
                    </td>
                    <td className="p-4">
                      <div className="font-semibold">{user.full_name || "Tanpa Nama"}</div>
                      <div className="text-xs text-foreground/60 capitalize mt-1">
                        {user.gender ? (user.gender.toLowerCase() === 'male' || user.gender.toLowerCase() === 'laki-laki' ? 'Laki-laki' : 'Perempuan') : '-'}
                        {user.date_of_birth && ` • ${user.date_of_birth}`}
                      </div>
                    </td>
                    <td className="p-4">
                      <div className="text-foreground/90">{user.email}</div>
                      <div className="text-xs text-foreground/60 mt-1">{user.phone_number || "-"}</div>
                    </td>
                    <td className="p-4">
                      <div className="flex flex-wrap gap-1 text-xs">
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
                    <td className="p-4">
                      <Badge variant="neutral">
                        {user.family_members?.length || 0} Terhubung
                      </Badge>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        )}
      </Card>

      <CustomSnackbar
        isOpen={toast.isOpen}
        message={toast.message}
        type={toast.type}
        onClose={() => setToast((t) => ({ ...t, isOpen: false }))}
      />
    </div>
  );
}
