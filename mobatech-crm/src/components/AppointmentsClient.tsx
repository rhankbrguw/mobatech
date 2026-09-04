"use client";

import { useAuthStore } from "@/store/useAuthStore";
import { ForbiddenView } from "@/components/ui/ForbiddenView";

import { useEffect, useState } from "react";
import { APP_STRINGS } from "@/constants";
import { Appointment } from "@/types/api";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card } from "@/components/ui/Card";
import { AppointmentsTable } from "@/components/AppointmentsTable";
import { SearchFilterBar } from "@/components/ui/SearchFilterBar";
import { FilterDropdown } from "@/components/ui/FilterDropdown";
import { ConfirmModal } from "@/components/ConfirmModal";
import { AppointmentDetailView } from "@/components/AppointmentDetailView";
import { Pagination } from "@/components/ui/Pagination";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { adminService } from "@/services";

export function AppointmentsClient({ initialData: _initialData, searchParams: _searchParams }: { initialData?: unknown, searchParams?: Record<string, string | string[] | undefined> }) {
  const user = useAuthStore((state) => state.user);
  const role = user?.role || "admin";
  const queryClient = useQueryClient();

  const [drawerItem, setDrawerItem] = useState<Appointment | null>(null);
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [filterValue, setFilterValue] = useState("");
  const [currentPage, setCurrentPage] = useState(1);

  const [toast, setToast] = useState<{
    isOpen: boolean;
    message: string;
    type: "success" | "error" | "warning";
  }>({ isOpen: false, message: "", type: "success" });

  useEffect(() => {
    setCurrentPage(1);
  }, [searchQuery, filterValue]);

  const q = new URLSearchParams({ page: currentPage.toString(), limit: "10" });
  if (searchQuery) q.append("search", searchQuery);
  if (filterValue) q.append("filter", filterValue);

  const { data, isLoading: loading, error } = useQuery({
    queryKey: ["appointments", `?${q.toString()}`],
    queryFn: async () => {
      const res = await adminService.getAppointments(`?${q.toString()}`);
      return res;
    },
  });

  useEffect(() => {
    if (error) {
      setToast({ isOpen: true, message: APP_STRINGS.login.networkError, type: "error" });
    }
  }, [error]);

  const items = data?.data || [];
  const totalPages = data?.meta?.total_pages || 1;

  const [cancelConfirmId, setCancelConfirmId] = useState<number | null>(null);
  const [processingId, setProcessingId] = useState<number | null>(null);

  const actionMutation = useMutation({
    mutationFn: async ({ id, action }: { id: number; action: string }) => {
      await adminService.actionAppointment(id, action);
    },
    onSuccess: (_, variables) => {
      const msgs: Record<string, string> = { approve: APP_STRINGS.appointments.msgApprove, cancel: APP_STRINGS.appointments.msgCancel, complete: APP_STRINGS.appointments.msgComplete };
      setToast({ isOpen: true, message: msgs[variables.action] || "", type: "success" });
      queryClient.invalidateQueries({ queryKey: ["appointments"] });
    },
    onError: (err: Error) => {
      setToast({ isOpen: true, message: err.message || APP_STRINGS.login.networkError, type: "error" });
    },
    onSettled: (_, __, variables) => {
      if (variables.action === "approve") setProcessingId(null);
      if (variables.action === "cancel") setCancelConfirmId(null);
    }
  });

  const handleApprove = (id: number) => {
    if (processingId) return;
    setProcessingId(id);
    actionMutation.mutate({ id, action: "approve" });
  };
  const executeCancel = (id: number) => actionMutation.mutate({ id, action: "cancel" });
  const handleComplete = (id: number) => actionMutation.mutate({ id, action: "complete" });

  const openDrawer = (item: Appointment) => {
    setDrawerItem(item);
    setIsDrawerOpen(true);
  };

  if (!["admin", "doctor"].includes(role)) {
    return <ForbiddenView />;
  }
  return (
    <div className="space-y-6 animate-slide-in">
      <PageHeader
        title={APP_STRINGS.appointments.title}
        description={APP_STRINGS.appointments.subtitle}
      />

      <div className="w-full flex flex-row items-center justify-between sm:justify-end gap-2 mb-4">
        <FilterDropdown
          value={filterValue}
          onChange={setFilterValue}
          options={[
            { label: 'Hari Ini', value: 'today' },
            { label: 'Besok', value: 'tomorrow' },
          ]}
          placeholder={APP_STRINGS.common.searchSchedule}
          className="flex-1 sm:flex-none sm:w-48 h-11"
        />
        <SearchFilterBar value={searchQuery} onChange={setSearchQuery} className="flex-1 sm:flex-none sm:w-64 h-11" />
      </div>

      <Card noPadding className="overflow-x-auto">
        <AppointmentsTable 
          items={items}
          loading={loading}
          onApprove={handleApprove}
          onCancel={setCancelConfirmId}
          onComplete={handleComplete}
          onViewDetails={openDrawer}
          userRole={role}
        />
      </Card>

      <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={setCurrentPage} />

      <ConfirmModal
        isOpen={cancelConfirmId !== null}
        onClose={() => setCancelConfirmId(null)}
        onConfirm={() => cancelConfirmId !== null && executeCancel(cancelConfirmId)}
        title={APP_STRINGS.appointments.cancelConfirmTitle}
        description={APP_STRINGS.appointments.cancelConfirmDesc}
        confirmText={APP_STRINGS.appointments.cancelConfirmBtn}
        variant="danger"
      />

      <AppointmentDetailView isOpen={isDrawerOpen} onClose={() => setIsDrawerOpen(false)} drawerItem={drawerItem} />

      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast((t) => ({ ...t, isOpen: false }))} />
    </div>
  );
}
