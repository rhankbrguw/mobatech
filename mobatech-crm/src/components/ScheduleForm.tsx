import { APP_STRINGS } from "@/lib/constants";
import { Button } from "@/components/ui/Button";

interface ScheduleFormProps {
  loading: boolean;
  date: string;
  setDate: (val: string) => void;
  startTime: string;
  setStartTime: (val: string) => void;
  endTime: string;
  setEndTime: (val: string) => void;
  quota: number;
  setQuota: (val: number) => void;
  onSubmit: (e: React.FormEvent) => void;
}

export function ScheduleForm({
  loading, date, setDate, startTime, setStartTime, endTime, setEndTime, quota, setQuota, onSubmit
}: ScheduleFormProps) {
  return (
    <form onSubmit={onSubmit} className="p-4 rounded-xl border border-glass-border bg-black/5 dark:bg-white/5 space-y-4">
      <p className="text-xs font-bold text-foreground/80 uppercase tracking-wider">{APP_STRINGS.schedules.addBtn}</p>
      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="block text-xs font-semibold mb-2">{APP_STRINGS.schedules.dateLabel}</label>
          <input disabled={loading} type="date" required value={date} onChange={(e) => setDate(e.target.value)} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none transition-all" placeholder={APP_STRINGS.schedules.datePlaceholder} />
        </div>
        <div>
          <label className="block text-xs font-semibold mb-2">{APP_STRINGS.schedules.quotaLabel}</label>
          <input disabled={loading} type="number" required value={quota} onChange={(e) => setQuota(Number(e.target.value))} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none transition-all" placeholder={APP_STRINGS.schedules.quotaPlaceholder} />
        </div>
      </div>
      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="block text-xs font-semibold mb-2">{APP_STRINGS.schedules.startLabel}</label>
          <input disabled={loading} type="text" required placeholder={APP_STRINGS.schedules.startPlaceholder} value={startTime} onChange={(e) => setStartTime(e.target.value)} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none transition-all" />
        </div>
        <div>
          <label className="block text-xs font-semibold mb-2">{APP_STRINGS.schedules.endLabel}</label>
          <input disabled={loading} type="text" required placeholder={APP_STRINGS.schedules.endPlaceholder} value={endTime} onChange={(e) => setEndTime(e.target.value)} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none transition-all" />
        </div>
      </div>
      <Button type="submit" disabled={loading} size="sm" className="w-full">{APP_STRINGS.schedules.saveBtn}</Button>
    </form>
  );
}
