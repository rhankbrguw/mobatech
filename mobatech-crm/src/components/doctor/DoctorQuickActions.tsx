import Link from "next/link";
import { CalendarDays, CheckCircle, UserPlus } from "lucide-react";

const ACTIONS = [
  { href: "/dashboard/doctors", icon: <CalendarDays size={20}/>, label: "Jadwal Praktik" },
  { href: "/dashboard/medical-results", icon: <CheckCircle size={20}/>, label: "Input Rekam Medis" },
  { href: "/dashboard/patients", icon: <UserPlus size={20}/>, label: "Daftar Pasien" },
];

export function DoctorQuickActions() {
  return (
    <div>
      <h2 className="font-semibold text-sm text-foreground/60 uppercase tracking-wider mb-3">Aksi Cepat</h2>
      <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
        {ACTIONS.map((action) => (
          <Link key={action.href} href={action.href}
            className="glass-panel rounded-2xl border p-4 flex items-center gap-3 hover:bg-primary/5 hover:border-primary/30 transition-all group shadow-sm">
            <div className="p-2.5 rounded-xl bg-primary/10 text-primary group-hover:scale-110 transition-transform duration-200">
              {action.icon}
            </div>
            <span className="text-sm font-semibold text-foreground/80 group-hover:text-primary transition-colors">{action.label}</span>
          </Link>
        ))}
      </div>
    </div>
  );
}
