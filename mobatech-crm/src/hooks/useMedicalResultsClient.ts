import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { adminService, pharmacyService } from "@/services";
import { APP_STRINGS } from "@/constants";
import { MedicalResult, Prescription } from "@/types/api";

type ToastState = { isOpen: boolean; message: string; type: "success" | "error" };
type FormState = { user_id: number; appointment_id: number; doctor_name: string; test_type: string; test_name: string; result: string; notes: string; file_url: string; result_date: string; };

export function useMedicalResultsClient(
  qs: string,
  setToast: (toast: ToastState) => void,
  setShowForm: (val: boolean) => void,
  setForm: (form: FormState) => void,
  defaultForm: FormState,
  setEditId: (id: number | null) => void,
  editId: number | null,
  setDeleteId: (id: number | null) => void,
  setPrescriptionModalData: (data: MedicalResult | null) => void
) {
  const queryClient = useQueryClient();

  const { data: resultsData, isLoading: loading, error: resultsError } = useQuery({
    queryKey: ["medicalResults", qs],
    queryFn: async () => {
      const res = await adminService.getMedicalResults(qs);
      return res;
    }
  });

  const { data: usersData, error: usersError } = useQuery({
    queryKey: ["users", "patient"],
    queryFn: async () => {
      const res = await adminService.getPatients();
      return res.data || [];
    }
  });

  const results = resultsData?.data || [];
  const totalPages = resultsData?.meta?.total_pages || 1;
  const users = usersData || [];

  const saveMutation = useMutation({
    mutationFn: async (payload: Partial<MedicalResult> & { appointment_id?: number | null }) => {
      if (editId) {
        await adminService.updateMedicalResult(editId, payload);
      } else {
        await adminService.createMedicalResult(payload);
        if (payload.appointment_id) {
          try {
            await adminService.actionAppointment(payload.appointment_id, "complete");
          } catch (err) {
            console.warn("Auto-completing appointment after medical result failed:", err);
          }
        }
      }
    },
    onSuccess: () => {
      setToast({ isOpen: true, message: editId ? APP_STRINGS.common.medicalResultsUpdated : APP_STRINGS.common.medicalResultsAdded, type: "success" });
      setShowForm(false);
      setForm(defaultForm);
      setEditId(null);
      queryClient.invalidateQueries({ queryKey: ["medicalResults"] });
    },
    onError: () => {
      setToast({ isOpen: true, message: APP_STRINGS.common.medicalResultsSaveFailed, type: "error" });
    }
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: number) => {
      await adminService.deleteMedicalResult(id);
    },
    onSuccess: () => {
      setToast({ isOpen: true, message: "Data dihapus", type: "success" });
      queryClient.invalidateQueries({ queryKey: ["medicalResults"] });
    },
    onError: () => {
      setToast({ isOpen: true, message: "Gagal menghapus data", type: "error" });
    },
    onSettled: () => {
      setDeleteId(null);
    }
  });

  const prescriptionMutation = useMutation({
    mutationFn: async (formPayload: Partial<Prescription>) => {
      await pharmacyService.createPrescription(formPayload);
    },
    onSuccess: () => {
      setToast({ isOpen: true, message: APP_STRINGS.common.prescribeSuccess || "E-Resep berhasil diterbitkan", type: "success" });
      setPrescriptionModalData(null);
      queryClient.invalidateQueries({ queryKey: ["medicalResults"] });
    },
    onError: () => {
      setToast({ isOpen: true, message: APP_STRINGS.common.prescribeError || "Gagal menerbitkan E-Resep", type: "error" });
    }
  });

  return {
    results,
    totalPages,
    users,
    loading,
    resultsError,
    usersError,
    saveMutation,
    deleteMutation,
    prescriptionMutation
  };
}
