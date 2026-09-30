import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { adminService } from "@/services";
import { APP_STRINGS } from "@/constants";
import { Formatters } from "@/lib/formatters";
import { Reminder } from "@/types/api";

type ToastState = { isOpen: boolean; message: string; type: "success" | "error" };
type ReminderForm = { user_id: number; appointment_id: number; title: string; message: string; reminder_date: string; type: string; };

export function useRemindersClient(
  qs: string,
  setToast: (toast: ToastState) => void,
  setShowForm: (val: boolean) => void,
  setForm: (form: ReminderForm) => void,
  defaultForm: ReminderForm,
  setDeleteConfirmId: (id: number | null) => void
) {
  const queryClient = useQueryClient();

  const { data: usersData } = useQuery({
    queryKey: ["users", "patient"],
    queryFn: async () => {
      const res = await adminService.getPatients();
      return res.data || [];
    }
  });
  const users = usersData || [];

  const { data: remindersData, isLoading: loading } = useQuery({
    queryKey: ["reminders", qs],
    queryFn: async () => {
      const res = await adminService.getReminders(qs);
      return res;
    }
  });
  const reminders = remindersData?.data || [];
  const totalPages = remindersData?.meta?.total_pages || 1;

  const createMutation = useMutation({
    mutationFn: async (payload: Partial<Reminder>) => {
      await adminService.createReminder(payload);
    },
    onSuccess: () => {
      setToast({ isOpen: true, message: APP_STRINGS.common.reminderSendSuccess, type: "success" });
      setShowForm(false);
      setForm({ ...defaultForm, reminder_date: Formatters.currentLocalDatetimeInput() });
      queryClient.invalidateQueries({ queryKey: ["reminders"] });
    },
    onError: () => {
      setToast({ isOpen: true, message: APP_STRINGS.common.reminderCreateError, type: "error" });
    }
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: number) => {
      await adminService.deleteReminder(id);
    },
    onSuccess: () => {
      setToast({ isOpen: true, message: APP_STRINGS.common.reminderDeleteSuccess, type: "success" });
      queryClient.invalidateQueries({ queryKey: ["reminders"] });
    },
    onError: () => {
      setToast({ isOpen: true, message: APP_STRINGS.common.reminderDeleteError, type: "error" });
    },
    onSettled: () => {
      setDeleteConfirmId(null);
    }
  });

  return {
    users,
    reminders,
    totalPages,
    loading,
    createMutation,
    deleteMutation
  };
}
