import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { APP_STRINGS } from "@/constants";
import { adminService } from "@/services";

export function useAiOrchestrator() {
  const queryClient = useQueryClient();
  const [toast, setToast] = useState<{
    isOpen: boolean;
    message: string;
    type: "success" | "error" | "warning" | "info";
  }>({ isOpen: false, message: "", type: "success" });

  const { data: statusRes } = useQuery({
    queryKey: ["ragStatus"],
    queryFn: () => adminService.getRagStatus()
  });

  const vectorCount = typeof statusRes?.data?.vector_count === "number" ? statusRes.data.vector_count : null;

  const syncMutation = useMutation({
    mutationFn: () => adminService.syncRag(),
    onSuccess: () => {
      setToast({
        isOpen: true,
        message: APP_STRINGS.aiOrchestrator.syncSuccess,
        type: "success",
      });
      queryClient.invalidateQueries({ queryKey: ["ragStatus"] });
    },
    onError: () => {
      setToast({
        isOpen: true,
        message: APP_STRINGS.aiOrchestrator.syncError,
        type: "error",
      });
    }
  });

  const handleSync = async () => {
    syncMutation.mutate();
  };

  return {
    submitting: syncMutation.isPending,
    toast,
    setToast,
    vectorCount,
    handleSync,
  };
}
