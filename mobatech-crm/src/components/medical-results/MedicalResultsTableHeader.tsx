const TH_CLASS = "align-middle whitespace-nowrap py-3 px-4 text-xs font-bold uppercase tracking-wider text-foreground/50";

export function MedicalResultsTableHeader() {
  return (
    <thead>
      <tr className="border-b border-glass-border bg-overlay-dark] dark:bg-overlay-light]">
        <th className={`${TH_CLASS} text-center`}>Tanggal</th>
        <th className={`${TH_CLASS} text-center`}>Pasien</th>
        <th className={`${TH_CLASS} text-center`}>Dokter</th>
        <th className={`${TH_CLASS} text-center`}>Pemeriksaan</th>
        <th className={`${TH_CLASS} text-center`}>Ringkasan Hasil</th>
        <th className={`${TH_CLASS} text-center`}>Aksi</th>
      </tr>
    </thead>
  );
}
