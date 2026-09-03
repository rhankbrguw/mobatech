import { Formatters } from "@/lib/formatters";

interface DoctorHeaderProps {
  greeting: string;
  displayName: string;
  completed: number;
  today: number;
  progress: number;
}

export function DoctorHeader({ greeting, displayName, completed, today, progress: _progress }: DoctorHeaderProps) {
  return (
    <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
      <div>
        <p className="text-sm text-foreground/50">{greeting} 👋</p>
        <h2 className="text-2xl font-extrabold tracking-tight text-foreground mt-0.5">
          {displayName}
        </h2>
        <p className="text-xs text-foreground/50 mt-1">
          {Formatters.date(new Date(), "weekday")}
        </p>
      </div>
      <div className="flex flex-col items-end">
        <div className="text-xs font-semibold text-foreground/50 mb-1">Progress Pasien ({completed}/{today})</div>
        <div className="w-32 h-2.5 bg-overlay-dark dark:bg-overlay-light rounded-full overflow-hidden">
          <div 
            className="h-full bg-primary transition-all duration-1000 w-full" 
          />
        </div>
      </div>
    </div>
  );
}
