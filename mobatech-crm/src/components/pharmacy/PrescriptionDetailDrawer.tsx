import { Prescription } from "@/types/api";
import { SideDrawer } from "@/components/ui/SideDrawer";
import { Pill, CheckCircle } from "lucide-react";
import { Button } from "@/components/ui/Button";

interface Props {
  prescription: Prescription | null;
  onClose: () => void;
  onProcess: (id: number) => void;
}

export function PrescriptionDetailDrawer({ prescription, onClose, onProcess }: Props) {
  if (!prescription) return null;

  return (
    <SideDrawer isOpen={!!prescription} onClose={onClose} title="Detail E-Resep">
      <div className="space-y-6 pb-6">
        <div className="bg-overlay-dark dark:bg-overlay-light p-4 rounded-2xl border border-glass-border">
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <div className="text-foreground/50 text-xs mb-1">ID Pasien</div>
              <div className="font-bold">Pasien #{prescription.user_id}</div>
            </div>
            <div>
              <div className="text-foreground/50 text-xs mb-1">Dokter</div>
              <div className="font-bold">{prescription.doctor_name || "-"}</div>
            </div>
            <div className="col-span-2">
              <div className="text-foreground/50 text-xs mb-1">Diagnosa</div>
              <div className="font-medium text-primary">{prescription.diagnosis || "-"}</div>
            </div>
          </div>
        </div>

        <div>
          <h3 className="font-bold text-foreground mb-3 flex items-center gap-2">
            <Pill size={16} className="text-primary" /> Daftar Obat
          </h3>
          
          {(!prescription.items || prescription.items.length === 0) ? (
            <div className="text-center p-6 bg-error-muted border border-error-muted text-error rounded-2xl text-sm">
              Tidak ada daftar obat pada resep ini.
            </div>
          ) : (
            <div className="space-y-3">
              {prescription.items.map((item, idx) => (
                <div key={idx} className="bg-surface-primary/50 dark:bg-foreground/20 backdrop-blur-md p-4 rounded-2xl border border-glass-border flex flex-col gap-2 relative">
                  <div className="flex justify-between items-start">
                    <div>
                      <div className="font-bold text-base text-foreground">
                        {item.medicine?.name || item.custom_medicine || "Obat Manual"}
                      </div>
                      <div className="text-sm font-semibold text-primary">{item.dosage_instruction || "-"}</div>
                    </div>
                    <div className="bg-overlay-dark dark:bg-overlay-light px-3 py-1 rounded-lg text-xs font-bold shrink-0">
                      Qty: {item.quantity}
                    </div>
                  </div>
                  <div className="text-xs text-foreground/70 flex gap-4 mt-2 pt-2 border-t border-glass-border/50">
                    <span><strong className="text-foreground">Durasi:</strong> {item.duration}</span>
                    {item.dosage_instruction && <span><strong className="text-foreground">Aturan:</strong> {item.dosage_instruction}</span>}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>

        {prescription.status === "pending" && (
          <div className="mt-auto pt-4 border-t border-glass-border">
            <Button className="w-full h-12 text-base font-bold bg-info hover:bg-info text-surface-primary" onClick={() => onProcess(prescription.id)} icon={<CheckCircle size={18} />}>
              Tebus & Proses Resep
            </Button>
          </div>
        )}
      </div>
    </SideDrawer>
  );
}
