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
    // Log the error to an error reporting service in production
    console.error("Dashboard Error Boundary Caught:", error);
  }, [error]);

  return (
    <div className="w-full h-[60vh] flex flex-col items-center justify-center animate-slide-in p-6">
      <Card className="max-w-md w-full flex flex-col items-center text-center p-8 border-rose-500/20 bg-rose-500/5">
        <div className="w-16 h-16 bg-rose-500/10 text-rose-500 flex items-center justify-center rounded-full mb-4">
          <AlertCircle size={32} />
        </div>
        <h2 className="text-xl font-bold mb-2">Terjadi Kesalahan</h2>
        <p className="text-sm text-foreground/60 mb-6">
          Maaf, terjadi kesalahan saat memuat halaman ini. Silakan coba lagi atau hubungi dukungan teknis jika masalah berlanjut.
        </p>
        <Button onClick={() => reset()} variant="primary" className="w-full justify-center">
          Coba Lagi
        </Button>
      </Card>
    </div>
  );
}
