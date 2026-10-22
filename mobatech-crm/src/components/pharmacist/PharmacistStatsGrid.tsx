import { Pill, AlertTriangle, CheckCircle } from "lucide-react";

interface PharmacistStatsGridProps {
  stats: {
    pendingPrescriptions: number;
    totalMeds: number;
    lowStock: number;
    loading: boolean;
  };
}

export function PharmacistStatsGrid({ stats }: PharmacistStatsGridProps) {
  return (
    <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
      <div className="group relative glass-panel p-5 rounded-2xl border border-glass-border shadow-sm bg-info-muted overflow-hidden">
        <div className="absolute -top-6 -right-6 w-24 h-24 rounded-full bg-info opacity-5 group-hover:opacity-10 transition-opacity duration-300" />
        <div className="flex justify-between items-start mb-2 relative z-10">
          <div>
            <p className="text-xs font-semibold text-foreground/50 uppercase tracking-wider">Antrean E-Resep</p>
            <h2 className="text-3xl font-extrabold text-info mt-1">{stats.loading ? "..." : stats.pendingPrescriptions}</h2>
          </div>
          <div className="p-2 bg-info-muted text-info rounded-xl"><Pill size={20} /></div>
        </div>
      </div>

      <div className="group relative glass-panel p-5 rounded-2xl border border-glass-border shadow-sm overflow-hidden">
        <div className="absolute -top-6 -right-6 w-24 h-24 rounded-full bg-accent opacity-5 group-hover:opacity-10 transition-opacity duration-300" />
        <div className="flex justify-between items-start mb-2 relative z-10">
          <div>
            <p className="text-xs font-semibold text-foreground/50 uppercase tracking-wider">Katalog Obat</p>
            <h2 className="text-3xl font-extrabold text-foreground mt-1">{stats.loading ? "..." : stats.totalMeds}</h2>
          </div>
          <div className="p-2 bg-accent-muted text-accent rounded-xl"><CheckCircle size={20} /></div>
        </div>
      </div>

      <div className="group relative glass-panel p-5 rounded-2xl border border-glass-border shadow-sm bg-error-muted overflow-hidden">
        <div className="absolute -top-6 -right-6 w-24 h-24 rounded-full bg-error opacity-5 group-hover:opacity-10 transition-opacity duration-300" />
        <div className="flex justify-between items-start mb-2 relative z-10">
          <div>
            <p className="text-xs font-semibold text-foreground/50 uppercase tracking-wider">Stok Kritis</p>
            <h2 className="text-3xl font-extrabold text-error mt-1">{stats.loading ? "..." : stats.lowStock}</h2>
          </div>
          <div className="p-2 bg-error-muted text-error rounded-xl"><AlertTriangle size={20} /></div>
        </div>
      </div>
    </div>
  );
}
