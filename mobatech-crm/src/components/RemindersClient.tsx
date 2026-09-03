"use client";
import { useAuthStore } from "@/store/useAuthStore"; import { ForbiddenView } from "@/components/ui/ForbiddenView";
import { useState, useEffect } from "react"; import { CustomSnackbar } from "@/components/CustomSnackbar";
import { PageHeader } from "@/components/ui/PageHeader"; import { Button } from "@/components/ui/Button"; import { Plus, X } from "lucide-react";
import { SearchFilterBar } from "@/components/ui/SearchFilterBar"; import { FilterDropdown } from "@/components/ui/FilterDropdown";
import { Pagination } from "@/components/ui/Pagination"; import { RemindersForm } from "./RemindersForm"; import { RemindersList } from "./RemindersList";
import { ConfirmModal } from "@/components/ConfirmModal";
import { APP_STRINGS } from "@/constants"; import { Formatters } from "@/lib/formatters";
import { useRemindersClient } from "@/hooks/useRemindersClient";

const REMINDER_TYPES = ["Appointment", "Medication", "Checkup", "General"];
const defaultForm = { user_id: 0, appointment_id: 0, title: "", message: "", reminder_date: "", type: "General" };
export function RemindersClient({ initialData: _initialData, searchParams: _searchParams }: { initialData?: unknown, searchParams?: Record<string, string | string[] | undefined> }) {
  const user = useAuthStore((state) => state.user);
  const role = user?.role || "admin";

  const [showForm, setShowForm] = useState(false);
  const [form, setForm] = useState(defaultForm);
  const [searchQuery, setSearchQuery] = useState("");
  const [filterValue, setFilterValue] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [toast, setToast] = useState<{ isOpen: boolean; message: string; type: "success" | "error" }>({ isOpen: false, message: "", type: "success" });
  const showToast = (message: string, type: "success" | "error") =>
    setToast({ isOpen: true, message, type });

  useEffect(() => { setCurrentPage(1); }, [searchQuery, filterValue]);

  const queryParams = new URLSearchParams();
  if (searchQuery) queryParams.append("search", searchQuery);
  if (filterValue) queryParams.append("filter", filterValue);
  queryParams.append("page", String(currentPage));
  queryParams.append("limit", "10");
  const qs = queryParams.toString() ? `?${queryParams.toString()}` : "";

  const [deleteConfirmId, setDeleteConfirmId] = useState<number | null>(null);

  const { users, reminders, totalPages, loading, createMutation, deleteMutation } = useRemindersClient(
    qs,
    setToast,
    setShowForm,
    setForm,
    defaultForm,
    setDeleteConfirmId
  );

  const handleCreate = () => {
    if (!form.user_id || !form.title || !form.reminder_date) {
      showToast(APP_STRINGS.common.validationReminderFields, "error");
      return;
    }
    const isoDate = form.reminder_date.includes(":") && form.reminder_date.length === 16
      ? form.reminder_date + ":00+07:00"
      : form.reminder_date;
    createMutation.mutate({ ...form, reminder_date: isoDate });
  };

  const executeDelete = (id: number) => {
    deleteMutation.mutate(id);
  };
  
  if (!["admin"].includes(role)) {
    return <ForbiddenView />;
  }
  return (
    <div className="space-y-6 animate-slide-in">
      <PageHeader
        title="Pengingat Pasien"
        description="Kirim notifikasi / pengingat ke pasien terdaftar."
        action={
          <Button onClick={() => {
            if (!showForm) {
              setForm({ ...defaultForm, reminder_date: Formatters.currentLocalDatetimeInput() });
            }
            setShowForm(!showForm);
          }} variant={showForm ? "outline" : "primary"} icon={showForm ? <X size={18} /> : <Plus size={18} />}>
            {showForm ? "Batal" : "Kirim Reminder Baru"}
          </Button>
        }
      />
      <div className="flex justify-end mb-4 gap-2">
        <FilterDropdown
          value={filterValue}
          onChange={setFilterValue}
          options={[
            { label: 'Semua Tipe', value: '' },
            { label: 'Janji Temu', value: 'Appointment' },
            { label: 'Obat', value: 'Medication' },
            { label: 'Checkup', value: 'Checkup' },
            { label: 'Umum', value: 'General' },
          ]}
          placeholder={APP_STRINGS.common.searchType}
        />
        <SearchFilterBar value={searchQuery} onChange={setSearchQuery} />
      </div>
      {showForm && (
        <RemindersForm
          form={form}
          setForm={setForm}
          users={users}
          saving={createMutation.isPending}
          handleCreate={handleCreate}
          reminderTypes={REMINDER_TYPES}
        />
      )}
      <RemindersList
        loading={loading}
        reminders={reminders}
        users={users}
        onDelete={setDeleteConfirmId}
      />
      <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={setCurrentPage} />
      <ConfirmModal
        isOpen={deleteConfirmId !== null}
        onClose={() => setDeleteConfirmId(null)}
        onConfirm={() => deleteConfirmId !== null && executeDelete(deleteConfirmId)}
        title="Hapus Pengingat"
        description="Apakah Anda yakin ingin menghapus pengingat ini? Aksi ini tidak dapat dikembalikan."
        confirmText="Ya, Hapus"
        variant="danger"
      />
      <CustomSnackbar
        isOpen={toast.isOpen}
        message={toast.message}
        type={toast.type}
        onClose={() => setToast((t) => ({ ...t, isOpen: false }))}
      />
    </div>
  );
}
