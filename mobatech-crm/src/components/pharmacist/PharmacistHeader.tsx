import { Formatters } from "@/lib/formatters";

interface PharmacistHeaderProps {
  greeting: string;
  displayName: string;
}

export function PharmacistHeader({ greeting, displayName }: PharmacistHeaderProps) {
  return (
    <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
      <div>
        <p className="text-sm text-foreground/50">{greeting} 👋</p>
        <h2 className="text-2xl font-extrabold tracking-tight text-foreground mt-0.5">
          {displayName}
        </h2>
        <p className="text-xs text-foreground/50 mt-1">
          {Formatters.date(new Date(), "weekday")}
        </p>
      </div>
    </div>
  );
}
