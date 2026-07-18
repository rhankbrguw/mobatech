"use client";
import React, { useState, useEffect } from "react";
import { Prescription } from "@/types/api";
import { api } from "@/lib/api";
import { Check, Inbox, Eye } from "lucide-react";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { APP_STRINGS } from "@/lib/constants";
import { PageHeader } from "@/components/ui/PageHeader";
import { SearchFilterBar } from "@/components/ui/SearchFilterBar";
import { FilterDropdown } from "@/components/ui/FilterDropdown";
import { Pagination } from "@/components/ui/Pagination";
import { useAuthStore } from "@/store/useAuthStore";
import { PrescriptionDetailDrawer } from "./PrescriptionDetailDrawer";
import { PharmacyPrescriptionsTable } from "./PharmacyPrescriptionsTable";
import { RejectPrescriptionModal } from "./RejectPrescriptionModal";

export function PharmacyPrescriptions({ initialPrescriptions }: { initialPrescriptions?: Prescription[] }) {
  const user = useAuthStore((state) => state.user);
  const userRole = user?.role || "admin";
  const [prescriptions, setPrescriptions] = useState<Prescription[]>(initialPrescriptions || []);
  const [loadingId, setLoadingId] = useState<number | null>(null);
  const [selectedPrescription, setSelectedPrescription] = useState<Prescription | null>(null);
  const [toast, setToast] = useState<{isOpen: boolean, message: string, type: "success"|"error"}>({ isOpen: false, message: "", type: "success" });
  const [filterValue, setFilterValue] = useState("all");
  const [searchQuery, setSearchQuery] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [rejectModalOpen, setRejectModalOpen] = useState(false);
  const [rejectPrescriptionId, setRejectPrescriptionId] = useState<number | null>(null);
  const [rejectReason, setRejectReason] = useState("");

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

  const handleUpdateStatus = async (id: number, status: string, notes?: string) => {
    setLoadingId(id);
    try {
      await api.put(`/api/admin/pharmacy/prescriptions/${id}/status`, { status, notes });
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
      Requested: <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-warning-muted text-warning border border-warning-muted">Meminta Ditebus</span>,
      Pending: <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-accent-muted text-accent border border-accent-muted">Menunggu Pasien</span>,
      Redeemed: <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-success-muted text-success border border-success-muted">Selesai</span>,
      Rejected: <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-error-muted text-error border border-error-muted">Ditolak</span>
    };
    return badges[status] || <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-neutral-muted text-neutral border border-neutral-muted">{status}</span>;
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

      <PharmacyPrescriptionsTable 
        prescriptions={prescriptions}
        userRole={userRole}
        loadingId={loadingId}
        getStatusBadge={getStatusBadge}
        setSelectedPrescription={setSelectedPrescription}
        handleUpdateStatus={handleUpdateStatus}
        onRejectRequest={(id) => {
          setRejectPrescriptionId(id);
          setRejectReason("");
          setRejectModalOpen(true);
        }}
      />
      
      <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={setCurrentPage} />
      
      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast(t => ({...t, isOpen: false}))} />
      
      <PrescriptionDetailDrawer
        prescription={selectedPrescription}
        onClose={() => setSelectedPrescription(null)}
        onProcess={(id) => {
          setSelectedPrescription(null);
          handleUpdateStatus(id, "Redeemed");
        }}
      />

      <RejectPrescriptionModal
        isOpen={rejectModalOpen}
        onClose={() => setRejectModalOpen(false)}
        rejectReason={rejectReason}
        setRejectReason={setRejectReason}
        onSubmit={() => {
          if (rejectPrescriptionId !== null && rejectReason.trim()) {
            handleUpdateStatus(rejectPrescriptionId, "Rejected", rejectReason);
            setRejectModalOpen(false);
          } else if (!rejectReason.trim()) {
            setToast({ isOpen: true, message: "Alasan penolakan tidak boleh kosong.", type: "error" });
          }
        }}
      />
    </div>
  );
}
