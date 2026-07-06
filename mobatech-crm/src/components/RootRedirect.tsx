"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { useAuthStore } from "@/store/useAuthStore";
import { Loader2 } from "lucide-react";

export default function RootRedirect() {
  const router = useRouter();
  const token = useAuthStore((state) => state.token);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    useAuthStore.persist.rehydrate();
    setMounted(true);
  }, []);

  useEffect(() => {
    if (!mounted) return;
    
    if (!token) {
      router.replace("/login");
    } else {
      router.replace("/dashboard");
    }
  }, [mounted, token, router]);

  if (!mounted) return null;

  return (
    <div className="flex flex-col items-center gap-4">
      <Loader2 className="h-10 w-10 animate-spin text-primary" />
      <p className="text-muted-foreground text-sm font-medium tracking-wide">
        Mengalihkan...
      </p>
    </div>
  );
}
