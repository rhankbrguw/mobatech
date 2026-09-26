import Link from "next/link";
import { Siren, ArrowRight } from "lucide-react";
import { StatusPill } from "@/components/StatusPill";
import { Formatters } from "@/lib/formatters";
import { Emergency } from "@/app/dashboard/types";

interface AdminRecentEmergenciesProps {
  recentEmergencies: Emergency[];
  activeEmergencies: number;
}

function EmergencyItem({ emergency }: { emergency: Emergency }) {
  return (
    <div className="px-5 py-3 flex items-center gap-4 hover:bg-overlay-dark dark:hover:bg-overlay-light transition-colors">
      <div className="w-10 h-10 rounded-xl bg-error-muted flex items-center justify-center text-error flex-shrink-0">
        <Siren size={20} />
      </div>
      <div className="flex-1">
        <div className="text-sm font-semibold">Kasus #{emergency.id}</div>
        <div className="text-xs text-foreground/50">
          {Formatters.date(emergency.created_at, "datetime")}
        </div>
      </div>
      <StatusPill status={emergency.status} />
    </div>
  );
}

export function AdminRecentEmergencies({ recentEmergencies, activeEmergencies }: AdminRecentEmergenciesProps) {
  if (activeEmergencies === 0 && recentEmergencies.length === 0) return null;

  return (
    <div className="glass-panel rounded-2xl border shadow-sm overflow-hidden border-error-muted">
      <div className="flex items-center justify-between px-5 py-4 border-b border-glass-border bg-error-muted">
        <div className="flex items-center gap-2">
          <span className="w-2 h-2 rounded-full bg-error animate-ping inline-block" />
          <h2 className="font-semibold text-sm text-error">Gawat Darurat Terbaru</h2>
        </div>
        <Link href="/dashboard/emergencies" className="text-xs text-error hover:underline font-medium flex items-center gap-1">Lihat Semua <ArrowRight size={14}/></Link>
      </div>
      <div className="divide-y divide-glass-border">
        {recentEmergencies.map((e) => (
          <EmergencyItem key={e.id} emergency={e} />
        ))}
      </div>
    </div>
  );
}
