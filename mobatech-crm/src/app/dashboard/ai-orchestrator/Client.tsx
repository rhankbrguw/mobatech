"use client";

import { useAiOrchestrator } from "@/hooks/useAiOrchestrator";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { AiOrchestratorHeader } from "@/components/ai-orchestrator/AiOrchestratorHeader";
import { AiOrchestratorCards } from "@/components/ai-orchestrator/AiOrchestratorCards";

export default function AIOrchestratorPage() {
  const { submitting, toast, setToast, vectorCount, handleSync } = useAiOrchestrator();

  return (
    <div className="space-y-6 animate-slide-in">
      <AiOrchestratorHeader />
      <AiOrchestratorCards vectorCount={vectorCount} submitting={submitting} onSync={handleSync} />
      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast((t) => ({ ...t, isOpen: false }))} />
    </div>
  );
}
