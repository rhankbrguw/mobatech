import { FilterDropdown } from "@/components/ui/FilterDropdown";
import { SearchFilterBar } from "@/components/ui/SearchFilterBar";
import { APP_STRINGS } from "@/constants";

interface UsersHeaderControlsProps {
  roleFilter: string;
  onRoleFilterChange: (val: string) => void;
  searchQuery: string;
  onSearchQueryChange: (val: string) => void;
}

const ROLE_OPTIONS = [
  { label: 'Admin', value: 'admin' },
  { label: 'Dokter', value: 'doctor' },
  { label: 'Apoteker', value: 'pharmacist' },
  { label: 'Pasien', value: 'patient' },
];

export function UsersHeaderControls({
  roleFilter,
  onRoleFilterChange,
  searchQuery,
  onSearchQueryChange,
}: UsersHeaderControlsProps) {
  return (
    <div className="flex justify-end items-center mb-4">
      <div className="flex gap-2 w-full sm:w-auto">
        <FilterDropdown
          value={roleFilter}
          onChange={onRoleFilterChange}
          options={ROLE_OPTIONS}
          placeholder={APP_STRINGS.common.searchFilter}
        />
        <SearchFilterBar value={searchQuery} onChange={onSearchQueryChange} />
      </div>
    </div>
  );
}
