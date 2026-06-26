"use client";

import { useState, useEffect } from "react";
import { api } from "@/lib/api";
import { CustomSnackbar } from "@/components/CustomSnackbar";

interface RagStatus {
  status: string;
  vector_count: number;
  knowledge_base_size: number;
}

interface ChatMessage {
  id: number;
  role: "user" | "model";
  content: string;
  created_at: string;
}

interface ChatSession {
  id: number;
  user_id: string;
  title: string;
  updated_at: string;
  Messages: ChatMessage[];
}

export default function AiAuditPage() {
  const [ragStatus, setRagStatus] = useState<RagStatus | null>(null);
  const [sessions, setSessions] = useState<ChatSession[]>([]);
  const [loadingStats, setLoadingStats] = useState(true);
  const [loadingChats, setLoadingChats] = useState(true);
  const [isSyncing, setIsSyncing] = useState(false);
  const [expandedSession, setExpandedSession] = useState<number | null>(null);

  const [toast, setToast] = useState<{
    isOpen: boolean;
    message: string;
    type: "success" | "error" | "warning" | "info";
  }>({
    isOpen: false,
    message: "",
    type: "success",
  });

  const loadStatus = async () => {
    try {
      setLoadingStats(true);
      const res = await api.get<RagStatus>("/api/admin/rag/status");
      setRagStatus(res.data);
    } catch (err) {
      setToast({ isOpen: true, message: "Gagal mengambil status RAG Engine", type: "error" });
    } finally {
      setLoadingStats(false);
    }
  };

  const loadChats = async () => {
    try {
      setLoadingChats(true);
      const res = await api.get<ChatSession[]>("/api/admin/chats");
      setSessions(res.data || []);
    } catch (err) {
      setToast({ isOpen: true, message: "Gagal memuat histori chat", type: "error" });
    } finally {
      setLoadingChats(false);
    }
  };

  useEffect(() => {
    loadStatus();
    loadChats();
  }, []);

  const handleManualSync = async () => {
    const confirmSync = confirm("Apakah Anda yakin ingin membangun ulang Vector DB? Ini mungkin membutuhkan waktu beberapa detik.");
    if (!confirmSync) return;

    try {
      setIsSyncing(true);
      const res = await api.post<{ status: string; message: string }>("/api/admin/rag/sync", {});
      if (res.data.status === "success") {
        setToast({ isOpen: true, message: "Sinkronisasi berhasil! Knowledge Base telah diperbarui.", type: "success" });
        loadStatus();
      } else {
        throw new Error(res.data.message);
      }
    } catch (err) {
      setToast({ isOpen: true, message: "Gagal melakukan sinkronisasi: " + (err as Error).message, type: "error" });
    } finally {
      setIsSyncing(false);
    }
  };

  return (
    <div className="space-y-6 animate-slide-in">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold tracking-tight">AI Orchestrator Dashboard</h1>
          <p className="text-foreground/60 text-xs mt-1">
            Pusat kendali dan audit untuk AI Chatbot (GPT-5) dan *Retrieval-Augmented Generation* (RAG).
          </p>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Knowledge Base Monitor */}
        <div className="rounded-2xl border glass-panel p-6 shadow-sm">
          <h2 className="text-lg font-semibold mb-4">Knowledge Base Monitor</h2>
          {loadingStats ? (
            <div className="animate-pulse flex space-x-4">
              <div className="h-4 bg-foreground/10 rounded w-3/4"></div>
            </div>
          ) : ragStatus ? (
            <div className="space-y-4">
              <div className="flex justify-between items-center border-b border-glass-border pb-2">
                <span className="text-foreground/70">Status Engine</span>
                <span className="px-2 py-1 bg-green-500/10 text-green-600 rounded-md text-xs font-semibold capitalize">
                  {ragStatus.status}
                </span>
              </div>
              <div className="flex justify-between items-center border-b border-glass-border pb-2">
                <span className="text-foreground/70">Vector DB Count</span>
                <span className="font-medium text-lg">{ragStatus.vector_count} <span className="text-xs text-foreground/50">vectors</span></span>
              </div>
              <div className="flex justify-between items-center border-b border-glass-border pb-2">
                <span className="text-foreground/70">Medical Knowledge Size</span>
                <span className="font-medium text-lg">{ragStatus.knowledge_base_size} <span className="text-xs text-foreground/50">documents</span></span>
              </div>
            </div>
          ) : (
            <div className="text-rose-500 text-sm">Python AI Engine tidak merespon / Offline.</div>
          )}

          <div className="mt-6">
            <button
              onClick={handleManualSync}
              disabled={isSyncing}
              className="w-full bg-primary hover:bg-primary-hover text-primary-foreground py-3 rounded-xl font-medium transition-colors disabled:opacity-50 flex justify-center items-center gap-2"
            >
              {isSyncing ? "Menyinkronkan..." : "Sinkronisasi Manual (Rebuild DB)"}
            </button>
            <p className="text-xs text-foreground/50 mt-2 text-center">
              Gunakan jika Anda baru saja menambah Jadwal/Poli baru agar AI mengetahuinya.
            </p>
          </div>
        </div>

        <div className="rounded-2xl border glass-panel p-6 shadow-sm flex flex-col justify-center items-center text-center">
          <div className="w-20 h-20 bg-primary/10 text-primary rounded-full flex items-center justify-center mb-4">
            <span className="text-3xl">🛡️</span>
          </div>
          <h3 className="font-semibold text-lg">Privacy & PDP Compliant</h3>
          <p className="text-sm text-foreground/60 mt-2 max-w-sm">
            Sistem AI menggunakan Anonymization Engine di mana informasi pribadi pasien disamarkan sebelum diakses oleh Model LLM, sesuai dengan hukum Perlindungan Data Pribadi.
          </p>
        </div>
      </div>

      <div className="mt-8">
        <h2 className="text-lg font-semibold mb-4">Chat History & Audit (Anonymized)</h2>
        <div className="rounded-2xl border glass-panel overflow-hidden shadow-sm">
          {loadingChats ? (
             <div className="p-8 text-center text-foreground/50 animate-pulse text-sm">Memuat riwayat chat...</div>
          ) : sessions.length === 0 ? (
            <div className="p-8 text-center text-foreground/50">Tidak ada riwayat chat.</div>
          ) : (
            <div className="divide-y divide-glass-border">
              {sessions.map((session) => (
                <div key={session.id} className="bg-black/5 dark:bg-white/5">
                  <div 
                    className="p-4 flex justify-between items-center cursor-pointer hover:bg-black/10 dark:hover:bg-white/10 transition-colors"
                    onClick={() => setExpandedSession(expandedSession === session.id ? null : session.id)}
                  >
                    <div>
                      <div className="font-semibold text-primary">{session.title || "Percakapan Baru"}</div>
                      <div className="text-xs text-foreground/50 mt-1">
                        Sesi ID: {session.id} • Terakhir aktif: {new Date(session.updated_at).toLocaleDateString("id-ID", { day: "2-digit", month: "short", year: "numeric", hour: "2-digit", minute: "2-digit" })}
                      </div>
                    </div>
                    <div className="text-foreground/50 text-sm">
                      {expandedSession === session.id ? "Tutup" : "Lihat Detail"}
                    </div>
                  </div>
                  
                  {expandedSession === session.id && (
                    <div className="p-4 bg-background">
                      <div className="space-y-4 max-h-[400px] overflow-y-auto pr-2">
                        {session.Messages?.length > 0 ? (
                          session.Messages.map((msg) => (
                            <div key={msg.id} className={`flex flex-col ${msg.role === 'user' ? 'items-end' : 'items-start'}`}>
                              <span className="text-[10px] text-foreground/40 mb-1 ml-1 uppercase">{msg.role === 'user' ? 'Pasien (Anonymized)' : 'AI Assistant'}</span>
                              <div className={`p-3 rounded-2xl max-w-[80%] text-sm ${msg.role === 'user' ? 'bg-primary text-primary-foreground rounded-tr-sm' : 'bg-black/5 dark:bg-white/10 text-foreground rounded-tl-sm'}`}>
                                {msg.content}
                              </div>
                            </div>
                          ))
                        ) : (
                          <div className="text-sm text-center text-foreground/50">Sesi ini kosong.</div>
                        )}
                      </div>
                    </div>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      <CustomSnackbar
        isOpen={toast.isOpen}
        message={toast.message}
        type={toast.type}
        onClose={() => setToast((t) => ({ ...t, isOpen: false }))}
      />
    </div>
  );
}
