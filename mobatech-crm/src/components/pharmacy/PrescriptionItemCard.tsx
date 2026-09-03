import { PrescriptionItem, Medicine } from "@/types/api";
import { Plus, Trash2 } from "lucide-react";

interface PrescriptionItemCardProps {
  item: PrescriptionItem;
  index: number;
  medicines: Medicine[];
  onUpdate: (index: number, field: string, val: string | number) => void;
  onRemove: (index: number) => void;
}

export function PrescriptionItemCard({
  item, index, medicines, onUpdate, onRemove
}: PrescriptionItemCardProps) {
  return (
    <div className="relative bg-overlay-dark] dark:bg-surface-primary/[0.04] border border-glass-border/60 hover:border-primary/30 rounded-2xl p-3 transition-colors group">
      {/* Row 1: Obat + Delete */}
      <div className="flex items-start gap-2 mb-2">
        <div className="w-8 h-8 shrink-0 rounded-xl bg-primary/10 flex items-center justify-center text-primary text-xs font-black">
          {index + 1}
        </div>
        <div className="flex-1 min-w-0">
          <select
            value={item.medicine_id || 0}
            onChange={e => onUpdate(index, "medicine_id", e.target.value === "" ? 0 : Number(e.target.value))}
            className="w-full glass-input rounded-lg px-2.5 py-1.5 text-sm font-medium cursor-pointer"
          >
            <option value={0}>✏️ Obat Manual / Kustom</option>
            {medicines.map((m, idx) => (
              <option key={`${m.id}-${idx}`} value={m.id}>{m.name}</option>
            ))}
          </select>
          {(!item.medicine_id || item.medicine_id === 0) && (
            <input
              type="text"
              placeholder="Ketik nama obat..."
              value={item.custom_medicine || ""}
              onChange={e => onUpdate(index, "custom_medicine", e.target.value)}
              className="w-full glass-input rounded-lg px-2.5 py-1.5 text-sm mt-1.5"
            />
          )}
        </div>
        <button
          type="button"
          onClick={() => onRemove(index)}
          className="w-7 h-7 shrink-0 rounded-lg text-error hover:text-error hover:bg-error-muted flex items-center justify-center transition-colors opacity-0 group-hover:opacity-100 cursor-pointer"
          title="Hapus obat"
        >
          <Trash2 size={14} />
        </button>
      </div>

      {/* Row 2: Dosis + Durasi + Qty (compact) */}
      <div className="flex items-center gap-2 pl-10">
        <div className="flex-1 min-w-0">
          <input
            type="text"
            placeholder="Dosis: 3x1 sesudah makan"
            value={item.dosage_instruction}
            onChange={e => onUpdate(index, "dosage_instruction", e.target.value)}
            className="w-full glass-input rounded-lg px-2.5 py-1 text-xs"
          />
        </div>
        <input
          type="text"
          placeholder="Durasi"
          value={item.duration}
          onChange={e => onUpdate(index, "duration", e.target.value)}
          className="w-20 glass-input rounded-lg px-2 py-1 text-xs text-center shrink-0"
        />
        <div className="flex items-center gap-1 shrink-0">
          <span className="text-[10px] text-foreground/40 font-bold">QTY</span>
          <input
            type="number"
            min={1}
            value={item.quantity}
            onChange={e => onUpdate(index, "quantity", e.target.value === "" ? 1 : Number(e.target.value))}
            className="w-14 glass-input rounded-lg px-2 py-1 text-xs text-center"
          />
        </div>
      </div>
    </div>
  );
}

/* ── Empty state for no items ── */
export function PrescriptionEmptyState({ onAdd }: { onAdd: () => void }) {
  return (
    <button
      type="button"
      onClick={onAdd}
      className="w-full py-8 border-2 border-dashed border-glass-border hover:border-primary/40 rounded-2xl text-foreground/40 hover:text-primary text-sm flex flex-col items-center gap-2 transition-colors cursor-pointer group"
    >
      <Plus size={24} className="opacity-40 group-hover:opacity-100 transition-opacity" />
      Klik untuk menambahkan obat
    </button>
  );
}
