import { BadgeVariant } from "@/components/ui/Badge";
import { APP_STRINGS } from "@/constants";

export type ScheduleStatus = "expired" | "ongoing" | "full" | "available";

export interface ScheduleStatusInput {
  date: string;
  start_time: string;
  end_time: string;
  quota: number;
  booked: number;
  is_available: boolean;
}

export interface ScheduleStatusInfo {
  status: ScheduleStatus;
  label: string;
  badgeVariant: BadgeVariant;
  isBookable: boolean;
  isExpired: boolean;
  isOngoing: boolean;
  remainingQuota: number;
}

function parseTime(dateStr: string, timeStr: string): Date | null {
  if (!dateStr || !timeStr) return null;
  const dPart = dateStr.includes("T") ? dateStr.split("T")[0] : dateStr;
  const [y, m, d] = dPart.split("-").map(Number);
  if (!y || !m || !d) return null;
  const parts = timeStr.split(":").map(Number);
  return new Date(y, m - 1, d, parts[0] || 0, parts[1] || 0, parts[2] || 0);
}

function buildStatusInfo(
  status: ScheduleStatus,
  label: string,
  badgeVariant: BadgeVariant,
  isBookable: boolean,
  isExpired: boolean,
  isOngoing: boolean,
  remainingQuota: number,
): ScheduleStatusInfo {
  return { status, label, badgeVariant, isBookable, isExpired, isOngoing, remainingQuota };
}

function resolveStatusKind(isExpired: boolean, isOngoing: boolean, isFull: boolean, isAvailable: boolean): ScheduleStatus {
  if (isExpired || !isAvailable) return "expired";
  if (isOngoing) return "ongoing";
  if (isFull) return "full";
  return "available";
}

export function getScheduleStatus(schedule: ScheduleStatusInput, refDate?: Date): ScheduleStatusInfo {
  const now = refDate || new Date();
  const startDt = parseTime(schedule.date, schedule.start_time);
  const endDt = parseTime(schedule.date, schedule.end_time);

  const isExpired = endDt ? now > endDt : !schedule.is_available;
  const isOngoing = !isExpired && startDt && endDt ? now >= startDt && now <= endDt : false;
  const remainingQuota = Math.max(0, schedule.quota - schedule.booked);
  const isFull = remainingQuota <= 0;
  const kind = resolveStatusKind(isExpired, isOngoing, isFull, schedule.is_available);

  return buildStatusResult(kind, isFull, remainingQuota);
}

function buildStatusResult(kind: ScheduleStatus, isFull: boolean, remainingQuota: number): ScheduleStatusInfo {
  const labels = APP_STRINGS.scheduleCalendar;
  switch (kind) {
    case "expired":
      return buildStatusInfo("expired", labels.expired, "neutral", false, true, false, remainingQuota);
    case "ongoing":
      return buildStatusInfo("ongoing", isFull ? labels.full : labels.ongoing, isFull ? "error" : "info", !isFull, false, true, remainingQuota);
    case "full":
      return buildStatusInfo("full", labels.full, "error", false, false, false, remainingQuota);
    default:
      return buildStatusInfo("available", labels.available, "success", true, false, false, remainingQuota);
  }
}
