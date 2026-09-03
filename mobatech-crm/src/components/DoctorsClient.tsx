"use client";
import { useAuthStore } from "@/store/useAuthStore";
import { ForbiddenView } from "@/components/ui/ForbiddenView";
import { useEffect, useState } from "react";
import { APP_STRINGS } from "@/constants";
import { Doctor } from "@/types/api";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { DoctorFormModal } from "@/components/DoctorFormModal";
import { ScheduleModal } from "@/components/ScheduleModal";
import { DeleteModal } from "@/components/DeleteModal";
import { DoctorsHeader } from "./DoctorsHeader";
import { DoctorsContent } from "./DoctorsContent";
import { Pagination } from "@/components/ui/Pagination";
import { DoctorDetailView } from "./DoctorDetailView";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { doctorService, polyclinicService } from "@/services";

export function DoctorsClient({ searchParams: _searchParams }: { initialData?: unknown, searchParams?: Record<string, string | string[] | undefined> }) {
  const user = useAuthStore((state) => state.user);
  const role = user?.role || "admin";
  const queryClient = useQueryClient();

  const [activeTab, setActiveTab] = useState<"doctors" | "schedules">("doctors");
  const [showFormModal, setShowFormModal] = useState(false);
  const [showSchedModal, setShowSchedModal] = useState(false);
  const [selectedItem, setSelectedItem] = useState<Doctor | null>(null);
  const [drawerItem, setDrawerItem] = useState<Doctor | null>(null);
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [filterValue, setFilterValue] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [toast, setToast] = useState<{ isOpen: boolean; message: string; type: "success" | "error" | "warning"; }>({ isOpen: false, message: "", type: "success" });

  useEffect(() => { setCurrentPage(1); }, [searchQuery, filterValue]);

  const qs = new URLSearchParams({ page: currentPage.toString(), limit: "10" });
  if (searchQuery) qs.append("search", searchQuery);
  if (filterValue) qs.append("filter", filterValue);
  const qsStr = `?${qs.toString()}`;

  const { data: polyclinicsData } = useQuery({
    queryKey: ["polyclinics"],
    queryFn: async () => {
      const res = await polyclinicService.getPolyclinics();
      return res.data || [];
    },
  });
  const polyclinics = polyclinicsData || [];

  const { data: docsData, isLoading: loadingDocs } = useQuery({
    queryKey: ["doctors", qsStr],
    queryFn: async () => {
      const res = await doctorService.getDoctors(qsStr);
      return res;
    },
    refetchInterval: 5000,
  });

  const { data: schedsData, isLoading: loadingScheds } = useQuery({
    queryKey: ["schedules"],
    queryFn: async () => {
      const res = await doctorService.getAllSchedules("?limit=200");
      return res.data || [];
    },
    refetchInterval: 5000,
  });

  const loading = loadingDocs || loadingScheds;
  
  let items = docsData?.data || [];
  if (user?.role === "doctor") items = items.filter((d) => d.user_id === user.id);
  const totalPages = docsData?.meta?.total_pages || 1;

  const docIds = items.map((d) => d.id);
  const schedules = (schedsData || []).filter((s) => docIds.includes(s.doctor_id));

  const openForm = (item: Doctor | null = null) => { setSelectedItem(item); setShowFormModal(true); };
  const openDrawer = (item: Doctor) => { setDrawerItem(item); setIsDrawerOpen(true); };
  const openSchedules = (item: Doctor) => { setSelectedItem(item); setShowSchedModal(true); };

  const saveMutation = useMutation({
    mutationFn: async (payload: Partial<Doctor>) => {
      if (selectedItem) {
        await doctorService.updateDoctor(selectedItem.id, payload);
      } else {
        await doctorService.createDoctor(payload);
      }
    },
    onSuccess: () => {
      setToast({ isOpen: true, message: selectedItem ? APP_STRINGS.doctors.successUpdate : APP_STRINGS.doctors.successCreate, type: "success" });
      queryClient.invalidateQueries({ queryKey: ["doctors"] });
      setShowFormModal(false);
    },
    onError: (err: Error) => {
      setToast({ isOpen: true, message: err.message || APP_STRINGS.login.networkError, type: "error" });
    }
  });

  const handleSave = async (payload: { name: string; specialization: string; polyclinic_id?: number; contact_info: string; description: string; image_url: string; is_active: boolean; email?: string; }) => {
    await saveMutation.mutateAsync(payload);
  };

  const [deleteId, setDeleteId] = useState<number | null>(null);

  const deleteMutation = useMutation({
    mutationFn: async (id: number) => {
      await doctorService.deleteDoctor(id);
    },
    onSuccess: () => {
      setToast({ isOpen: true, message: APP_STRINGS.doctors.successDelete, type: "success" });
      queryClient.invalidateQueries({ queryKey: ["doctors"] });
    },
    onError: (err: Error) => {
      setToast({ isOpen: true, message: err.message || APP_STRINGS.login.networkError, type: "error" });
    },
    onSettled: () => setDeleteId(null)
  });

  const handleDelete = (id: number) => {
    deleteMutation.mutate(id);
  };

  if (!["admin", "doctor"].includes(role)) return <ForbiddenView />;

  return (
    <div className="space-y-6 animate-slide-in">
      <DoctorsHeader
        openForm={() => openForm(null)} activeTab={activeTab} setActiveTab={setActiveTab}
        filterValue={filterValue} setFilterValue={setFilterValue} searchQuery={searchQuery}
        setSearchQuery={setSearchQuery} polyclinicOptions={polyclinics.map((p) => ({ label: p.name, value: p.name }))}
      />
      <DoctorsContent
        activeTab={activeTab} items={items} loading={loading} openSchedules={openSchedules}
        openForm={openForm} setDeleteId={setDeleteId} onViewDetails={openDrawer} schedules={schedules}
      />
      {activeTab === "doctors" && user?.role !== "doctor" && (
        <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={setCurrentPage} />
      )}
      <DoctorFormModal isOpen={showFormModal} onClose={() => setShowFormModal(false)} doctor={selectedItem} onSave={handleSave} showToast={(msg, type) => setToast({ isOpen: true, message: msg, type })} />
      <ScheduleModal isOpen={showSchedModal} onClose={() => setShowSchedModal(false)} doctor={selectedItem} onChange={() => queryClient.invalidateQueries({ queryKey: ["schedules"] })} />
      <DeleteModal
        isOpen={deleteId !== null} onClose={() => setDeleteId(null)}
        onConfirm={() => deleteId !== null && handleDelete(deleteId)} isLoading={deleteMutation.isPending}
      />
      <DoctorDetailView isOpen={isDrawerOpen} onClose={() => setIsDrawerOpen(false)} drawerItem={drawerItem} />
      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast((t) => ({ ...t, isOpen: false }))} />
    </div>
  );
}
