import { useState, useEffect, useMemo } from "react";
import { api } from "@/lib/api";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { SearchFilterBar } from "@/components/ui/SearchFilterBar";
import { FilterDropdown } from "@/components/ui/FilterDropdown";
import { Pagination } from "@/components/ui/Pagination";
import { PageHeader } from "@/components/ui/PageHeader";
import { StatusPill } from "@/components/StatusPill";
import { SideDrawer } from "@/components/ui/SideDrawer";
import { Pill, CheckCircle, Eye, ChevronRight } from "lucide-react";
import { Prescription } from "@/types/api";
import { Formatters } from "@/lib/formatters";
import { PharmacyPrescriptionRow } from "./PharmacyPrescriptionRow";
import { PrescriptionDetailDrawer } from "./PrescriptionDetailDrawer";
import { APP_STRINGS } from "@/lib/constants";

const TH_CLASS = "align-middle whitespace-nowrap py-3 px-4 text-xs font-bold uppercase tracking-wider text-foreground/50";

export function PharmacyPrescriptions() {
  const [prescriptions, setPrescriptions] = useState<Prescription[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState("");
  const [statusFilter, setStatusFilter] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [toast, setToast] = useState<{isOpen: boolean, message: string, type: "success"|"error"}>({ isOpen: false, message: "", type: "success" });
  const [viewingPrescription, setViewingPrescription] = useState<Prescription | null>(null);

  const load = async () => {
    try {
      const queryParams = new URLSearchParams();
      if (searchQuery) queryParams.append("search", searchQuery);
      if (statusFilter) queryParams.append("status", statusFilter);
      queryParams.append("page", String(currentPage));
      queryParams.append("limit", "10");
      const qs = queryParams.toString() ? `?${queryParams.toString()}` : "";
      const res = await api.get<Prescription[]>(`/api/admin/pharmacy/prescriptions${qs}`);
      setPrescriptions(res.data || []);
      if (res.meta?.total_pages) setTotalPages(res.meta.total_pages);
    } catch (e) {
      console.error(e);
      setToast({ isOpen: true, message: APP_STRINGS.pharmacy.loadError, type: "error" });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { setCurrentPage(1); }, [searchQuery, statusFilter]);
  useEffect(() => { load(); }, [searchQuery, statusFilter, currentPage]);

  const handleProcess = async (id: number) => {
    try {
      await api.put(`/api/admin/pharmacy/prescriptions/${id}/status`, { status: "completed" });
      setToast({ isOpen: true, message: APP_STRINGS.pharmacy.processSuccess, type: "success" });
      setViewingPrescription(null);
      load();
    } catch {
      setToast({ isOpen: true, message: APP_STRINGS.pharmacy.processError, type: "error" });
    }
  };

  const filtered = useMemo(() => {
    return prescriptions.filter(p => {
      const matchSearch = p.doctor_name?.toLowerCase().includes(searchQuery.toLowerCase()) || String(p.id).includes(searchQuery);
      const matchStatus = statusFilter ? p.status === statusFilter : true;
      return matchSearch && matchStatus;
    });
  }, [prescriptions, searchQuery, statusFilter]);

  if (loading) return <div className="p-8 text-center text-foreground/50 animate-pulse text-sm">Memuat E-Resep...</div>;

  return (
    <div className="space-y-6">
      <PageHeader
        title="Antrean E-Resep"
        description="Kelola dan proses resep obat masuk dari dokter ke instalasi farmasi."
      />

      <div className="flex flex-col sm:flex-row justify-end items-center gap-3">
        <FilterDropdown
          value={statusFilter}
          onChange={setStatusFilter}
          options={[
            { label: "Semua Status", value: "" },
            { label: "Pending", value: "pending" },
            { label: "Selesai", value: "completed" }
          ]}
          placeholder="Filter Status"
          className="w-full sm:w-48 h-10"
        />
        <SearchFilterBar 
          value={searchQuery} 
          onChange={setSearchQuery} 
          className="w-full sm:max-w-xs h-10"
          placeholder="Pencarian Dokter atau ID"
        />
      </div>

      <Card noPadding>
        <div className="w-full overflow-x-auto">
        <table className="w-full border-collapse text-sm">
          <thead>
            <tr className="border-b border-glass-border bg-overlay-dark] dark:bg-overlay-light]">
              <th className={`${TH_CLASS} text-center`}>Tanggal</th>
              <th className={`${TH_CLASS} text-center`}>ID Pasien</th>
              <th className={`${TH_CLASS} text-center`}>Dokter</th>
              <th className={`${TH_CLASS} text-center`}>Diagnosa</th>
              <th className={`${TH_CLASS} text-center`}>Status</th>
              <th className={`${TH_CLASS} text-center`}>Aksi</th>
            </tr>
          </thead>
          <tbody>
            {filtered.map(p => (
              <PharmacyPrescriptionRow 
                key={p.id} 
                prescription={p} 
                onView={setViewingPrescription} 
                onProcess={handleProcess} 
              />
            ))}
            {filtered.length === 0 && (
              <tr><td colSpan={6} className="py-12 text-center text-foreground/50">Tidak ada E-Resep saat ini</td></tr>
            )}
          </tbody>
        </table>
      </div>
      </Card>
      <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={setCurrentPage} />

      <PrescriptionDetailDrawer
        prescription={viewingPrescription}
        onClose={() => setViewingPrescription(null)}
        onProcess={handleProcess}
      />

      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast(t => ({...t, isOpen: false}))} />
    </div>
  );
}
