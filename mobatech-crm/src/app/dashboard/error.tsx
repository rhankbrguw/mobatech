"use client";

import { useEffect } from "react";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { AlertCircle } from "lucide-react";

export default function DashboardError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    /* ignored */
  }, [error]);
  const handleForceLogout = async () => {
    try {
      await fetch("/api/auth/logout", { method: "POST" });
    } catch (e) { /* ignored */ }
    localStorage.removeItem("hermina-crm-auth");
    window.location.href = "/login";
  };

  return (
    <div className="w-full h-[60vh] flex flex-col items-center justify-center animate-slide-in p-6">
      <Card className="max-w-md w-full flex flex-col items-center text-center p-8 border-error-muted bg-error-muted">
        <div className="w-16 h-16 bg-error-muted text-error flex items-center justify-center rounded-full mb-4">
          <AlertCircle size={32} />
        </div>
        <h2 className="text-xl font-bold mb-2">Sesi Tidak Valid atau Kedaluwarsa</h2>
        <p className="text-sm text-foreground/60 mb-6">
          Maaf, terjadi kesalahan akses (kemungkinan besar karena token lama setelah database di-reset). Silakan coba lagi atau reset sesi Anda.
        </p>
        <div className="w-full space-y-3">
          <Button onClick={() => reset()} variant="primary" className="w-full justify-center">
            Coba Lagi
          </Button>
          <Button onClick={handleForceLogout} variant="outline" className="w-full justify-center text-error border-error-muted hover:bg-error-muted">
            Logout & Reset Sesi
          </Button>
        </div>
      </Card>
    </div>
  );
}

