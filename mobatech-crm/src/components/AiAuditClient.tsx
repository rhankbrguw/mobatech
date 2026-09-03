"use client";

import { useAuthStore } from "@/store/useAuthStore";
import { ForbiddenView } from "@/components/ui/ForbiddenView";

import { useState } from "react";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { AiAuditMonitor } from "./AiAuditMonitor";
import { AiAuditChatHistory } from "./AiAuditChatHistory";
import { SearchFilterBar } from "@/components/ui/SearchFilterBar";
import { APP_STRINGS } from "@/constants";
import { PrivacyComplianceBadge } from "./PrivacyComplianceBadge";
import { AiAuditHeader } from "./AiAuditHeader";
import { ConfirmModal } from "./ConfirmModal";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { adminService } from "@/services";

export function AiAuditClient({ initialData: _initialData, searchParams: _searchParams }: { initialData?: unknown, searchParams?: Record<string, string | string[] | undefined> }) {
  const user = useAuthStore((state) => state.user);
  const role = user?.role || "admin";
  const queryClient = useQueryClient();

  const [expandedSession, setExpandedSession] = useState<number | null>(null);
  const [searchQuery, setSearchQuery] = useState("");
  const [showSyncConfirm, setShowSyncConfirm] = useState(false);

  const [toast, setToast] = useState<{
    isOpen: boolean;
    message: string;
    type: "success" | "error" | "warning" | "info";
  }>({
    isOpen: false,
    message: "",
    type: "success",
  });

  const { data: ragStatus, isLoading: loadingStats } = useQuery({
    queryKey: ["ragStatus"],
    queryFn: async () => {
      const res = await adminService.getRagStatus();
      return res.data;
    },
  });

  const { data: sessions = [], isLoading: loadingChats } = useQuery({
    queryKey: ["chatSessions", searchQuery],
    queryFn: async () => {
      const res = await adminService.getChatSessions(searchQuery ? `?search=${encodeURIComponent(searchQuery)}` : "");
      return res.data || [];
    },
  });

  const syncMutation = useMutation({
    mutationFn: async () => {
      const res = await adminService.syncRag();
      if (!res.success) {
        throw new Error(res.message);
      }
      return res;
    },
    onSuccess: () => {
      setToast({ isOpen: true, message: APP_STRINGS.common.ragSyncSuccess, type: "success" });
      queryClient.invalidateQueries({ queryKey: ["ragStatus"] });
    },
    onError: (err) => {
      setToast({ isOpen: true, message: APP_STRINGS.common.ragSyncError + err.message, type: "error" });
    },
  });

  const executeManualSync = () => {
    syncMutation.mutate();
  };

  if (!["admin"].includes(role)) {
    return <ForbiddenView />;
  }
  return (
    <div className="space-y-6 animate-slide-in">
      <AiAuditHeader />

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <AiAuditMonitor
          loadingStats={loadingStats}
          ragStatus={ragStatus || null}
          isSyncing={syncMutation.isPending}
          handleManualSync={() => setShowSyncConfirm(true)}
        />

        <PrivacyComplianceBadge />
      </div>

      <div className="flex justify-end mb-4">
        <SearchFilterBar value={searchQuery} onChange={setSearchQuery} />
      </div>

      <AiAuditChatHistory
        sessions={sessions}
        loadingChats={loadingChats}
        expandedSession={expandedSession}
        setExpandedSession={setExpandedSession}
      />

      <ConfirmModal
        isOpen={showSyncConfirm}
        onClose={() => setShowSyncConfirm(false)}
        onConfirm={() => {
          setShowSyncConfirm(false);
          executeManualSync();
        }}
        title="Bangun Ulang Knowledge Base"
        description="Apakah Anda yakin ingin membangun ulang Vector DB? Ini mungkin membutuhkan waktu beberapa detik."
        confirmText="Mulai Sinkronisasi"
        variant="primary"
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

