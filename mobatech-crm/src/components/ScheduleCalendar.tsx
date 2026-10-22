"use client";
import { useState } from "react";
import { DoctorSchedule } from "@/types/api";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { Formatters } from "@/lib/formatters";
import { APP_STRINGS } from "@/constants";
import { ScheduleCard } from "./ScheduleCard";
import { getScheduleStatus } from "@/lib/scheduleStatus";

interface Props {
  groupedSchedules: Record<string, DoctorSchedule[]>;
}

function CalendarMonthHeader({ currentDate, onPrev, onNext }: { currentDate: Date; onPrev: () => void; onNext: () => void }) {
  return (
    <div className="flex items-center justify-between mb-6">
      <h2 className="text-lg font-bold text-primary">{Formatters.date(currentDate, "long")}</h2>
      <div className="flex gap-2">
        <button onClick={onPrev} aria-label="Bulan Sebelumnya" className="p-2 rounded-xl hover:bg-overlay-dark dark:hover:bg-overlay-light transition-colors">
          <ChevronLeft size={20} />
        </button>
        <button onClick={onNext} aria-label="Bulan Berikutnya" className="p-2 rounded-xl hover:bg-overlay-dark dark:hover:bg-overlay-light transition-colors">
          <ChevronRight size={20} />
        </button>
      </div>
    </div>
  );
}

function CalendarDayCell({ d, isSelected, isToday, schedules, onSelect }: { d: Date; isSelected: boolean; isToday: boolean; schedules: DoctorSchedule[]; onSelect: () => void }) {
  const schedCount = schedules.length;
  const hasActive = schedules.some((s) => !getScheduleStatus(s).isExpired);
  const badgeCls = isSelected ? "bg-success text-success-foreground" : hasActive ? "bg-primary text-primary-foreground" : "bg-foreground/20 text-foreground/60";

  return (
    <button
      onClick={onSelect}
      className={`relative aspect-square rounded-xl flex items-center justify-center transition-all ${isSelected ? "bg-primary text-primary-foreground shadow-md scale-105" : "hover:bg-overlay-dark dark:hover:bg-overlay-light bg-background border border-glass-border"} ${isToday && !isSelected ? "ring-2 ring-primary ring-offset-1 ring-offset-background" : ""}`}
    >
      <span className="text-sm sm:text-base font-semibold">{d.getDate()}</span>
      {schedCount > 0 && (
        <div className={`absolute -top-1.5 -right-1.5 flex h-4 min-w-[1rem] items-center justify-center rounded-full text-[9px] font-bold px-1 ring-2 ring-background shadow-sm ${badgeCls}`}>
          {schedCount}
        </div>
      )}
    </button>
  );
}

export function ScheduleCalendar({ groupedSchedules }: Props) {
  const [currentDate, setCurrentDate] = useState(new Date());
  const [selectedDateStr, setSelectedDateStr] = useState<string | null>(new Date().toLocaleDateString("en-CA"));

  const year = currentDate.getFullYear();
  const month = currentDate.getMonth();
  const daysInMonth = new Date(year, month + 1, 0).getDate();
  const firstDayOfMonth = new Date(year, month, 1).getDay();

  const days: (Date | null)[] = [];
  for (let i = 0; i < firstDayOfMonth; i++) days.push(null);
  for (let i = 1; i <= daysInMonth; i++) days.push(new Date(year, month, i));

  const selectedSchedules = selectedDateStr ? groupedSchedules[selectedDateStr] || [] : [];
  const todayStr = `${new Date().getFullYear()}-${String(new Date().getMonth() + 1).padStart(2, "0")}-${String(new Date().getDate()).padStart(2, "0")}`;

  return (
    <div className="space-y-6">
      <div className="border border-glass-border bg-overlay-dark dark:bg-overlay-light rounded-2xl p-2.5 sm:p-4 md:p-6 backdrop-blur-md">
        <CalendarMonthHeader currentDate={currentDate} onPrev={() => setCurrentDate(new Date(year, month - 1, 1))} onNext={() => setCurrentDate(new Date(year, month + 1, 1))} />
        <div className="grid grid-cols-7 gap-1 sm:gap-2 md:gap-4 mb-2 text-center text-xs font-semibold text-foreground/50">
          <div>Min</div><div>Sen</div><div>Sel</div><div>Rab</div><div>Kam</div><div>Jum</div><div>Sab</div>
        </div>
        <div className="grid grid-cols-7 gap-1 sm:gap-2 md:gap-4">
          {days.map((d, i) => {
            if (!d) return <div key={i} className="aspect-square" />;
            const dStr = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(d.getDate()).padStart(2, "0")}`;
            return (
              <CalendarDayCell
                key={i}
                d={d}
                isSelected={selectedDateStr === dStr}
                isToday={dStr === todayStr}
                schedules={groupedSchedules[dStr] || []}
                onSelect={() => setSelectedDateStr(dStr)}
              />
            );
          })}
        </div>
      </div>

      {selectedDateStr && (
        <div className="mt-8">
          <h3 className="font-bold text-lg mb-4 text-foreground flex items-center gap-2">
            {APP_STRINGS.scheduleCalendar.schedulePrefix} {Formatters.date(selectedDateStr, "weekday")}
          </h3>
          {selectedSchedules.length === 0 ? (
            <div className="text-center py-12 text-foreground/50 bg-overlay-dark dark:bg-overlay-light rounded-2xl border border-dashed border-glass-border">
              {APP_STRINGS.scheduleCalendar.noSchedule}
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6 animate-in slide-in-from-bottom-4 fade-in duration-300">
              {selectedSchedules.map((s) => (
                <ScheduleCard key={s.id} schedule={s} />
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  );
}
