import { SearchFilterBar } from "@/components/ui/SearchFilterBar";

interface PharmacistsHeaderControlsProps {
  searchQuery: string;
  onSearchQueryChange: (val: string) => void;
}

export function PharmacistsHeaderControls({
  searchQuery,
  onSearchQueryChange,
}: PharmacistsHeaderControlsProps) {
  return (
    <div className="flex justify-end items-center mb-4">
      <div className="w-full sm:w-72">
        <SearchFilterBar
          value={searchQuery}
          onChange={onSearchQueryChange}
          placeholder="Cari nama, email, kontak apoteker..."
        />
      </div>
    </div>
  );
}
