import Link from "next/link";
import { Siren } from "lucide-react";
import { Formatters } from "@/lib/formatters";

interface AdminHeaderProps {
  greeting: string;
  userName?: string;
  activeEmergencies: number;
}

export function AdminHeader({ greeting, userName, activeEmergencies }: AdminHeaderProps) {
  return (
    <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
      <div>
        <p className="text-sm text-foreground/50">{greeting} 👋</p>
        <h2 className="text-2xl font-extrabold tracking-tight text-foreground mt-0.5">
          {userName ?? "Admin"}
        </h2>
        <p className="text-xs text-foreground/50 mt-1">
          {Formatters.date(new Date(), "weekday")}
        </p>
      </div>
      {activeEmergencies > 0 && (
        <Link href="/dashboard/emergencies"
          className="flex items-center gap-2 px-4 py-2 bg-error-muted text-error border border-error-muted rounded-xl text-sm font-semibold hover:bg-error-muted transition-colors">
          <Siren size={16} className="animate-pulse" />
          {activeEmergencies} Darurat Aktif
        </Link>
      )}
    </div>
  );
}
