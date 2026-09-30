import Image from "next/image";
import { User } from "@/types/api";
import { SideDrawer } from "@/components/ui/SideDrawer";
import { Badge } from "@/components/ui/Badge";
import { Formatters } from "@/lib/formatters";
import { Mail, Phone, Calendar, HeartPulse, Activity, AlertTriangle } from "lucide-react";
import { APP_STRINGS } from "@/constants";

interface PatientDetailDrawerProps {
  isOpen: boolean;
  onClose: () => void;
  patient: User | null;
}

export function PatientDetailDrawer({
  isOpen,
  onClose,
  patient,
}: PatientDetailDrawerProps) {
  if (!patient) return null;

  const avatar = patient.image_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(patient.full_name)}&background=113C2B&color=fff`;
  const id = patient.id || (patient as { ID?: number }).ID || 0;

  return (
    <SideDrawer isOpen={isOpen} onClose={onClose} title={APP_STRINGS.details.patientTitle}>
      <div className="space-y-6">
        <div className="flex flex-col items-center text-center p-4 rounded-2xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
          <Image unoptimized width={80} height={80} src={avatar} alt={patient.full_name} className="w-20 h-20 rounded-full object-cover border-2 border-primary shadow-md mb-3" />
          <h3 className="text-lg font-bold text-foreground">{patient.full_name}</h3>
          <p className="text-xs text-foreground/60 mb-2">ID Pasien: {id}</p>
          <Badge variant="info">{APP_STRINGS.details.registeredPatient}</Badge>
        </div>

        <div className="space-y-3">
          <h4 className="text-xs font-bold uppercase tracking-wider text-foreground/50">{APP_STRINGS.details.contactAccountSection}</h4>
          <div className="space-y-2 text-xs">
            <div className="flex items-center gap-3 p-3 rounded-xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
              <Mail size={16} className="text-primary shrink-0" />
              <div>
                <div className="text-foreground/50 text-[11px]">{APP_STRINGS.details.email}</div>
                <div className="font-semibold text-foreground">{patient.email}</div>
              </div>
            </div>

            <div className="flex items-center gap-3 p-3 rounded-xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
              <Phone size={16} className="text-primary shrink-0" />
              <div>
                <div className="text-foreground/50 text-[11px]">{APP_STRINGS.details.phone}</div>
                <div className="font-semibold text-foreground">{Formatters.phone(patient.phone_number)}</div>
              </div>
            </div>

            <div className="flex items-center gap-3 p-3 rounded-xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
              <Calendar size={16} className="text-primary shrink-0" />
              <div>
                <div className="text-foreground/50 text-[11px]">{APP_STRINGS.details.dob} / {APP_STRINGS.details.gender}</div>
                <div className="font-semibold text-foreground">{patient.date_of_birth || "-"} • {patient.gender || "-"}</div>
              </div>
            </div>
          </div>
        </div>

        <div className="space-y-3">
          <h4 className="text-xs font-bold uppercase tracking-wider text-foreground/50">{APP_STRINGS.details.medicalRecordSection}</h4>
          <div className="space-y-2 text-xs">
            <div className="flex items-center gap-3 p-3 rounded-xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
              <HeartPulse size={16} className="text-primary shrink-0" />
              <div>
                <div className="text-foreground/50 text-[11px]">{APP_STRINGS.details.bloodType}</div>
                <div className="font-semibold text-foreground">{patient.blood_type || "-"}</div>
              </div>
            </div>

            <div className="flex items-center gap-3 p-3 rounded-xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
              <Activity size={16} className="text-primary shrink-0" />
              <div>
                <div className="text-foreground/50 text-[11px]">{APP_STRINGS.details.heightWeight}</div>
                <div className="font-semibold text-foreground">{patient.height ? `${patient.height} cm` : "-"} / {patient.weight ? `${patient.weight} kg` : "-"}</div>
              </div>
            </div>

            <div className="flex items-center gap-3 p-3 rounded-xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
              <AlertTriangle size={16} className="text-primary shrink-0" />
              <div>
                <div className="text-foreground/50 text-[11px]">{APP_STRINGS.details.allergies}</div>
                <div className="font-semibold text-foreground">{patient.allergies || APP_STRINGS.details.noAllergies}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </SideDrawer>
  );
}
