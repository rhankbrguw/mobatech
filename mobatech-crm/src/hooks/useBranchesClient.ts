import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { adminService } from "@/services";
import { APP_STRINGS } from "@/constants";

export function useBranchesClient(
  qs: string,
  setToast: (toast: { isOpen: boolean; message: string; type: "success" | "error" | "warning" }) => void,
  setDeleteId: (id: number | null) => void
) {
  const queryClient = useQueryClient();

  const { data, isLoading: loading, error } = useQuery({
    queryKey: ["branches", qs],
    queryFn: async () => {
      const res = await adminService.getBranches(qs);
      return res;
    },
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: number) => {
      await adminService.deleteBranch(id);
    },
    onSuccess: () => {
      setToast({ isOpen: true, message: APP_STRINGS.branches.successDelete, type: "success" });
      queryClient.invalidateQueries({ queryKey: ["branches"] });
    },
    onError: (err: Error) => {
      const msg = err.message || APP_STRINGS.login.networkError;
      setToast({ isOpen: true, message: msg, type: "error" });
    },
    onSettled: () => {
      setDeleteId(null);
    },
  });

  return { data, loading, error, deleteMutation };
}
