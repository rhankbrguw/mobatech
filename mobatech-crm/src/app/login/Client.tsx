"use client";

import { useLoginTheme } from "@/hooks/useLoginTheme";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { LoginForm } from "@/components/LoginForm";
import { LoginHeader } from "@/components/login/LoginHeader";

export function LoginClient() {
  const { dark, toggleTheme, toast, setToast, showToast } = useLoginTheme();

  return (
    <div className="flex min-h-screen items-center justify-center bg-background px-4 relative overflow-hidden transition-colors duration-300">
      <div className="absolute -top-40 -left-40 w-96 h-96 bg-primary/20 rounded-full blur-[100px] pointer-events-none" />
      <div className="absolute -bottom-40 -right-40 w-96 h-96 bg-primary/10 rounded-full blur-[100px] pointer-events-none" />

      <button
        onClick={toggleTheme}
        className="absolute top-6 right-6 p-2 rounded-xl border glass-panel hover:bg-overlay-dark dark:hover:bg-overlay-light transition-colors cursor-pointer"
        aria-label="Toggle Theme"
      >
        {dark ? "☀️" : "🌙"}
      </button>

      <main className="w-full max-w-md p-8 rounded-2xl border glass-card animate-slide-in">
        <LoginHeader />
        <LoginForm showToast={showToast} />
      </main>

      <CustomSnackbar
        isOpen={toast.isOpen}
        message={toast.message}
        type={toast.type}
        onClose={() => setToast((t) => ({ ...t, isOpen: false }))}
      />
    </div>
  );
}
