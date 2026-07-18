import { ShieldAlert, ArrowLeft } from "lucide-react";
import Link from "next/link";

export function ForbiddenView({ message = "Akses Ditolak" }: { message?: string }) {
  return (
    <div className="flex items-center justify-center min-h-[60vh] animate-slide-in p-4">
      <div className="relative max-w-lg w-full">
        {/* Glow Effects */}
        <div className="absolute -inset-1 bg-gradient-to-r from-error/30 to-error/10 blur-xl opacity-70 animate-pulse rounded-3xl" />
        
        {/* Main Card */}
        <div className="relative glass-panel rounded-3xl border border-glass-border/40 p-10 flex flex-col items-center text-center shadow-2xl backdrop-blur-xl bg-surface-primary/80 dark:bg-overlay-dark/90">
          <div className="relative mb-6">
            <div className="absolute inset-0 bg-error/20 blur-md rounded-full animate-ping" />
            <div className="w-20 h-20 rounded-full bg-gradient-to-tr from-error/20 to-error/5 border border-error/30 flex items-center justify-center relative z-10 shadow-[0_0_15px_var(--error-muted)]">
              <ShieldAlert className="w-10 h-10 text-error drop-shadow-md" />
            </div>
          </div>
          
          <h2 className="text-3xl font-extrabold bg-gradient-to-br from-foreground to-foreground/50 bg-clip-text text-transparent mb-3">
            403 Forbidden
          </h2>
          <p className="text-foreground/80 font-medium text-lg mb-2">{message}</p>
          <p className="text-sm text-foreground/50 mb-8 max-w-sm">
            Mohon maaf, Anda tidak memiliki tingkat otorisasi yang cukup (Role Privilege) untuk mengakses area ini.
          </p>
          
          <Link 
            href="/dashboard"
            className="flex items-center justify-center gap-2 w-full max-w-[200px] h-12 rounded-xl bg-primary hover:bg-primary/90 text-primary-foreground font-bold transition-all duration-300 hover:-translate-y-1 shadow-lg hover:shadow-primary/30"
          >
            <ArrowLeft size={18} />
            Kembali
          </Link>
        </div>
      </div>
    </div>
  );
}
