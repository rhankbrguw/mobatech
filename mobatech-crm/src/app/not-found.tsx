import { FileQuestion, ArrowLeft } from "lucide-react";
import Link from "next/link";

export default function NotFound() {
  return (
    <div className="flex items-center justify-center min-h-screen p-4 bg-surface-dark dark:bg-overlay-dark overflow-hidden relative">
      {/* Background Decorators */}
      <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-primary/20 rounded-full blur-[100px] animate-pulse" />
      <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-error/10 rounded-full blur-[100px] animate-pulse" style={{ animationDelay: '2s' }} />
      
      <div className="relative max-w-lg w-full animate-slide-up">
        {/* Glow Effects */}
        <div className="absolute -inset-1 bg-gradient-to-r from-primary/30 to-teal/30 blur-xl opacity-70 rounded-3xl" />
        
        {/* Main Card */}
        <div className="relative glass-panel rounded-3xl border border-glass-border/40 p-12 flex flex-col items-center text-center shadow-2xl backdrop-blur-xl bg-surface-primary/80 dark:bg-overlay-dark/90">
          <div className="relative mb-6">
            <div className="absolute inset-0 bg-primary/20 blur-md rounded-full animate-ping" style={{ animationDuration: '3s' }} />
            <div className="w-24 h-24 rounded-full bg-gradient-to-tr from-primary/20 to-primary/5 border border-primary/30 flex items-center justify-center relative z-10 shadow-[0_0_20px_rgba(var(--primary),0.2)]">
              <FileQuestion className="w-12 h-12 text-primary drop-shadow-lg" />
            </div>
          </div>
          
          <h2 className="text-4xl font-extrabold bg-gradient-to-br from-foreground to-foreground/50 bg-clip-text text-transparent mb-4">
            404
          </h2>
          <p className="text-foreground/90 font-bold text-xl mb-3">Halaman Tidak Ditemukan</p>
          <p className="text-sm text-foreground/50 mb-10 max-w-[280px] leading-relaxed">
            Sepertinya Anda tersesat di dalam sistem. Halaman atau URL yang Anda tuju tidak tersedia.
          </p>
          
          <Link 
            href="/dashboard"
            className="flex items-center justify-center gap-2 w-full h-14 rounded-xl bg-primary hover:bg-primary/90 text-primary-foreground font-bold transition-all duration-300 hover:-translate-y-1 hover:shadow-[0_15px_30px_-10px_rgba(var(--primary),0.4)]"
          >
            <ArrowLeft size={20} />
            Kembali ke Dashboard
          </Link>
        </div>
      </div>
    </div>
  );
}
