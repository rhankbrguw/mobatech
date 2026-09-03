import Link from "next/link";
import { Stethoscope, Bell, FileText, Bot } from "lucide-react";

const ACTIONS = [
  { href: "/dashboard/doctors", icon: <Stethoscope size={20}/>, label: "Dokter Baru" },
  { href: "/dashboard/reminders", icon: <Bell size={20}/>, label: "Pengingat" },
  { href: "/dashboard/medical-results", icon: <FileText size={20}/>, label: "Hasil Medis" },
  { href: "/dashboard/ai-audit", icon: <Bot size={20}/>, label: "Sinkronisasi AI" },
];

export function AdminQuickActions() {
  return (
    <div>
      <h2 className="font-semibold text-sm text-foreground/60 uppercase tracking-wider mb-3">Aksi Cepat</h2>
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
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
