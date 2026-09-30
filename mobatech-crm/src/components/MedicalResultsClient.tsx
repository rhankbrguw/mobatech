"use client";
import { useState, useEffect } from "react";
import { useAuthStore } from "@/store/useAuthStore";
import { ForbiddenView } from "@/components/ui/ForbiddenView";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { APP_STRINGS } from "@/constants";
import { DeleteModal } from "@/components/DeleteModal";
import { SideDrawer } from "@/components/ui/SideDrawer";
import { Pagination } from "@/components/ui/Pagination";
import { MedicalResultsTable } from "./MedicalResultsTable";
import { MedicalResultsForm } from "./MedicalResultsForm";
import { MedicalResultsHeader } from "./MedicalResultsHeader";
import { PrescriptionFormModal } from "./pharmacy/PrescriptionFormModal";
import { MedicalResult, Medicine, Prescription } from "@/types/api";
import { useMedicalResultsClient } from "@/hooks/useMedicalResultsClient";

const TEST_TYPES = ["Lab", "Radiologi", "EKG", "USG", "Endoskopi", "Lainnya"];
const defaultForm = { user_id: 0, appointment_id: 0, doctor_name: "", test_type: "Lab", test_name: "", result: "", notes: "", file_url: "", result_date: "" };
export function MedicalResultsClient({ initialData: _initialData, initialMedicines, searchParams }: { initialData?: unknown  , initialMedicines?: unknown, searchParams?: Record<string, string | string[] | undefined> }) {
  const user = useAuthStore((state) => state.user);
  const role = user?.role || "admin";
  const [showForm, setShowForm] = useState(false);
  const [editId, setEditId] = useState<number | null>(null); const [form, setForm] = useState(defaultForm);
  const [searchQuery, setSearchQuery] = useState(""); const [filterValue, setFilterValue] = useState("");
  const [drawerItem, setDrawerItem] = useState<MedicalResult | null>(null); const [isDrawerOpen, setIsDrawerOpen] = useState(false);
  const [prescriptionModalData, setPrescriptionModalData] = useState<MedicalResult | null>(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [toast, setToast] = useState<{ isOpen: boolean; message: string; type: "success" | "error" }>({ isOpen: false, message: "", type: "success" });
  const showToast = (message: string, type: "success" | "error") => setToast({ isOpen: true, message, type });

  useEffect(() => { setCurrentPage(1); }, [searchQuery, filterValue]);

  const queryParams = new URLSearchParams();
  queryParams.append("page", currentPage.toString());
  queryParams.append("limit", "10");
  if (searchQuery) queryParams.append("search", searchQuery);
  if (filterValue) queryParams.append("filter", filterValue);
  const qs = queryParams.toString() ? `?${queryParams.toString()}` : "";

  const [deleteId, setDeleteId] = useState<number | null>(null);

  const { results, totalPages, users, loading, resultsError, usersError, saveMutation, deleteMutation, prescriptionMutation } = useMedicalResultsClient(
    qs,
    setToast,
    setShowForm,
    setForm,
    defaultForm,
    setEditId,
    editId,
    setDeleteId,
    setPrescriptionModalData
  );

  useEffect(() => {
    if (resultsError) showToast(APP_STRINGS.common.medicalResultsLoadFailed, "error");
    if (usersError) showToast(APP_STRINGS.common.userLoadError, "error");
  }, [resultsError, usersError]);

  useEffect(() => { if (searchParams && searchParams.appointment_id) { setForm({ ...defaultForm, appointment_id: Number(searchParams.appointment_id), user_id: searchParams.user_id ? Number(searchParams.user_id) : 0, doctor_name: typeof searchParams.doctor_name === 'string' ? searchParams.doctor_name : "" }); setShowForm(true); } }, [searchParams]);

  const openCreate = () => { setForm(defaultForm); setEditId(null); setShowForm(true); };
  const openEdit = (r: MedicalResult) => { setForm({ user_id: r.user_id, appointment_id: r.appointment_id || 0, doctor_name: r.doctor_name, test_type: r.test_type, test_name: r.test_name, result: r.result, notes: r.notes, file_url: r.file_url, result_date: r.result_date?.slice(0, 10) ?? "" }); setEditId(r.id); setShowForm(true); };

  const handleSave = () => {
    if (!form.user_id || !form.test_name || !form.result_date) {
      showToast("User ID, Nama Tes, dan Tanggal wajib diisi", "error");
      return; }
    const payload = {
      ...form,
      appointment_id: form.appointment_id || undefined,
      result_date: form.result_date.includes("T") ? form.result_date : `${form.result_date}T00:00:00Z`
    };
    saveMutation.mutate(payload);
  };

  const handleDelete = (id: number) => {
    deleteMutation.mutate(id);
  };

  const handleSavePrescription = async (formPayload: Partial<Prescription>) => {
    await prescriptionMutation.mutateAsync(formPayload);
  };

  if (!["admin", "doctor"].includes(role)) return <ForbiddenView />;
  return (
    <div className="space-y-6 animate-slide-in">
      <MedicalResultsHeader
        openCreate={openCreate}
        role={role}
        filterValue={filterValue}
        setFilterValue={setFilterValue}
        searchQuery={searchQuery}
        setSearchQuery={setSearchQuery}
      />
      {showForm && (
        <MedicalResultsForm
          form={form}
          setForm={setForm}
          users={users}
          saving={saveMutation.isPending}
          editId={editId}
          handleSave={handleSave}
          onCancel={() => setShowForm(false)}
          testTypes={TEST_TYPES}
        />
      )}
      <MedicalResultsTable loading={loading} results={results} users={users} onEdit={openEdit} onDelete={setDeleteId} onViewDetails={(item) => { setDrawerItem(item); setIsDrawerOpen(true); }} onCreatePrescription={setPrescriptionModalData} userRole={role} />
      <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={setCurrentPage} />
      <DeleteModal isOpen={deleteId !== null} onClose={() => setDeleteId(null)} onConfirm={() => deleteId !== null && handleDelete(deleteId)} isLoading={deleteMutation.isPending} />
      {prescriptionModalData && (
        <PrescriptionFormModal isOpen={true} onClose={() => setPrescriptionModalData(null)} onSave={handleSavePrescription} initialAppointmentId={prescriptionModalData.appointment_id || 0} initialUserId={prescriptionModalData.user_id || 0} initialDoctorName={prescriptionModalData.doctor_name || ""} initialDiagnosis={prescriptionModalData.result || ""} medicines={(initialMedicines as Medicine[]) || []} showToast={showToast} />
      )}
      <SideDrawer isOpen={isDrawerOpen} onClose={() => setIsDrawerOpen(false)} title="Detail Hasil Medis">
        {drawerItem && (
          <div className="space-y-3">
            <div><strong>Pasien:</strong> {users.find(u => u.id === drawerItem.user_id)?.full_name || `User #${drawerItem.user_id}`}</div>
            <div><strong>Dokter:</strong> {drawerItem.doctor_name || "-"}</div>
            <div><strong>Pemeriksaan:</strong> {drawerItem.test_name} ({drawerItem.test_type})</div>
            <div><strong>Hasil & Catatan:</strong> {drawerItem.result} {drawerItem.notes ? ` - ${drawerItem.notes}` : ""}</div>
            {drawerItem.file_url && <div><strong>Dokumen:</strong> <a href={drawerItem.file_url} target="_blank" rel="noreferrer" className="text-primary hover:underline">Unduh File</a></div>}
          </div>
        )}
      </SideDrawer>
      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast((t) => ({ ...t, isOpen: false }))} />
    </div> ); }
