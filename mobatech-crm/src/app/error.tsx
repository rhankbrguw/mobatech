"use client";
import { useEffect } from "react";
import { ServerCrash, RefreshCcw, Home } from "lucide-react";
import Link from "next/link";
import { Button } from "@/components/ui/Button";

export default function ErrorPage({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    // Optionally log the error to an error reporting service
    console.error(error);
  }, [error]);

  return (
    <div className="flex items-center justify-center min-h-screen p-4 bg-surface-dark dark:bg-overlay-dark overflow-hidden relative">
      {/* Background Decorators */}
      <div className="absolute top-1/3 right-1/3 w-96 h-96 bg-error/20 rounded-full blur-[120px] animate-pulse" />
      
      <div className="relative max-w-lg w-full animate-fade-in">
        {/* Glow Effects */}
        <div className="absolute -inset-1 bg-gradient-to-r from-error/30 to-error/10 blur-xl opacity-70 rounded-3xl" />
        
        {/* Main Card */}
        <div className="relative glass-panel rounded-3xl border border-glass-border/40 p-10 flex flex-col items-center text-center shadow-2xl backdrop-blur-xl bg-surface-primary/80 dark:bg-overlay-dark/90">
          <div className="relative mb-6">
            <div className="absolute inset-0 bg-error/20 blur-md rounded-full animate-ping" style={{ animationDuration: '2.5s' }} />
            <div className="w-20 h-20 rounded-full bg-gradient-to-tr from-error/20 to-error/5 border border-error/30 flex items-center justify-center relative z-10 shadow-[0_0_20px_rgba(255,0,0,0.15)]">
              <ServerCrash className="w-10 h-10 text-error drop-shadow-md" />
            </div>
          </div>
          
          <h2 className="text-3xl font-extrabold bg-gradient-to-br from-foreground to-foreground/50 bg-clip-text text-transparent mb-3">
            Sistem Mengalami Kendala
          </h2>
          <p className="text-foreground/80 font-medium text-lg mb-2">Internal Error (500)</p>
          <p className="text-sm text-foreground/50 mb-8 max-w-[300px] leading-relaxed">
            Terjadi kesalahan teknis yang tidak terduga pada sistem kami. Jangan khawatir, silakan coba beberapa saat lagi.
          </p>
          
          <div className="flex flex-col sm:flex-row items-center justify-center gap-3 w-full">
            <Button 
              onClick={() => reset()} 
              variant="outline"
              className="w-full sm:w-auto h-12 px-6 rounded-xl border-error/30 text-error hover:bg-error/10 font-bold"
              icon={<RefreshCcw size={18} />}
            >
              Coba Lagi
            </Button>
            <Link 
              href="/dashboard"
              className="flex items-center justify-center gap-2 w-full sm:w-auto h-12 px-6 rounded-xl bg-primary hover:bg-primary/90 text-primary-foreground font-bold transition-all duration-300 hover:-translate-y-1 hover:shadow-[0_10px_20px_-10px_rgba(var(--primary),0.3)]"
            >
              <Home size={18} />
              Dashboard Utama
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
