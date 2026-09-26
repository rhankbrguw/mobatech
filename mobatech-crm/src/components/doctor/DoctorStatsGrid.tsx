import { Clock, CheckCircle, CalendarDays } from "lucide-react";

interface DoctorStatsGridProps {
  stats: {
    pending: number;
    completed: number;
    today: number;
    loading: boolean;
  };
}

export function DoctorStatsGrid({ stats }: DoctorStatsGridProps) {
  return (
    <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
      <div className="group relative glass-panel p-5 rounded-2xl border border-glass-border shadow-sm overflow-hidden">
        <div className="absolute -top-6 -right-6 w-24 h-24 rounded-full bg-accent opacity-5 group-hover:opacity-10 transition-opacity duration-300" />
        <div className="flex justify-between items-start mb-2 relative z-10">
          <div>
            <p className="text-xs font-semibold text-foreground/50 uppercase tracking-wider">Total Antrean</p>
            <h2 className="text-3xl font-extrabold text-foreground mt-1">{stats.loading ? "..." : stats.today}</h2>
          </div>
          <div className="p-2 bg-accent-muted text-accent rounded-xl"><CalendarDays size={20} /></div>
        </div>
      </div>

      <div className="group relative glass-panel p-5 rounded-2xl border border-glass-border shadow-sm overflow-hidden">
        <div className="absolute -top-6 -right-6 w-24 h-24 rounded-full bg-warning opacity-5 group-hover:opacity-10 transition-opacity duration-300" />
        <div className="flex justify-between items-start mb-2 relative z-10">
          <div>
            <p className="text-xs font-semibold text-foreground/50 uppercase tracking-wider">Menunggu</p>
            <h2 className="text-3xl font-extrabold text-warning mt-1">{stats.loading ? "..." : stats.pending}</h2>
          </div>
          <div className="p-2 bg-warning-muted text-warning rounded-xl"><Clock size={20} /></div>
        </div>
      </div>

      <div className="group relative glass-panel p-5 rounded-2xl border border-glass-border shadow-sm overflow-hidden">
        <div className="absolute -top-6 -right-6 w-24 h-24 rounded-full bg-success opacity-5 group-hover:opacity-10 transition-opacity duration-300" />
        <div className="flex justify-between items-start mb-2 relative z-10">
          <div>
            <p className="text-xs font-semibold text-foreground/50 uppercase tracking-wider">Selesai</p>
            <h2 className="text-3xl font-extrabold text-success mt-1">{stats.loading ? "..." : stats.completed}</h2>
          </div>
          <div className="p-2 bg-success-muted text-success rounded-xl"><CheckCircle size={20} /></div>
        </div>
      </div>
    </div>
  );
}
