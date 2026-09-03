import { APP_STRINGS } from "@/constants";

interface AiOrchestratorCardsProps {
  vectorCount: number | null;
  submitting: boolean;
  onSync: () => void;
}

export function AiOrchestratorCards({ vectorCount, submitting, onSync }: AiOrchestratorCardsProps) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div className="p-6 rounded-2xl border glass-card relative overflow-hidden">
        <div className="absolute top-0 right-0 w-24 h-24 bg-primary/5 rounded-bl-[100px] flex items-center justify-center text-4xl">
          🧠
        </div>
        <p className="text-xs font-semibold text-foreground/50 uppercase tracking-wider">
          {APP_STRINGS.aiOrchestrator.knowledgeBaseSize}
        </p>
        <p className="text-4xl font-extrabold text-foreground mt-2">
          {vectorCount !== null ? `${vectorCount} Vectors` : "Sedang Memuat"}
        </p>
        <p className="text-xs text-foreground/60 mt-2">{APP_STRINGS.aiOrchestrator.knowledgeBaseDesc}</p>
      </div>

      <div className="p-6 rounded-2xl border glass-panel flex flex-col justify-between">
        <div>
          <p className="text-xs font-bold text-foreground/80 uppercase tracking-wider">RAG Database Alignment</p>
          <p className="text-xs text-foreground/60 mt-2">
            Lakukan sinkronisasi database MySQL ke Vector database (FAISS) asisten AI secara manual untuk meregenerasi natural language embeddings.
          </p>
        </div>
        <div className="mt-6">
          <button
            onClick={onSync}
            disabled={submitting}
            className="w-full h-11 bg-primary hover:bg-primary-hover text-primary-foreground font-semibold rounded-xl transition-all duration-200 shadow-md flex items-center justify-center disabled:opacity-50 cursor-pointer"
          >
            {submitting ? APP_STRINGS.aiOrchestrator.manualSyncSubmitting : APP_STRINGS.aiOrchestrator.manualSyncBtn}
          </button>
        </div>
      </div>
    </div>
  );
}
