import { PackageSearch } from "lucide-react";
import { Card } from "@/components/ui/Card";

export function MedicineEmptyState() {
  return (
    <Card noPadding>
      <div className="flex flex-col items-center justify-center p-16 text-center">
        <div className="w-16 h-16 rounded-2xl bg-overlay-dark dark:bg-overlay-light flex items-center justify-center mb-4 border border-glass-border">
          <PackageSearch size={32} className="text-foreground/40" />
        </div>
        <h3 className="text-xl font-bold mb-2 text-foreground">Belum Ada Obat</h3>
        <p className="text-foreground/60 max-w-sm text-sm">
          Daftar obat masih kosong. Silakan tambahkan data obat baru ke dalam inventori katalog.
        </p>
      </div>
    </Card>
  );
}
