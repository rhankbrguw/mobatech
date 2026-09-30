"use client";
import React from "react";
import Image from "next/image";
import { Clock } from "lucide-react";
import { DoctorSchedule } from "@/types/api";
import { Badge } from "./ui/Badge";
import { APP_STRINGS } from "@/constants";
import { getScheduleStatus } from "@/lib/scheduleStatus";

interface ScheduleCardProps {
  schedule: DoctorSchedule;
}

function DoctorAvatar({ name, imageUrl }: { name?: string; imageUrl?: string }) {
  return (
    <div className="w-11 h-11 rounded-full bg-background flex items-center justify-center overflow-hidden border border-glass-border shadow-sm group-hover:scale-105 transition-transform duration-300">
      {imageUrl ? (
        <Image unoptimized width={100} height={100} src={imageUrl} alt={name || "Doctor"} className="w-full h-full object-cover" />
      ) : (
        <span className="text-primary font-bold text-sm">{name?.charAt(0) || "D"}</span>
      )}
    </div>
  );
}

function ScheduleQuota({ isExpired, remainingQuota, booked, quota, badgeVariant }: { isExpired: boolean; remainingQuota: number; booked: number; quota: number; badgeVariant: string }) {
  const barColor = isExpired ? "bg-foreground/20" : badgeVariant === "error" ? "bg-error" : badgeVariant === "info" ? "bg-info" : "bg-primary";
  return (
    <div className="z-10 w-full space-y-1.5 mt-auto">
      <div className="flex justify-between items-end text-xs">
        <span className="text-foreground/70 font-medium">
          {isExpired ? APP_STRINGS.scheduleCalendar.sessionEnded : `${APP_STRINGS.scheduleCalendar.quotaAvailable}: `}
          {!isExpired && <span className="text-foreground font-bold">{remainingQuota}</span>}
        </span>
        <span className="text-foreground/50 text-[10px]">
          {APP_STRINGS.scheduleCalendar.quotaFilled} {booked}/{quota}
        </span>
      </div>
      <div className="h-1.5 w-full bg-overlay-dark dark:bg-overlay-light rounded-full overflow-hidden">
        <div className={`h-full rounded-full transition-all duration-1000 ${barColor} w-full`} />
      </div>
    </div>
  );
}

export function ScheduleCard({ schedule }: ScheduleCardProps) {
  const statusInfo = getScheduleStatus(schedule);
  const isExp = statusInfo.isExpired;

  return (
    <div className={`group relative p-5 rounded-2xl border border-glass-border flex flex-col gap-4 transition-all duration-300 overflow-hidden cursor-pointer ${isExp ? "opacity-75 bg-overlay-dark/40 dark:bg-overlay-light/40" : "bg-overlay-dark dark:bg-overlay-light hover:border-primary/40 hover:shadow-lg"}`}>
      <div className="absolute top-0 right-0 w-24 h-24 bg-primary/5 rounded-bl-full pointer-events-none transition-colors group-hover:bg-primary/10" />
      <div className="flex items-start justify-between z-10">
        <div className="flex items-center gap-4">
          <DoctorAvatar name={schedule.doctor?.name} imageUrl={schedule.doctor?.image_url} />
          <div>
            <div className="font-bold text-sm text-foreground tracking-tight line-clamp-1">{schedule.doctor?.name || APP_STRINGS.scheduleCalendar.defaultDoctor}</div>
            <div className="text-xs text-foreground/60">{schedule.doctor?.specialization || APP_STRINGS.scheduleCalendar.defaultSpecialization}</div>
          </div>
        </div>
        <Badge variant={statusInfo.badgeVariant} className="shadow-sm">
          {statusInfo.label}
        </Badge>
      </div>

      <div className="flex items-center gap-4 py-3 border-y border-glass-border/50 z-10">
        <div className={`flex items-center gap-1.5 px-2.5 py-1 rounded-lg ${isExp ? "bg-foreground/5 text-foreground/50" : "text-primary bg-primary/10"}`}>
          <Clock size={14} className="opacity-70" />
          <span className="text-xs font-bold">{schedule.start_time} - {schedule.end_time}</span>
        </div>
      </div>

      <ScheduleQuota isExpired={isExp} remainingQuota={statusInfo.remainingQuota} booked={schedule.booked} quota={schedule.quota} badgeVariant={statusInfo.badgeVariant} />
    </div>
  );
}
