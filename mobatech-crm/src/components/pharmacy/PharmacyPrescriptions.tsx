"use client";
import React, { useState, useEffect } from "react";
import { Prescription } from "@/types/api";
import { api } from "@/lib/api";
import { Check, Inbox } from "lucide-react";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { APP_STRINGS } from "@/lib/constants";
import { Formatters } from "@/lib/formatters";
import { PageHeader } from "@/components/ui/PageHeader";
import { SearchFilterBar } from "@/components/ui/SearchFilterBar";
import { FilterDropdown } from "@/components/ui/FilterDropdown";
import { Card } from "@/components/ui/Card";
import { ActionMenu } from "@/components/ui/ActionMenu";
import { Pagination } from "@/components/ui/Pagination";

const TH_CLASS = "align-middle whitespace-nowrap py-3 px-4 text-xs font-bold uppercase tracking-wider text-foreground/50 text-center";
const TD_CLASS = "align-middle whitespace-nowrap py-4 px-4 border-b border-glass-border/50 text-center font-medium text-foreground";

export function PharmacyPrescriptions({ initialPrescriptions }: { initialPrescriptions?: Prescription[] }) {
  const [prescriptions, setPrescriptions] = useState<Prescription[]>(initialPrescriptions || []);
  const [loadingId, setLoadingId] = useState<number | null>(null);
  const [toast, setToast] = useState<{isOpen: boolean, message: string, type: "success"|"error"}>({ isOpen: false, message: "", type: "success" });
  const [filterValue, setFilterValue] = useState("all");
  const [searchQuery, setSearchQuery] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  const loadPrescriptions = async () => {
    try {
      const q = new URLSearchParams({ page: currentPage.toString(), limit: "10" });
      if (searchQuery) q.append("search", searchQuery);
      if (filterValue !== "all") q.append("filter", filterValue);
      const res = await api.get<Prescription[]>(`/api/admin/pharmacy/prescriptions?${q}`);
      setPrescriptions(res.data || []);
      if (res.meta) setTotalPages(res.meta.total_pages);
    } catch {
      setToast({ isOpen: true, message: APP_STRINGS.login.networkError, type: "error" });
    }
  };

  useEffect(() => {
    setCurrentPage(1);
  }, [searchQuery, filterValue]);

  useEffect(() => {
    loadPrescriptions();
  }, [searchQuery, filterValue, currentPage]);

  const handleUpdateStatus = async (id: number, status: string) => {
    setLoadingId(id);
    try {
      await api.put(`/api/admin/pharmacy/prescriptions/${id}/status`, { status });
      await loadPrescriptions();
      setToast({ isOpen: true, message: APP_STRINGS.pharmacy.processSuccess, type: "success" });
    } catch {
      setToast({ isOpen: true, message: APP_STRINGS.pharmacy.processError, type: "error" });
    } finally {
      setLoadingId(null);
    }
  };

  const getStatusBadge = (status: string) => {
    const badges: Record<string, React.ReactNode> = {
      Requested: <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-500/20 text-yellow-600 dark:text-yellow-400 border border-yellow-500/20">Meminta Ditebus</span>,
      Pending: <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-orange-500/20 text-orange-600 dark:text-orange-400 border border-orange-500/20">Menunggu Pasien</span>,
      Redeemed: <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary/20 text-primary border border-primary/20">Selesai</span>
    };
    return badges[status] || <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-foreground/10 text-foreground/70 border border-foreground/10">{status}</span>;
  };

  return (
    <div className="space-y-6 animate-slide-in">
      <PageHeader
        title="Daftar E-Resep"
        description="Pantau dan proses permintaan tebus obat dari pasien secara real-time."
      />
      
      <div className="flex justify-end mb-4 gap-2">
        <FilterDropdown
          value={filterValue}
          onChange={setFilterValue}
          options={[
            { label: 'Semua Status', value: 'all' },
            { label: 'Meminta Ditebus', value: 'Requested' },
            { label: 'Menunggu Pasien', value: 'Pending' },
            { label: 'Selesai', value: 'Redeemed' }
          ]}
          placeholder="Pilih Status"
        />
        <SearchFilterBar 
          value={searchQuery} 
          onChange={setSearchQuery} 
          placeholder="Cari ID/Dokter..." 
        />
      </div>

      <Card noPadding>
        <div className="w-full overflow-x-auto">
          <table className="w-full border-collapse text-sm">
            <thead>
              <tr className="border-b border-glass-border bg-overlay-dark] dark:bg-overlay-light]">
                <th className={TH_CLASS}>ID Resep</th>
                <th className={TH_CLASS}>Pasien (ID)</th>
                <th className={TH_CLASS}>Dokter</th>
                <th className={TH_CLASS}>Tanggal</th>
                <th className={TH_CLASS}>Status</th>
                <th className={TH_CLASS}>Aksi</th>
              </tr>
            </thead>
            <tbody>
              {prescriptions.length === 0 ? (
                <tr>
                  <td colSpan={6} className="text-center py-16">
                    <div className="flex flex-col items-center justify-center text-foreground/50">
                      <Inbox className="w-12 h-12 mb-3 text-foreground/20" />
                      <p className="text-sm">Belum ada e-resep yang sesuai pencarian.</p>
                    </div>
                  </td>
                </tr>
              ) : prescriptions.map((p) => (
                <tr key={p.id} className="hover:bg-overlay-dark] dark:hover:bg-overlay-light] transition-colors group">
                  <td className={TD_CLASS}>#{p.id}</td>
                  <td className={TD_CLASS}>{p.user_id}</td>
                  <td className={`${TD_CLASS} text-foreground/80`}>{p.doctor_name || "-"}</td>
                  <td className={TD_CLASS}>{Formatters.date(p.CreatedAt || "", "short")}</td>
                  <td className={TD_CLASS}>{getStatusBadge(p.status)}</td>
                  <td className={TD_CLASS}>
                    <div className="flex justify-center">
                      <ActionMenu
                        items={[
                          ...(p.status === "Requested" ? [{ label: loadingId === p.id ? "Memproses..." : "Proses Tebus", icon: <Check size={14} />, onClick: () => handleUpdateStatus(p.id, "Redeemed"), disabled: loadingId === p.id, variant: "success" as const }] : []),
                          ...(p.status === "Pending" ? [{ label: loadingId === p.id ? "Memproses..." : "Proses Langsung", icon: <Check size={14} />, onClick: () => handleUpdateStatus(p.id, "Redeemed"), disabled: loadingId === p.id, variant: "success" as const }] : []),
                          ...(p.status === "Redeemed" ? [{ label: "Selesai", icon: <Check size={14} />, onClick: () => {}, disabled: true }] : [])
                        ]}
                      />
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Card>
      
      <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={setCurrentPage} />
      
      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast(t => ({...t, isOpen: false}))} />
    </div>
  );
}
