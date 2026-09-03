"use client";
import { useState } from "react";
import { APP_STRINGS } from "@/constants";
import { Doctor, DoctorSchedule } from "@/types/api";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { doctorService } from "@/services";

import { Modal } from "@/components/Modal";
import { Button } from "@/components/ui/Button";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { ConfirmModal } from "@/components/ConfirmModal";
import { ScheduleForm } from "./ScheduleForm";
import { Formatters } from "@/lib/formatters";
import { FormValidators } from "@/lib/validators";

interface ScheduleModalProps {
  isOpen: boolean; onClose: () => void; doctor: Doctor | null; onChange?: () => void;
}

type ToastState = { isOpen: boolean; message: string; type: "success" | "error" | "warning" | "info" };

function useScheduleModal(isOpen: boolean, doctor: Doctor | null, onChange?: () => void) {
  const queryClient = useQueryClient();
  const [date, setDate] = useState("");
  const [startTime, setStartTime] = useState("");
  const [endTime, setEndTime] = useState("");
  const [quota, setQuota] = useState(10);
  const [toast, setToast] = useState<ToastState>({ isOpen: false, message: "", type: "success" });
  const [deleteConfirmId, setDeleteConfirmId] = useState<number | null>(null);

  const { data: schedulesRes, isLoading: loading } = useQuery({
    queryKey: ["doctorSchedules", doctor?.id],
    queryFn: () => doctorService.getDoctorSchedules(String(doctor!.id)),
    enabled: isOpen && !!doctor,
  });

  const schedules = schedulesRes?.data || [];

  const createMutation = useMutation({
    mutationFn: (payload: Partial<DoctorSchedule>) => doctorService.createDoctorSchedule(payload),
    onSuccess: () => {
      setToast({ isOpen: true, message: APP_STRINGS.schedules.successCreate, type: "success" });
      queryClient.invalidateQueries({ queryKey: ["doctorSchedules", doctor?.id] });
      onChange?.();
      setDate(""); setStartTime(""); setEndTime("");
    },
    onError: (err: unknown) => {
      setToast({ isOpen: true, message: err instanceof Error ? err.message : APP_STRINGS.login.networkError, type: "error" });
    }
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => doctorService.deleteDoctorSchedule(id),
    onSuccess: () => {
      setToast({ isOpen: true, message: APP_STRINGS.schedules.successDelete, type: "success" });
      queryClient.invalidateQueries({ queryKey: ["doctorSchedules", doctor?.id] });
      onChange?.();
      setDeleteConfirmId(null);
    },
    onError: (err: unknown) => {
      setToast({ isOpen: true, message: err instanceof Error ? err.message : APP_STRINGS.login.networkError, type: "error" });
    }
  });

  const handleAdd = (e: React.FormEvent) => {
    e.preventDefault(); if (!doctor) return;
    const quotaError = FormValidators.quota(quota);
    if (quotaError) { setToast({ isOpen: true, message: quotaError, type: "error" }); return; }
    
    const payload = { doctor_id: doctor.id, date: new Date(date).toISOString(), start_time: startTime, end_time: endTime, quota: Number(quota) };
    createMutation.mutate(payload);
  };

  const executeDelete = (id: number) => {
    deleteMutation.mutate(id);
  };

  return { schedules, loading, date, setDate, startTime, setStartTime, endTime, setEndTime, quota, setQuota, toast, setToast, deleteConfirmId, setDeleteConfirmId, handleAdd, executeDelete };
}

function ScheduleListSection({ loading, schedules, onDelete }: { loading: boolean; schedules: DoctorSchedule[]; onDelete: (id: number) => void }) {
  if (loading) return <div className="text-center py-4 text-xs text-foreground/50 animate-pulse">Memuat jadwal...</div>;
  if (schedules.length === 0) return <div className="text-center py-4 text-xs text-foreground/50">Belum ada jadwal praktik.</div>;
  return (
    <div className="space-y-3">
      {schedules.map((sched) => (
        <div key={sched.id} className="flex items-center justify-between p-3 rounded-xl border border-glass-border glass-card">
          <div>
            <p className="text-xs font-bold text-foreground">{Formatters.date(sched.date, "weekday")}</p>
            <p className="text-xs text-foreground/60 mt-0.5">{sched.start_time} - {sched.end_time} | Kuota: {sched.quota} (Terisi: {sched.booked})</p>
          </div>
          <Button size="sm" variant="danger" onClick={() => onDelete(sched.id)}>Hapus</Button>
        </div>
      ))}
    </div>
  );
}

// Migrated to React Query
export function ScheduleModal({ isOpen, onClose, doctor, onChange }: ScheduleModalProps) {
  const m = useScheduleModal(isOpen, doctor, onChange);
  return (
    <Modal isOpen={isOpen} onClose={onClose} title={`${APP_STRINGS.schedules.title} - ${doctor?.name || ""}`}>
      <div className="space-y-6">
        <ScheduleForm loading={m.loading} date={m.date} setDate={m.setDate} startTime={m.startTime} setStartTime={m.setStartTime} endTime={m.endTime} setEndTime={m.setEndTime} quota={m.quota} setQuota={m.setQuota} onSubmit={m.handleAdd} />
        <ScheduleListSection loading={m.loading} schedules={m.schedules} onDelete={m.setDeleteConfirmId} />
      </div>
      <ConfirmModal isOpen={m.deleteConfirmId !== null} onClose={() => m.setDeleteConfirmId(null)} onConfirm={() => m.deleteConfirmId !== null && m.executeDelete(m.deleteConfirmId)} title="Hapus Jadwal" description={APP_STRINGS.schedules.deleteConfirm} confirmText="Ya, Hapus" variant="danger" />
      <CustomSnackbar isOpen={m.toast.isOpen} message={m.toast.message} type={m.toast.type} onClose={() => m.setToast((t) => ({ ...t, isOpen: false }))} />
    </Modal>
  );
}
