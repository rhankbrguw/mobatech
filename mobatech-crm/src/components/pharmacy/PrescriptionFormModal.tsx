import { useState } from "react";
import { Modal } from "@/components/Modal";
import { Button } from "@/components/ui/Button";
import { Prescription, Medicine, PrescriptionItem } from "@/types/api";
import { Pill, Plus } from "lucide-react";
import { PrescriptionItemCard, PrescriptionEmptyState } from "./PrescriptionItemCard";

interface PrescriptionFormModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSave: (prescription: Partial<Prescription>) => Promise<void>;
  initialAppointmentId?: number;
  initialUserId?: number;
  initialDoctorName?: string;
  initialDiagnosis?: string;
  medicines: Medicine[];
}

export function PrescriptionFormModal({
  isOpen, onClose, onSave,
  initialAppointmentId, initialUserId,
  initialDoctorName, initialDiagnosis, medicines
}: PrescriptionFormModalProps) {
  const [form, setForm] = useState<Partial<Prescription>>({
    user_id: initialUserId || 0,
    appointment_id: initialAppointmentId || 0,
    doctor_name: initialDoctorName || "",
    diagnosis: initialDiagnosis || "",
    items: []
  });
  const [isSaving, setIsSaving] = useState(false);

  const addItem = () => {
    const item = { medicine_id: 0, custom_medicine: "", dosage_instruction: "", duration: "", quantity: 1, notes: "" } as PrescriptionItem;
    setForm(f => ({ ...f, items: [...(f.items || []), item] }));
  };

  const removeItem = (i: number) => {
    setForm(f => ({ ...f, items: f.items?.filter((_, idx) => idx !== i) }));
  };

  const updateItem = (i: number, field: string, val: string | number) => {
    setForm(f => {
      const next = [...(f.items || [])] as PrescriptionItem[];
      next[i] = { ...next[i], [field]: val };
      return { ...f, items: next };
    });
  };

  const handleSubmit = async () => {
    if (!form.user_id || !form.items?.length) return;
    setIsSaving(true);
    try {
      const processed = {
        ...form,
        items: form.items.map(i => ({ ...i, medicine_id: i.medicine_id === 0 ? null : i.medicine_id }))
      };
      await onSave(processed);
      onClose();
    } finally { setIsSaving(false); }
  };

  const setField = (key: string, v: string | number) => setForm(f => ({ ...f, [key]: v }));

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="Terbitkan E-Resep Baru">
      <div className="space-y-5">
        {/* ── Metadata ── */}
        <div className="grid grid-cols-2 gap-3">
          <Field label="ID Pasien *" type="number" value={form.user_id || ""} onChange={v => setField("user_id", v === "" ? 0 : Number(v))} />
          <Field label="ID Janji Temu" type="number" value={form.appointment_id || ""} onChange={v => setField("appointment_id", v === "" ? 0 : Number(v))} />
          <Field label="Nama Dokter" value={form.doctor_name || ""} onChange={v => setField("doctor_name", v)} />
          <Field label="Diagnosa Medis" value={form.diagnosis || ""} onChange={v => setField("diagnosis", v)} />
        </div>

        {/* ── Medicine List ── */}
        <div className="space-y-3">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Pill size={16} className="text-primary" />
              <span className="text-sm font-bold">Daftar Obat</span>
              {(form.items?.length ?? 0) > 0 && (
                <span className="text-xs font-bold bg-primary/15 text-primary px-2 py-0.5 rounded-full">{form.items?.length}</span>
              )}
            </div>
            <button type="button" onClick={addItem} className="flex items-center gap-1.5 text-xs font-bold text-primary hover:text-primary/80 bg-primary/10 hover:bg-primary/20 px-3 py-1.5 rounded-full transition-colors cursor-pointer">
              <Plus size={14} /> Tambah
            </button>
          </div>

          {!form.items?.length && <PrescriptionEmptyState onAdd={addItem} />}

          <div className="space-y-2">
            {form.items?.map((item: PrescriptionItem, idx: number) => (
              <PrescriptionItemCard key={idx} item={item} index={idx} medicines={medicines} onUpdate={updateItem} onRemove={removeItem} />
            ))}
          </div>
        </div>

        {/* ── Footer ── */}
        <div className="flex justify-end gap-2 pt-2 border-t border-glass-border/50">
          <Button variant="ghost" onClick={onClose} disabled={isSaving}>Batal</Button>
          <Button onClick={handleSubmit} isLoading={isSaving} disabled={!form.items?.length || !form.user_id}>Terbitkan E-Resep</Button>
        </div>
      </div>
    </Modal>
  );
}

function Field({ label, value, onChange, type = "text" }: { label: string; value: string | number; onChange: (v: string) => void; type?: string }) {
  return (
    <div className="space-y-1">
      <label className="text-xs text-foreground/50 font-semibold">{label}</label>
      <input type={type} value={value} onChange={e => onChange(e.target.value)} className="w-full glass-input rounded-xl px-3 py-2 text-sm text-foreground" />
    </div>
  );
}
