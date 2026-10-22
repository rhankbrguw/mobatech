import Image from "next/image";
import { Doctor } from "@/types/api";
import { SideDrawer } from "@/components/ui/SideDrawer";
import { Badge } from "@/components/ui/Badge";
import { Formatters } from "@/lib/formatters";
import { Award, Calendar, FileText, Phone, Stethoscope } from "lucide-react";
import { APP_STRINGS } from "@/constants";

interface DoctorDetailViewProps {
  isOpen: boolean;
  onClose: () => void;
  drawerItem: Doctor | null;
}

export function DoctorDetailView({ isOpen, onClose, drawerItem }: DoctorDetailViewProps) {
  if (!drawerItem) return null;

  const avatar = drawerItem.image_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(drawerItem.name)}&background=113C2B&color=fff`;
  const id = drawerItem.id || (drawerItem as { ID?: number }).ID || 0;

  return (
    <SideDrawer isOpen={isOpen} onClose={onClose} title={APP_STRINGS.details.doctorTitle}>
      <div className="space-y-6">
        <div className="flex flex-col items-center text-center p-4 rounded-2xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
          <Image unoptimized width={80} height={80} src={avatar} alt={drawerItem.name} className="w-20 h-20 rounded-full object-cover border-2 border-primary shadow-md mb-3" />
          <h3 className="text-lg font-bold text-foreground">{drawerItem.name}</h3>
          <p className="text-xs text-foreground/60 mb-2">ID Dokter: {id}</p>
          <Badge variant={drawerItem.is_active ? "success" : "error"}>
            {drawerItem.is_active ? APP_STRINGS.details.activeDoctor : APP_STRINGS.details.inactiveDoctor}
          </Badge>
        </div>

        <div className="space-y-3">
          <h4 className="text-xs font-bold uppercase tracking-wider text-foreground/50">{APP_STRINGS.details.doctorPracticeSection}</h4>
          <div className="space-y-2 text-xs">
            <div className="flex items-center gap-3 p-3 rounded-xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
              <Stethoscope size={16} className="text-primary shrink-0" />
              <div>
                <div className="text-foreground/50 text-[11px]">{APP_STRINGS.details.polyclinic}</div>
                <div className="font-semibold text-foreground">{drawerItem.polyclinic?.name || "-"}</div>
              </div>
            </div>

            <div className="flex items-center gap-3 p-3 rounded-xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
              <Award size={16} className="text-primary shrink-0" />
              <div>
                <div className="text-foreground/50 text-[11px]">{APP_STRINGS.details.specialization}</div>
                <div className="font-semibold text-foreground">{drawerItem.specialization}</div>
              </div>
            </div>

            <div className="flex items-center gap-3 p-3 rounded-xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
              <Phone size={16} className="text-primary shrink-0" />
              <div>
                <div className="text-foreground/50 text-[11px]">{APP_STRINGS.details.contactPhone}</div>
                <div className="font-semibold text-foreground">{Formatters.phone(drawerItem.contact_info)}</div>
              </div>
            </div>

            <div className="flex items-center gap-3 p-3 rounded-xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
              <Calendar size={16} className="text-primary shrink-0" />
              <div>
                <div className="text-foreground/50 text-[11px]">{APP_STRINGS.details.practiceStatus}</div>
                <div className="font-semibold text-foreground">
                  {drawerItem.is_available_today ? "Tersedia Praktik Hari Ini" : "Tidak Ada Jadwal Hari Ini"}
                </div>
              </div>
            </div>

            <div className="flex items-start gap-3 p-3 rounded-xl bg-overlay-dark dark:bg-overlay-light border border-glass-border">
              <FileText size={16} className="text-primary shrink-0 mt-0.5" />
              <div>
                <div className="text-foreground/50 text-[11px]">{APP_STRINGS.details.description}</div>
                <div className="font-normal text-foreground/80 leading-relaxed mt-0.5">
                  {drawerItem.description || "-"}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </SideDrawer>
  );
}
